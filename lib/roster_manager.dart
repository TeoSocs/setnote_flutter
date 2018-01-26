import 'package:flutter/material.dart';
import 'local_team_list.dart';
import 'setnote_widgets.dart';

import 'constants.dart' as constant;

class RosterManager extends StatefulWidget {
  RosterManager({this.team});
  final Map<String, dynamic> team;

  @override
  State createState() => new _RosterManagerState(team: team);
}

/// Pagina di gestione della formazione di un team.
///
/// [team] è la squadra che si sta modificando e viene passata da costruttore.

class _RosterManagerState extends State<RosterManager> {
  Map<String, dynamic> team;

  /// Costruttore di _RosterManagerState.
  ///
  /// Riceve in input [team] e recupera da Firebase il riferimento [rosterDB].
  _RosterManagerState({this.team});

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    List<Widget> playerList = new List<Widget>();
    for (Map<String, dynamic> _player in LocalDB.getPlayersOf(teamKey: team['key'])) {
      playerList.add(_newListEntry(_player));
    }

    return new SetnoteBaseLayout(
      title: (media.orientation == Orientation.landscape &&
              media.size.width >= 950.00
          ? "Gestisci formazione"
          : team['nome']),
      drawer: _newRosterManagerDrawer(),
      child: new ListView(
        padding: constant.standard_margin,
        children: playerList,
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Aggiungi', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: null,
      ),
    );
  }

  /// Costruisce il drawer per RosterManager
  Drawer _newRosterManagerDrawer() {
    return new Drawer(
      child: new ListView(children: <Widget>[
        new DrawerHeader(
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: new Text(
              team['nome'],
              style: Theme.of(context).primaryTextTheme.headline,
            ),
          ),
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        new ListTile(
          title: new Text(team['categoria'] + ' - ' + team['stagione']),
        ),
      ]),
    );
  }

  /// Costruisce la card che presenta ciascun giocatore recuperato dal DB.
  Card _newListEntry(Map<String, dynamic> player) {
    return new Card(
      child: new FlatButton(
        onPressed: null,
        child: new ListTile(
          leading: new Icon(
            Icons.android,
          ),
          title: new Text(player['nome']),
          subtitle: new Text(player['ruolo']),
        ),
      ),
    );
  }
}
