import 'package:flutter/material.dart';
import 'dart:async';

import 'setnote_widgets.dart';
import 'local_database.dart';
import 'constants.dart' as constant;

/// Permette di raccogliere dati sulla partita in corso.abstract
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
  List<Widget> playerList = new List<Widget>();
  Action pending = new Action();

  _CollectDataState(this.match) {
    for (Map<String, dynamic> _player
        in LocalDB.getPlayersOf(teamKey: match['myTeam'])) {
      playerList.add(_newListEntry(_player));
    }
  }

  Card _newListEntry(Map<String, dynamic> player) {
    return new Card(
      child: new FlatButton(
        onPressed: () {
          pending.player = player['key'];
          print("pending: ");
          print(pending);
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
      padding: constant.standard_margin,
      child: new RaisedButton(
        child: new Text(fondamentale),
        onPressed: () {
          pending.fondamentale = fondamentale;
          print("pending: ");
          print(pending);
        },
      ),
    );
  }

  Widget _newLv2Button(constant.esiti esito) {
    String label = '';
    switch (esito) {
      case constant.esiti.errato:
        label = "Errore";
        break;
      case constant.esiti.scarso:
        label = "Scarso";
        break;
      case constant.esiti.buono:
        label = "Buono";
        break;
      case constant.esiti.ottimo:
        label = "Ottimo";
        break;
    }
    return new Padding(
      padding: constant.standard_margin,
      child: new RaisedButton(
        child: new Text(label),
        onPressed: () {
          pending.esito = esito;
          print("pending: ");
          print(pending);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _requestPop,
        child: new SetnoteBaseLayout(
          title: 'Raccolta Dati',
          drawer: new Drawer(),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new ListView(
                  padding: constant.standard_margin,
                  children: playerList,
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
                    _newLv2Button(constant.esiti.ottimo),
                    _newLv2Button(constant.esiti.buono),
                    _newLv2Button(constant.esiti.scarso),
                    _newLv2Button(constant.esiti.errato),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> _requestPop() async {
    bool _areYouSure = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: new Text('Vuoi uscire?'),
        content: new Text(
            'Uscendo ora, i dati saranno salvati e non potrai più modificarli. Sei sicuro?'),
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
}

class Action {
  String player;
  String fondamentale;
  constant.esiti esito;

  void save() {
    // TODO
  }
}
