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
        children: <Widget>[
          const Text('Qui ci metto le statistiche del primo set'),
          new StatChart(),
          const Text('Qui ci metto quelle del secondo'),
          new StatChart(),
          const Text('Qui quelle del terzo'),
          new StatChart(),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: _playerListBuilder(),
        ),
      ),
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
