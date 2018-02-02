import 'package:flutter/material.dart';

import 'charts/stat_chart.dart';
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
    int i=1;
    for (Map<String, dynamic> set in match['Set']) {
      list.add(_statsTableBuilder("Set $i"));
      list.add(new StatChart());
      i++;
    }
    return list;
  }

  Widget _statsTableBuilder(String title) {
    return new Column(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text(title, style: Theme.of(context).textTheme.title,)),
        new Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: new Text("Battuta", style: Theme.of(context).textTheme
                .subhead,)),
        new Table(
          children: <TableRow>[
            new TableRow(
                children: <Widget> [
                  const Text("Battute totali"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Errori"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Ace"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Positività"),
                  const Text("##%")
                ]
            ),
          ],
        ),

        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text("Ricezione", style: Theme.of(context).textTheme
                .subhead,)),
        new Table(
          children: <TableRow>[
            new TableRow(
                children: <Widget> [
                  const Text("Ricezioni totali"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Errori"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Positività"),
                  const Text("##%")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Perfezione"),
                  const Text("##%")
                ]
            ),
          ],
        ),

        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text("Attacco", style: Theme.of(context).textTheme
                .subhead,)),
        new Table(
          children: <TableRow>[
            new TableRow(
                children: <Widget> [
                  const Text("Attacchi totali"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Errori"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Punti"),
                  const Text("##%")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Efficienza"),
                  const Text("##%")
                ]
            ),
          ],
        ),

        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text("Difesa", style: Theme.of(context).textTheme
                .subhead,)),
        new Table(
          children: <TableRow>[
            new TableRow(
                children: <Widget> [
                  const Text("Difese totali"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Errori"),
                  const Text("##")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Positività"),
                  const Text("##%")
                ]
            ),
            new TableRow(
                children: <Widget> [
                  const Text("Perfezione"),
                  const Text("##%")
                ]
            ),
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
