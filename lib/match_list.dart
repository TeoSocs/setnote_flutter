import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'match_properties.dart';
import 'setnote_widgets.dart';

/// Mostra le partite presenti nel DB locale.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class MatchList extends StatefulWidget {
  @override
  State createState() => new _MatchListState();
}

/// State di TeamPage.
///
/// Crea una lista basata sulle squadre presenti in locale.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa del caricamento di alcune componenti.
class _MatchListState extends State<MatchList> {
  bool _reloadNeeded = true;

  /// Costruttore di _TeamPageState.
  ///
  /// Per prima cosa avvia la lettura dei dati nelle SharedPreferences in
  /// quanto operazione potenzialmente lunga ed indispensabile allo
  /// svolgimento delle funzioni base del widget. A caricamento ultimato
  /// imposta la variabile [_reloadNeeded] in modo da aggiornare l'interfaccia.
  _MatchListState() {
    LocalDB.readFromFile().then((x) => setState(() => _reloadNeeded = false));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> matchList = new List<Widget>();
    for (Map<String, dynamic> _match in LocalDB.matches) {
      matchList.add(_newMatchListCard(_match));
    }
    setState(() => _reloadNeeded = false);
    return new SetnoteBaseLayout(
      title: 'Partite salvate',
      child: new ListView(
        padding: constant.standard_margin,
        children: _reloadNeeded ? [] : matchList,
      ),
    );
  }

  /// Costruisce una Card rappresentante la squadra passata in input.
  Card _newMatchListCard(Map<String, dynamic> match) {
    String _myTeamName = LocalDB.getTeamByKey(match['myTeam'])['nome'];
    Map<String, dynamic> _opposingTeam =
        LocalDB.getTeamByKey(match['opposingTeam']);
    String _opposingTeamName = (_opposingTeam != null
        ? _opposingTeam['nome']
        : "Avversario sconosciuto");
    String manifestazione = (match['manifestation'] != null
        ? match['manifestation']
        : 'Competizione sconosciuta');
    String anno = (match['year'] != null ? match['year'] : 'Anno sconosciuto');
    return new Card(
      child: new FlatButton(
        onPressed: () async {
          _reloadNeeded = true;
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => new MatchProperties(match)));
          setState(() => _reloadNeeded = false);
        },
        child: new ListTile(
          leading: new Icon(Icons.group),
          title: new Text("$_myTeamName VS $_opposingTeamName"),
          subtitle: new Text(manifestazione + ' - ' + anno),
        ),
      ),
    );
  }
}
