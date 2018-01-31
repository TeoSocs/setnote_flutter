import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'player_properties.dart';
import 'setnote_widgets.dart';

class PlayerList extends StatefulWidget {
  PlayerList({this.team});
  final Map<String, dynamic> team;

  @override
  State createState() => new _PlayerListState(team: team);
}

/// Pagina di gestione della formazione di un team.
///
/// [team] è la squadra che si sta modificando e viene passata da costruttore.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa del caricamento di alcune componenti.

class _PlayerListState extends State<PlayerList> {
  Map<String, dynamic> team;
  bool _reloadNeeded = false;

  /// Costruttore di _RosterManagerState.
  ///
  /// Riceve in input [team] e recupera da Firebase il riferimento [rosterDB].
  _PlayerListState({this.team});

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    List<Widget> playerList = new List<Widget>();
    for (Map<String, dynamic> _player
        in LocalDB.getPlayersOf(teamKey: team['key'])) {
      playerList.add(_newListEntry(_player));
    }
    setState(() => _reloadNeeded = false);
    return new SetnoteBaseLayout(
      title: (media.orientation == Orientation.landscape &&
              media.size.width >= 950.00
          ? "Gestisci formazione"
          : team['nome']),
      drawer: _newRosterManagerDrawer(),
      child: (_reloadNeeded
          ? []
          : new ListView(
              padding: constant.standard_margin,
              children: playerList,
            )),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Aggiungi', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: () async {
          _reloadNeeded = true;
          Map<String, dynamic> player = new Map<String, dynamic>();
          player['squadra'] = team['key'];
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new PlayerProperties(selectedPlayer: player)));
          setState(() => _reloadNeeded = false);
        },
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
        onPressed: () async {
          _reloadNeeded = true;
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new PlayerProperties(selectedPlayer: player)));
          setState(() => _reloadNeeded = false);
        },
        child: new ListTile(
          leading: (player['numeroMaglia'] != null
              ? new Text(
                  player['numeroMaglia'],
                  style: const TextStyle(fontSize: 42.0),
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
}
