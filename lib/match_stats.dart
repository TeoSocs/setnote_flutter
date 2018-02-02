import 'dart:convert';

import 'package:flutter/material.dart';

import 'charts/stat_chart.dart';
import 'constants.dart' as constant;
import 'local_database.dart';
import 'setnote_widgets.dart';

class MatchStats extends StatefulWidget {
  MatchStats(this.match);

  final Map<String, dynamic> match;

  @override
  State createState() => new _MatchStatsState(match);
}

class _MatchStatsState extends State<MatchStats> {
  _MatchStatsState(this.match);

  Map<String, dynamic> match;
  bool _reloadNeeded = false;

  @override
  Widget build(BuildContext context) {
    return new SetnoteBaseLayout(
      title: 'Statistiche',
      child: new GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: _gridChildrenBuilder(),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: _playerListBuilder(),
        ),
      ),
    );
  }

  List<Widget> _gridChildrenBuilder() {
    List<Widget> list = new List<Widget>();
    Map<String, Map<String, int>> rawData = new Map<String, Map<String, int>>();
    int i = 1;
    for (Map<String, dynamic> set in match['Set']) {
      for (String fondamentale in constant.fondamentali) {
        rawData[fondamentale] = new Map<String, int>();
        for (String esito in constant.esiti) {
          rawData[fondamentale][esito] = 0;
        }
      }
      // Qui bisogna recuperare ed elaborare i dati, eventualmente filtrarli
      // per giocatore
      for (Map<String, String> azione in set['azioni']) {
        rawData[azione['fondamentale']][azione['esito']] += 1;
      }
      print(JSON.encode(rawData));
      list.add(_statsTableBuilder("Set $i", rawData));
      list.add(new StatChart());
      i++;
    }
    return list;
  }

  Widget _statsTableBuilder(String title, Map<String, dynamic> data) {
    int battuteTotali = 0;
    for (String esito in constant.esiti) {
      battuteTotali += data["Battuta"][esito];
    }
    double battutaPositivita =
        (data['Battuta']['Ottimo'] + data['Battuta']['Buono']) *
            100 /
            battuteTotali;

    int ricezioniTotali = 0;
    for (String esito in constant.esiti) {
      ricezioniTotali += data["Ricezione"][esito];
    }

    double ricezionePositivita =
        (data['Ricezione']['Ottimo'] + data['Ricezione']['Buono']) *
            100 /
            ricezioniTotali;

    double ricezionePerfezione =
        data['Ricezione']['Ottimo'] * 100 / ricezioniTotali;

    return new Column(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text(
              title,
              style: Theme.of(context).textTheme.title,
            )),
        new Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: new Text(
              "Battuta",
              style: Theme.of(context).textTheme.subhead,
            )),
        new Table(
          children: <TableRow>[
            new TableRow(children: <Widget>[
              const Text("Battute totali"),
              new Text("$battuteTotali")
            ]),
            new TableRow(children: <Widget>[
              const Text("Errori"),
              new Text("${data['Battuta']['Errato']}")
            ]),
            new TableRow(children: <Widget>[
              const Text("Ace"),
              new Text("${data['Battuta']['Ottimo']}")
            ]),
            new TableRow(children: <Widget>[
              const Text("Positività"),
              new Text("$battutaPositivita%")
            ]),
          ],
        ),
        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text(
              "Ricezione",
              style: Theme.of(context).textTheme.subhead,
            )),
        new Table(
          children: <TableRow>[
            new TableRow(children: <Widget>[
              const Text("Ricezioni totali"),
              new Text("$ricezioniTotali")
            ]),
            new TableRow(children: <Widget>[
              const Text("Errori"),
              new Text("${data['Ricezione']['Errato']}")
            ]),
            new TableRow(children: <Widget>[
              const Text("Positività"),
              new Text("$ricezionePositivita%")
            ]),
            new TableRow(children: <Widget>[
              const Text("Perfezione"),
              new Text("$ricezionePerfezione%")
            ]),
          ],
        ),
        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text(
              "Attacco",
              style: Theme.of(context).textTheme.subhead,
            )),
        new Table(
          children: <TableRow>[
            new TableRow(children: <Widget>[
              const Text("Attacchi totali"),
              const Text("##")
            ]),
            new TableRow(
                children: <Widget>[const Text("Errori"), const Text("##")]),
            new TableRow(
                children: <Widget>[const Text("Punti"), const Text("##%")]),
            new TableRow(children: <Widget>[
              const Text("Efficienza"),
              const Text("##%")
            ]),
          ],
        ),
        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text(
              "Difesa",
              style: Theme.of(context).textTheme.subhead,
            )),
        new Table(
          children: <TableRow>[
            new TableRow(children: <Widget>[
              const Text("Difese totali"),
              const Text("##")
            ]),
            new TableRow(
                children: <Widget>[const Text("Errori"), const Text("##")]),
            new TableRow(children: <Widget>[
              const Text("Positività"),
              const Text("##%")
            ]),
            new TableRow(children: <Widget>[
              const Text("Perfezione"),
              const Text("##%")
            ]),
          ],
        ),
      ],
    );
  }

  List<Widget> _playerListBuilder() {
    List<Widget> playerList = new List<Widget>();
    playerList.add(_wholeTeamEntryBuilder());
    for (Map<String, dynamic> _player
        in LocalDB.getPlayersOf(teamKey: match['myTeam'])) {
      playerList.add(_listEntryBuilder(_player));
    }
    setState(() => _reloadNeeded = false);
    return playerList;
  }

  Card _listEntryBuilder(Map<String, dynamic> player) {
    return new Card(
      child: new FlatButton(
        onPressed: () async {
          _reloadNeeded = true;
          // cose
          setState(() => _reloadNeeded = false);
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

  Card _wholeTeamEntryBuilder() {
    return new Card(
      elevation: 0.5,
      child: new FlatButton(
        onPressed: () async {
          _reloadNeeded = true;
          // cose
          setState(() => _reloadNeeded = false);
        },
        child: new ListTile(
          title: new Text("Rendimento di squadra"),
        ),
      ),
    );
  }
}
