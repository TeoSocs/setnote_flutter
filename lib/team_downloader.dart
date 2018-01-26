import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';
import 'package:setnote_flutter/google_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'constants.dart' as constant;
import 'local_team_list.dart';

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
  bool logged = false;

  @override
  Widget build(BuildContext context) {
    login();
    return new SetnoteBaseLayout(
      title: "Squadre nel cloud",
      child: new LoadingWidget(
        condition: logged,
        child: _newTeamDownloaderFirebaseAnimatedList(),
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

  /// Controlla il login dell'utente e setta la variabile [logged] di
  /// conseguenza.
  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => logged = true);
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
    if (LocalDB.has(snapshot.key)) {
      int _local = int.parse(LocalDB.getByKey(snapshot.key)['ultima_modifica']);
      int _remote = int.parse(snapshot.value['ultima_modifica']);

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
    if ((snapshot.value['colore_maglia'] != null) ||
        (snapshot.value['colore_maglia'] != 'null')) {
      return new Color(int
          .parse(snapshot.value['colore_maglia'].substring(8, 16), radix: 16));
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
        _clickedOutdatedTeam(snapshot);
        break;
      case 'ahead':
        _clickedAheadTeam(snapshot);
        break;
      case 'updated':
        // TODO: rimuovere questo codice
        _downloadPlayers(teamKey: snapshot.key);
        break;
    }
    Navigator.of(context).pop();
  }

  /// Scarica in locale la squadra selezionata.
  void _clickedAbsentTeam(DataSnapshot snapshot) {
    Map<String, dynamic> newTeam = new Map<String, dynamic>();
    newTeam['ultima_modifica'] = snapshot.value['ultima_modifica'];
    newTeam['key'] = snapshot.key;
    newTeam['stagione'] = snapshot.value['stagione'];
    newTeam['categoria'] = snapshot.value['categoria'];
    newTeam['nome'] = snapshot.value['nome'];
    newTeam['colore_maglia'] = snapshot.value['colore_maglia'];
    newTeam['allenatore'] = snapshot.value['allenatore'];
    newTeam['assistente'] = snapshot.value['assistente'];
    LocalDB
        .addTeam(newTeam)
        .then((foo) => _downloadPlayers(teamKey: newTeam['key']));
  }

  /// Scarica in locale i giocatori della squadra passata in input
  static Future<Null> _downloadPlayers({String teamKey}) async {
    // TODO
    Query players = FirebaseDatabase.instance
        .reference()
        .child('giocatori')
        .orderByChild('squadra')
        .equalTo(teamKey);
    players.onValue.listen((e) {
      print(e.snapshot.value);
    });
  }

  /// Aggiorna la copia locale della squadra selezionata
  ///
  /// Chiede conferma all'utente e poi procede a sovrascrivere la copia
  /// locale della squadra con i dati scaricati dal database.
  Future<Null> _clickedOutdatedTeam(DataSnapshot snapshot) async {
    bool agree = await showDialog<bool>(
      context: context,
      child: new AlertDialog(
        content: const Text(
            'Questo sovrascriverà i dati locali di questa squadra, sei sicuro?'),
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
      ),
    );
    if (agree) {
      Map<String, dynamic> team = LocalDB.getByKey(snapshot.key);
      team['ultima_modifica'] = snapshot.value['ultima_modifica'];
      team['key'] = snapshot.key;
      team['stagione'] = snapshot.value['stagione'];
      team['categoria'] = snapshot.value['categoria'];
      team['nome'] = snapshot.value['nome'];
      team['colore_maglia'] = snapshot.value['colore_maglia'];
      team['allenatore'] = snapshot.value['allenatore'];
      team['assistente'] = snapshot.value['assistente'];
      LocalDB.store();
    }
  }

  /// Pubblica i dati locali della squadra caricandoli nel database.
  ///
  /// Al momento l'operazione è distruttiva.
  // TODO: integrare dati in DB invece di sovrascrivere.
  Future<Null> _clickedAheadTeam(DataSnapshot snapshot) async {
    bool agree = await showDialog<bool>(
      context: context,
      child: new AlertDialog(
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
      ),
    );
    if (agree) {
      Map<String, dynamic> team = LocalDB.getByKey(snapshot.key);
      FirebaseDatabase.instance
          .reference()
          .child('squadre')
          .child(snapshot.key)
          .set({
        'ultima_modifica': team['ultima_modifica'],
        'key': team['key'],
        'stagione': team['stagione'],
        'categoria': team['categoria'],
        'nome': team['nome'],
        'colore_maglia': team['colore_maglia'],
        'allenatore': team['allenatore'],
        'assistente': team['assistente'],
      });
      analytics.logEvent(name: 'modificata_squadra');
    }
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
            color: (team['colore_maglia'] != 'null' &&
                    team['colore_maglia'] != null
                ? new Color(int.parse(team['colore_maglia'].substring(8, 16),
                    radix: 16))
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
    LocalDB.changeKey(
      oldKey: team['key'],
      newKey: newTeam.key,
    );
    newTeam.set({
      'ultima_modifica': team['ultima_modifica'],
      'key': team['key'],
      'stagione': team['stagione'],
      'categoria': team['categoria'],
      'nome': team['nome'],
      'colore_maglia': team['colore_maglia'],
      'allenatore': team['allenatore'],
      'assistente': team['assistente'],
    });
    analytics.logEvent(name: 'aggiunta_squadra');
  }
}
