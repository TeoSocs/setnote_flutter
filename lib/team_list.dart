import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'setnote_widgets.dart';
import 'team_cloud.dart';
import 'team_properties.dart';

/// Mostra la lista di squadre presenti nel DB locale.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class TeamList extends StatefulWidget {
  @override
  State createState() => new _TeamListState();
}

/// State di TeamPage.
///
/// Crea una lista basata sulle squadre presenti in locale.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa del caricamento di alcune componenti.
class _TeamListState extends State<TeamList> {
  bool _reloadNeeded = true;

  /// Costruttore di _TeamPageState.
  ///
  /// Per prima cosa avvia la lettura dei dati nelle SharedPreferences in
  /// quanto operazione potenzialmente lunga ed indispensabile allo
  /// svolgimento delle funzioni base del widget. A caricamento ultimato
  /// imposta la variabile [_reloadNeeded] in modo da aggiornare l'interfaccia.
  _TeamListState() {
    LocalDB.readFromFile().then((x) => setState(() => _reloadNeeded = false));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> teamList = new List<Widget>();
    for (Map<String, dynamic> _team in LocalDB.teams) {
      teamList.add(_newTeamPageCard(_team));
    }
    teamList.add(_addNewTeamCard());
    setState(() => _reloadNeeded = false);
    return new SetnoteBaseLayout(
      title: 'Squadre salvate',
      child: new ListView(
        padding: constant.standard_margin,
        children: _reloadNeeded ? [] : teamList,
      ),
      floatingActionButton: new RaisedButton(
        onPressed: () async {
          _reloadNeeded = true;
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => new TeamDownloader()));
          setState(() => _reloadNeeded = false);
        },
        child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: new Icon(
                Icons.cloud,
                color: Theme.of(context).accentIconTheme.color,
              )),
          new Text(
            "Squadre nel cloud",
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ]),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  /// Costruisce una Card rappresentante la squadra passata in input.
  Card _newTeamPageCard(Map<String, dynamic> team) {
    return new Card(
      child: new FlatButton(
        onPressed: () async {
          _reloadNeeded = true;
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new TeamProperties(selectedTeam: team)));
          setState(() => _reloadNeeded = false);
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

  /// Costruisce una Card che fa da pulsante per la creazione di una nuova
  /// squadra.
  Card _addNewTeamCard() {
    return new Card(
      elevation: 0.5,
      child: new FlatButton(
        onPressed: () async {
          _reloadNeeded = true;
          Map<String, dynamic> team = new Map<String, dynamic>();
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new TeamProperties(selectedTeam: team)));
          setState(() => _reloadNeeded = false);
        },
        child: new ListTile(
          leading: new Icon(Icons.add),
          title: const Text('Aggiungi una nuova squadra'),
        ),
      ),
    );
  }
}
