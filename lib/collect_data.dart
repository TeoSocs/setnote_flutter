import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'setnote_widgets.dart';

/// Permette di raccogliere dati sulla partita in corso.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class CollectData extends StatefulWidget {
  final Map<String, dynamic> match;
  CollectData(this.match);
  @override
  State createState() => new _CollectDataState(match);
}

/// State di CollectData.
///
/// Permette di raccogliere dati sulla partita in corso.
/// [match] è l'oggetto creato da [MatchProperties] che contene le
/// informazioni sulla partita in corso.
/// [_pending] è un oggetto ausiliario che rappresenta l'azione atomica che
/// si sta inserendo.
class _CollectDataState extends State<CollectData> {
  Map<String, dynamic> match;
  Map<String, String> _pending = new Map<String, String>();
  Map<String, dynamic> _currentSet;
  List<Map<String, String>> _currentPoint = new List<Map<String, String>>();
  int _myTeamPoints = 0;
  int _opponentPoints = 0;
  final Map<String, Color> _colors = {
    'Ottimo': Colors.blue[400],
    'Buono': Colors.green[400],
    'Scarso': Colors.yellow[400],
    'Errato': Colors.red[400],
  };

  /// Costruttore di [_CollectDataState]
  ///
  /// Crea gli oggetti che saranno poi modificati, previene errori di null
  /// pointer.
  _CollectDataState(this.match) {
    match['Set'] = new List<Map<String, dynamic>>();
    match['Set'].add(new Map<String, dynamic>());
    _currentSet = match['Set'][0];
    _currentSet['azioni'] = new List<Map<String, String>>();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _requestPop,
      child: new SetnoteBaseLayout(
        title: 'Raccolta Dati',
        drawer: _newDrawer(),
        child: new Stack(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new ListView(
                    padding: constant.standard_margin,
                    children: _playerListBuilder(),
                  ),
                ),
                new Flexible(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _newLv1Button('Battuta'),
                      _newLv1Button('Ricezione'),
                      _newLv1Button('Attacco'),
                      _newLv1Button('Difesa'),
                    ],
                  ),
                ),
                new Flexible(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _newLv2Button('Ottimo'),
                      _newLv2Button('Buono'),
                      _newLv2Button('Scarso'),
                      _newLv2Button('Errato'),
                    ],
                  ),
                ),
              ],
            ),
            _buttonRowBuilder(),
            _pointDisplayBuilder(),
          ],
        ),
      ),
    );
  }

  /// Crea la lista di giocatori recuperandola da [LocalDB].
  List<Widget> _playerListBuilder() {
    List<Widget> _playerList = new List<Widget>();
    for (Map<String, dynamic> _player
        in LocalDB.getPlayersOf(teamKey: match['myTeam'])) {
      _playerList.add(_newPlayerListEntry(_player));
    }
    return _playerList;
  }

  /// Crea la singola card cliccabile rappresentante un giocatore.
  Card _newPlayerListEntry(Map<String, dynamic> player) {
    return new Card(
      child: new FlatButton(
        onPressed: () {
          _pending['player'] = player['key'];
        },
        child: new ListTile(
          leading: (player['numeroMaglia'] != null
              ? new Text(
                  player['numeroMaglia'],
                  style: const TextStyle(fontSize: 33.0),
                )
              : new Icon(
                  Icons.person,
                )),
          title: new Text(player['nome']),
          subtitle: new Text(player['ruolo']),
        ),
      ),
    );
  }

  /// Crea un bottone Lv1.
  ///
  /// Rappresenta la registrazione del tipo di fondamentale dell'azione da
  /// salvare.
  Widget _newLv1Button(String fondamentale) {
    return new Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
      child: new RaisedButton(
        child: new Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text(
              fondamentale,
            )),
        onPressed: () {
          _pending['fondamentale'] = fondamentale;
        },
      ),
    );
  }

  /// Crea un bottone Lv2.
  ///
  /// Rappresenta la registrazione dell'esito dell'azione da salvare.
  /// È anche il pulsante conclusivo: premuto questo l'azione viene
  /// registrata in [_currentPoint].
  Widget _newLv2Button(String esito) {
    return new Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
      child: new RaisedButton(
        child: new Padding(
          padding: const EdgeInsets.all(11.0),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: new Icon(
                  Icons.brightness_1,
                  color: _colors[esito],
                ),
              ),
              new Text(esito),
            ],
          ),
        ),
        onPressed: () {
          _pending['esito'] = esito;
          if (_pending['player'] != null && _pending['fondamentale'] != null) {
            setState(() => _currentPoint.add(_pending));
            _pending = new Map<String, String>();
          }
        },
      ),
    );
  }

  /// Disegna il drawer.
  ///
  /// Costruisce un drawer come lista di azioni avvenute durante il
  /// [_currentPoint]. Presenta due bottoni per la registrazione del punto al
  /// proprio team o a quello avversario.
  Drawer _newDrawer() {
    List<Widget> scambio = new List<Widget>();
    ListTile newEntry;
    Map<String, dynamic> player;
    for (Map<String, String> azione in _currentPoint) {
      player = LocalDB.getPlayerByKey(azione['player']);
      newEntry = new ListTile(
        leading: new Icon(
          Icons.brightness_1,
          color: _colors[azione['esito']],
        ),
        title: new Text(azione['fondamentale']),
        subtitle: new Text("${player['nome']} ${player['cognome']}"),
        onLongPress: () => setState(() => _currentPoint.remove(azione)),
      );
      scambio.add(newEntry);
    }
    return new Drawer(
      child: new Stack(
        children: <Widget>[
          new ListView(
            children: (scambio.isNotEmpty ? scambio : []),
          ),
          _drawerButtonBuilder(),
        ],
      ),
    );
  }

  /// Costruisce i pulsanti per la registrazione del punto.
  ///
  /// La loro pressione svuota [_currentPoint] e aggiorna le variabili punteggio.
  Widget _drawerButtonBuilder() {
    return new Positioned(
      bottom: 0.0,
      right: 0.0,
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              right: 10.0,
            ),
            child: new IconButton(
              color: _colors['Errato'],
              onPressed: () {
                setState(() {
                  _currentSet['azioni'].addAll(_currentPoint);
                  _currentPoint.clear();
                  _opponentPoints += 1;
                  _currentSet['punteggio'] = "$_myTeamPoints - "
                      "$_opponentPoints";
                  print("Punteggio: $_myTeamPoints - $_opponentPoints");
                });
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              right: 10.0,
            ),
            child: new FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentSet['azioni'].addAll(_currentPoint);
                  _currentPoint.clear();
                  _myTeamPoints += 1;
                  _currentSet['punteggio'] = "$_myTeamPoints - "
                      "$_opponentPoints";
                  print("Punteggio: $_myTeamPoints - $_opponentPoints");
                });
              },
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonRowBuilder() {
    return new Positioned(
      bottom: 0.0,
      right: 0.0,
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: new RaisedButton(
                child: const Text('Nuovo set'),
                onPressed: () {
                  match['Set'].add(new Map<String, dynamic>());
                  _currentSet = match['Set'].last;
                  _currentSet['azioni'] = new List<Map<String, String>>();
                  setState(() {
                    _myTeamPoints = 0;
                    _opponentPoints = 0;
                  });
                }),
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: new RaisedButton(
              child: new Text('Salva',
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: _saveMatch,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Costruisce il visualizzatore del punteggio.
  Widget _pointDisplayBuilder() {
    return new Positioned(
      top: 20.0,
      right: 30.0,
      child: new Text(
        "$_myTeamPoints - $_opponentPoints",
        style: Theme.of(context).textTheme.display4,
      ),
    );
  }

  /// Gestisce tramite dialog la pressione del tasto back da parte dell'utente.
  Future<bool> _requestPop() async {
    bool _areYouSure = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: new Text('Vuoi uscire?'),
        content:
            new Text('Uscendo ora perderai i dati non salvati. Sei sicuro?'),
        actions: <Widget>[
          new FlatButton(
            child: new Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          new FlatButton(
            child: new Text('SÌ'),
            onPressed: () {
              match['ended'] = 'true';
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    if (_areYouSure) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    return new Future.value(false);
  }

  /// Persiste i dati raccolti nel database locale.
  ///
  /// Usa un oggetto ausiliario [dataSet] che raccoglie i dati sulle azioni
  /// da registrare. Lo usa poi per fare una media ponderata con i dati già
  /// presenti nel DB e salvare quest'ultima, aggiornando il rispettivo peso.
  void _saveMatch() {
    match['ended'] = 'true';
    if (LocalDB.hasMatch(match['key'])) {
      // Se mi trovo qui questo metodo è già stato chiamato prima.
      LocalDB.store();
    } else {
      // È il primo salvataggio dei dati raccolti.
      LocalDB.addMatch(match);
      Map<String, dynamic> _team = LocalDB.getTeamByKey(match['myTeam']);
      // Creo il dataSet e ne inizializzo tutti i campi a zero.
      Map<String, Map<String, double>> dataSet =
          new Map<String, Map<String, double>>();
      for (String fondamentale in constant.fondamentali) {
        dataSet[fondamentale] = new Map<String, double>();
        for (String esito in constant.esiti) {
          dataSet[fondamentale][esito] = 0.0;
        }
      }
      // Riempio l'oggetto dataSet.
      for (Map<String, dynamic> set in match['Set']) {
        for (Map<String, String> azione in set['azioni']) {
          dataSet[azione['fondamentale']][azione['esito']] += 1;
        }
      }
      // Lo uso per fare una media pesata dei dati e aggiornare i dataSet di
      // squadra.
      for (String fondamentale in constant.fondamentali) {
        for (String esito in constant.esiti) {
          double x = dataSet[fondamentale][esito];
          double y = _team['dataSet'][fondamentale][esito];
          x = (x + (y * _team['weight'])) / (_team['weight'] + 1);
        }
      }
      _team['dataSet'] = dataSet;
      _team['weight']++;
      _team['ultimaModifica'] =
          new DateTime.now().millisecondsSinceEpoch.toString();

      // Aggiorno i dataSet propri di ogni giocatore
      for (Map<String, dynamic> _player
          in LocalDB.getPlayersOf(teamKey: match['myTeam'])) {
        Map<String, Map<String, double>> _playerDataSet =
            new Map<String, Map<String, double>>();
        for (String fondamentale in constant.fondamentali) {
          _playerDataSet[fondamentale] = new Map<String, double>();
          for (String esito in constant.esiti) {
            _playerDataSet[fondamentale][esito] = 0.0;
          }
        }
        for (Map<String, dynamic> set in match['Set']) {
          for (Map<String, String> azione in set['azioni']) {
            if (azione['player'] != _player['key']) continue;
            _playerDataSet[azione['fondamentale']][azione['esito']] += 1;
          }
        }
        for (String fondamentale in constant.fondamentali) {
          for (String esito in constant.esiti) {
            double x = _playerDataSet[fondamentale][esito];
            double y = _player['dataSet'][fondamentale][esito];
            x = (x + (y * _team['weight'])) / (_team['weight'] + 1);
          }
        }
        _player['dataSet'] = _playerDataSet;
      }
    }
  }
}
