import 'dart:async';
import 'dart:math';

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

class _CollectDataState extends State<CollectData> {
  Map<String, dynamic> match;
  List<Widget> _playerList = new List<Widget>();
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

  _CollectDataState(this.match) {
    match['Set'] = new List<Map<String, dynamic>>();
    match['Set'].add(new Map<String, dynamic>());
    _currentSet = match['Set'][0];
    _currentSet['azioni'] = new List<Map<String, String>>();
    for (Map<String, dynamic> _player
        in LocalDB.getPlayersOf(teamKey: match['myTeam'])) {
      _playerList.add(_newPlayerListEntry(_player));
    }
  }

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
        onLongPress: () =>
          setState(() => _currentPoint.remove(azione)),
      );
      scambio.add(newEntry);
    }

    return new Drawer(
      child: new Stack(
        children: <Widget>[
          new ListView(
            children: (scambio.isNotEmpty ? scambio : []),
          ),
          new Positioned(
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
          )
        ],
      ),
    );
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
                    children: _playerList,
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

  void _saveMatch() {
    match['ended'] = 'true';
    if (LocalDB.hasMatch(match['key'])) {
      LocalDB.store();
    } else {
      LocalDB.addMatch(match);
      Map<String, dynamic> _team = LocalDB.getTeamByKey(match['myTeam']);
      Map<String, Map<String, double>> dataSet =
      new Map<String, Map<String, double>>();
      for (String fondamentale in constant.fondamentali) {
        dataSet[fondamentale] = new Map<String, double>();
        for (String esito in constant.esiti) {
          dataSet[fondamentale][esito] = 0.0;
        }
      }
      for (Map<String, dynamic> set in match['Set']) {
        // Qui bisogna recuperare ed elaborare i dati, eventualmente filtrarli
        // per giocatore
        for (Map<String, String> azione in set['azioni']) {
          dataSet[azione['fondamentale']][azione['esito']] += 1;
        }
      }
      for (String fondamentale in constant.fondamentali) {
        for (String esito in constant.esiti) {
          double x = dataSet[fondamentale][esito];
          double y = _team['dataSet'][fondamentale][esito];
          x = exp((log(x) + log(y) * _team['weight']) / (_team['weight'] + 1));
        }
      }
      _team['dataSet'] = dataSet;
      _team['weight']++;
      _team['ultimaModifica'] = new DateTime.now().millisecondsSinceEpoch.toString();
    }
  }
}
