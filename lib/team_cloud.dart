import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';
import 'local_database.dart';
import 'setnote_widgets.dart';

/// Pagina di gestione per il download delle squadre dal DB.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class TeamDownloader extends StatefulWidget {
  @override
  State createState() => new _TeamDownloaderState();
}

/// State di TeamDownloader.
///
/// Permette il download e l'upload dei dati delle squadre in Firebase.
class _TeamDownloaderState extends State<TeamDownloader> {
  bool _logged = false;
  bool _needReload = false;
  FirebaseAnimatedList _list;

  _TeamDownloaderState() {
    login();
    _list = _newTeamDownloaderFirebaseAnimatedList();
  }

  @override
  Widget build(BuildContext context) {
    return new SetnoteBaseLayout(
      title: "Squadre nel cloud",
      child: new LoadingWidget(
        condition: _logged && !_needReload,
        child: _list,
      ),
      floatingActionButton: new FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () async => await Navigator.of(context).push(
            new MaterialPageRoute<Null>(
                builder: (BuildContext context) => new TeamUploader())),
      ),
    );
  }

  /// Costruisce la lista squadre.
  ///
  /// Si tratta di una FirebaseAnimatedList associata al riferimento alla
  /// sezione 'squadre' in Firebase.
  FirebaseAnimatedList _newTeamDownloaderFirebaseAnimatedList() {
    return new FirebaseAnimatedList(
      query: FirebaseDatabase.instance.reference().child('squadre'),
      sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
      padding: constant.standard_margin,
      itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
        return _newListEntry(snapshot);
      },
    );
  }

  /// Controlla il login dell'utente e setta la variabile [_logged] di
  /// conseguenza.
  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => _logged = true);
  }

  /// Costruisce un nuovo elemento della FirebaseAnimatedList.
  Widget _newListEntry(DataSnapshot snapshot) {
    Color _coloreMaglia = _computeColoreMagliaForListEntryIcon(snapshot);
    String _state = _computeStateForListEntryIcon(snapshot);
    Icon cloudIcon = _computeIconForListEntry(_state);
    return new Card(
        child: new FlatButton(
            onPressed: () => _clickedTeam(_state, snapshot),
            child: new ListTile(
                leading: new Icon(
                  Icons.group,
                  color: _coloreMaglia,
                ),
                title: new Text(snapshot.value['nome']),
                subtitle: new Text(snapshot.value['categoria'] +
                    ' - ' +
                    snapshot.value['stagione']),
                trailing: cloudIcon)));
  }

  /// Calcola il valore della variabile temporanea state in base al rapporto
  /// tra copia locale del dato e firebase.
  String _computeStateForListEntryIcon(DataSnapshot snapshot) {
    if (LocalDB.hasTeam(snapshot.key)) {
      int _local =
          int.parse(LocalDB.getTeamByKey(snapshot.key)['ultimaModifica']);
      int _remote = int.parse(snapshot.value['ultimaModifica']);

      if (_remote > _local) {
        return 'outdated';
      }
      if (_remote == _local) {
        return 'updated';
      }
      // if remote < local
      return 'ahead';
    } else {
      return 'absent';
    }
  }

  /// Costruisce l'oggetto Color corrispondente al colore di maglia letto da
  /// Firebase o ne costruisce uno di default.
  Color _computeColoreMagliaForListEntryIcon(DataSnapshot snapshot) {
    if ((snapshot.value['coloreMaglia'] != null) &&
        (snapshot.value['coloreMaglia'] != 'null')) {
      return new Color(int
          .parse(snapshot.value['coloreMaglia'].substring(8, 16), radix: 16));
    } else {
      return Colors.blue[400];
    }
  }

  /// In base al valore passato in input ritorna l'icona appropriata.
  Icon _computeIconForListEntry(String state) {
    if (state == 'outdated') return const Icon(Icons.cloud_download);
    if (state == 'updated') return const Icon(Icons.cloud_done);
    if (state == 'absent') return const Icon(Icons.cloud_off);
    if (state == 'ahead') return const Icon(Icons.cloud_upload);
    throw new ArgumentError("Errato formato della stringa state");
  }

  /// Gestisce il click dell'utente su un elemento della lista.
  Future<Null> _clickedTeam(String state, DataSnapshot snapshot) async {
    switch (state) {
      case 'absent':
        _clickedAbsentTeam(snapshot);
        break;
      case 'outdated':
        await _clickedOutdatedTeam(snapshot);
        break;
      case 'ahead':
        setState(() {
          _needReload = true;
          _list = null;
        });
        await _clickedAheadTeam(snapshot);
        break;
      case 'updated':
        break;
    }
    _list = _newTeamDownloaderFirebaseAnimatedList();
    setState(() => _needReload = false);
  }

  /// Scarica in locale la squadra selezionata.
  void _clickedAbsentTeam(DataSnapshot snapshot) {
    Map<String, dynamic> newTeam = new Map<String, dynamic>();
    newTeam['ultimaModifica'] = snapshot.value['ultimaModifica'];
    newTeam['key'] = snapshot.key;
    newTeam['stagione'] = snapshot.value['stagione'];
    newTeam['categoria'] = snapshot.value['categoria'];
    newTeam['nome'] = snapshot.value['nome'];
    newTeam['coloreMaglia'] = snapshot.value['coloreMaglia'];
    newTeam['allenatore'] = snapshot.value['allenatore'];
    newTeam['assistente'] = snapshot.value['assistente'];
    newTeam['assistente'] = snapshot.value['assistente'];
    newTeam['dataSet'] = snapshot.value['dataSet'];
    newTeam['weight'] = snapshot.value['weight'];
    LocalDB
        .addTeam(newTeam)
        .then((foo) => _downloadPlayers(teamKey: newTeam['key']));
  }

  /// Scarica in locale i giocatori della squadra passata in input
  static Future<Null> _downloadPlayers({String teamKey}) async {
    Query players = FirebaseDatabase.instance
        .reference()
        .child('giocatori')
        .orderByChild('squadra')
        .equalTo(teamKey);
    players.onValue.listen((e) {
      Map<String, dynamic> playerMap = e.snapshot.value;
      if (playerMap == null) return;
      for (String key in playerMap.keys) {
        Map<String, dynamic> player = playerMap[key];
        player["key"] = key;
        if (!LocalDB.hasPlayer(key))
          LocalDB.addPlayer(playerMap[key]);
        else
          LocalDB.updatePlayer(playerMap[key]);
      }
    });
  }

  /// Aggiorna la copia locale della squadra selezionata
  ///
  /// Chiede conferma all'utente e poi procede a sovrascrivere la copia
  /// locale della squadra con i dati scaricati dal database.
  Future<Null> _clickedOutdatedTeam(DataSnapshot snapshot) async {
    bool agree = await showDialog<bool>(
      context: context,
      child: _newTeamUploadConfirmationDialog(),
    );
    if (agree) {
      Map<String, dynamic> team = LocalDB.getTeamByKey(snapshot.key);
      team['ultimaModifica'] = snapshot.value['ultimaModifica'];
      team['key'] = snapshot.key;
      team['stagione'] = snapshot.value['stagione'];
      team['categoria'] = snapshot.value['categoria'];
      team['nome'] = snapshot.value['nome'];
      team['coloreMaglia'] = snapshot.value['coloreMaglia'];
      team['allenatore'] = snapshot.value['allenatore'];
      team['assistente'] = snapshot.value['assistente'];
      team['dataSet'] = snapshot.value['dataSet'];
      team['weight'] = snapshot.value['weight'];
      _downloadPlayers(teamKey: snapshot.key);
    }
  }

  /// Pubblica i dati locali della squadra caricandoli nel database.
  ///
  /// Al momento l'operazione è distruttiva.
  Future<Null> _clickedAheadTeam(DataSnapshot snapshot) async {
    // Chiede conferma all'utente
    bool agree = await showDialog<bool>(
      context: context,
      child: _newTeamUploadConfirmationDialog(),
    );
    if (agree) {
      // Prima carica le modifiche alla squadra
      _updateTeam(snapshot);
      // Poi carica o modifica tutti i giocatori appartenenti a quella squadra
      _updateAllPlayersOf(snapshot.key, snapshot.value['weight']);
    }
  }

  /// Costruisce una nuova dialog di conferma
  AlertDialog _newTeamUploadConfirmationDialog() {
    return new AlertDialog(
      content: const Text(
          'Questo caricherà i tuoi dati locali nel database, sei sicuro?'),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  /// Carica su firebase i dati relativi alla squadra nel complesso.
  void _updateTeam(DataSnapshot snapshot) {
    Map<String, dynamic> team = LocalDB.getTeamByKey(snapshot.key);
    for (String fondamentale in constant.fondamentali) {
      for (String esito in constant.esiti) {
        double x = team['dataSet'][fondamentale][esito];
        double y = snapshot.value['dataSet'][fondamentale][esito];
        team['dataSet'][fondamentale][esito] =
            ((x * team['weight']) + (y * snapshot.value['weight'])) /
                (team['weight'] + snapshot.value['weight']);
      }
    }
    FirebaseDatabase.instance
        .reference()
        .child('squadre')
        .child(snapshot.key)
        .set({
      'ultimaModifica': team['ultimaModifica'],
      'key': team['key'],
      'stagione': team['stagione'],
      'categoria': team['categoria'],
      'nome': team['nome'],
      'coloreMaglia': team['coloreMaglia'],
      'allenatore': team['allenatore'],
      'assistente': team['assistente'],
      'dataSet': team['dataSet'],
    });
    analytics.logEvent(name: 'modificata_squadra');
  }

  /// Carica i giocatori di una squadra decidendo se aggiornare o creare nuovi
  /// giocatori.
  void _updateAllPlayersOf(String teamKey, int weight) {
    List<Map<String, dynamic>> localPlayers =
        LocalDB.getPlayersOf(teamKey: teamKey);
    for (Map<String, dynamic> local in localPlayers) {
      Query players = FirebaseDatabase.instance
          .reference()
          .child('giocatori')
          .orderByKey()
          .equalTo(local['key']);
      players.onValue.listen((e) {
        if (e.snapshot.value.keys.isEmpty)
          _uploadSinglePlayer(local);
        else
          _updateSinglePlayer(local, weight);
      });
    }
  }

  /// Carica un nuovo giocatore in firebase.
  void _uploadSinglePlayer(Map<String, dynamic> player) {
    DatabaseReference newPlayer =
        FirebaseDatabase.instance.reference().child('giocatori').push();
    LocalDB.changePlayerKey(
      oldKey: player['key'],
      newKey: newPlayer.key,
    );
    newPlayer.set({
      'key': player['key'],
      'altezza': player['altezza'],
      'capitano': player['capitano'],
      'cognome': player['cognome'],
      'mancino': player['mancino'],
      'nascita': player['nascita'],
      'nazionalita': player['nazionalita'],
      'nome': player['nome'],
      'numeroMaglia': player['numeroMaglia'],
      'peso': player['peso'],
      'ruolo': player['ruolo'],
      'squadra': player['squadra'],
      'dataSet': player['dataSet'],
    });
  }

  /// Aggiorna un giocatore già presente in firebase.
  void _updateSinglePlayer(Map<String, dynamic> player, int remoteWeight) {
    int _localWeight = LocalDB.getTeamByKey(player['squadra'])['weight'];

    Query remote = FirebaseDatabase.instance
        .reference()
        .child('giocatori')
        .orderByKey()
        .equalTo(player['key']);
    remote.onValue.listen((e) {
      for (String fondamentale in constant.fondamentali) {
        for (String esito in constant.esiti) {
          double x = player['dataSet'][fondamentale][esito];
          double y = e.snapshot.value['dataSet'][fondamentale][esito];
          player['dataSet'][fondamentale][esito] =
              ((x * _localWeight) + (y * remoteWeight)) /
                  (_localWeight + remoteWeight);
        }
      }
    });

    FirebaseDatabase.instance
        .reference()
        .child('giocatori')
        .child(player['key'])
        .set({
      'key': player['key'],
      'altezza': player['altezza'],
      'capitano': player['capitano'],
      'cognome': player['cognome'],
      'mancino': player['mancino'],
      'nascita': player['nascita'],
      'nazionalita': player['nazionalita'],
      'nome': player['nome'],
      'numeroMaglia': player['numeroMaglia'],
      'peso': player['peso'],
      'ruolo': player['ruolo'],
      'squadra': player['squadra'],
      'dataSet': player['dataSet'],
    });
  }
}

/// Carica una squadra già presente in locale nel DB.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class TeamUploader extends StatefulWidget {
  @override
  State createState() => new _TeamUploaderState();
}

/// State di TeamUploader.
///
/// Costruisce una lista sulla base delle squadre presenti in locale.
/// L'utente seleziona poi la squadra da caricare. Dopo aver chiesto conferma
/// l'uploader si occupa del corretto caricamento in Firebase.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa di alcune funzioni asincrone.
class _TeamUploaderState extends State<TeamUploader> {
  bool _reloadNeeded = false;

  /// Costruttore di _TeamUploaderState.
  ///
  /// Prima di tutto avvia la lettura delle squadre dalle sharedPreferences,
  /// in quanto operazione potenzialmente lunga ed indispensabile alle
  /// funzionalità dell'uploader.
  _TeamUploaderState() {
    LocalDB.readFromFile();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _teamList = new List<Widget>();
    for (Map<String, dynamic> _team in LocalDB.teams) {
      _teamList.add(_newTeamCard(_team));
    }
    return new SetnoteBaseLayout(
      title: 'Squadre salvate',
      child: new ListView(
        padding: constant.standard_margin,
        children: _reloadNeeded ? [] : _teamList,
      ),
    );
  }

  /// Costruisce una nuova dialog di conferma
  AlertDialog _newTeamUploadConfirmationDialog() {
    return new AlertDialog(
      content: const Text(
          'Questo caricherà i tuoi dati locali nel database, sei sicuro?'),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  /// Crea una Card per la _teamList rappresentativa del team passato in input.
  Card _newTeamCard(Map<String, dynamic> team) {
    return new Card(
      child: new FlatButton(
        onPressed: () async {
          _reloadNeeded = true;
          bool _agree = await showDialog<bool>(
            context: context,
            child: _newTeamUploadConfirmationDialog(),
          );
          if (_agree) {
            _uploadTeam(team);
          }
          Navigator.of(context).pop();
        },
        child: new ListTile(
          leading: new Icon(
            Icons.group,
            color: (team['coloreMaglia'] != 'null' &&
                    team['coloreMaglia'] != null
                ? new Color(
                    int.parse(team['coloreMaglia'].substring(8, 16), radix: 16))
                : Theme.of(context).buttonColor),
          ),
          title: new Text(team['nome']),
          subtitle: new Text(team['categoria'] + ' - ' + team['stagione']),
        ),
      ),
    );
  }

  /// Carica il team nel database e sincronizza il campo key con quello locale.
  void _uploadTeam(Map<String, dynamic> team) {
    DatabaseReference newTeam =
        FirebaseDatabase.instance.reference().child('squadre').push();
    LocalDB.changeTeamKey(
      oldKey: team['key'],
      newKey: newTeam.key,
    );
    newTeam.set({
      'ultimaModifica': team['ultimaModifica'],
      'key': team['key'],
      'stagione': team['stagione'],
      'categoria': team['categoria'],
      'nome': team['nome'],
      'coloreMaglia': team['coloreMaglia'],
      'allenatore': team['allenatore'],
      'assistente': team['assistente'],
      'dataSet': team['dataSet'],
      'weight': team['weight'],
    });
    analytics.logEvent(name: 'aggiunta_squadra');
  }
}
