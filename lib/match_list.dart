import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'match_properties.dart';
import 'match_stats.dart';
import 'setnote_widgets.dart';

/// Mostra le partite presenti nel DB locale.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class MatchList extends StatefulWidget {
  @override
  State createState() => new _MatchListState();
}

/// State di [MatchList].
///
/// Crea una lista basata sulle squadre presenti in locale.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa del caricamento di alcune componenti.
class _MatchListState extends State<MatchList> {
  bool _reloadNeeded = true;

  /// Costruttore di [_MatchListState].
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
    Map<String, dynamic> _team = LocalDB.getTeamByKey(match['myTeam']);
    String _myTeamName = _team['nome'];
    Color _coloreMaglia =
        (_team['coloreMaglia'] != 'null' && _team['coloreMaglia'] != null
            ? new Color(
                int.parse(_team['coloreMaglia'].substring(8, 16), radix: 16))
            : Theme.of(context).buttonColor);
    String _opposingTeamName =
        (match['opposingTeam'] != '' && match['opposingTeam'] != null
            ? match['opposingTeam']
            : "Avversario sconosciuto");
    String manifestazione = (match['manifestation'] != null
        ? match['manifestation']
        : 'Competizione sconosciuta');
    String anno = (match['year'] != null ? match['year'] : 'Anno sconosciuto');
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: new ListTile(
          leading: new Icon(
            Icons.group,
            color: _coloreMaglia,
          ),
          title: new Text("$_myTeamName VS $_opposingTeamName"),
          subtitle: new Text(manifestazione + ' - ' + anno),
          onLongPress: () async {
            _reloadNeeded = true;
            await Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) => new MatchProperties(match)));
            setState(() => _reloadNeeded = false);
          },
          onTap: () async {
            _reloadNeeded = true;
            await Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) => new MatchStats(match)));
            setState(() => _reloadNeeded = false);
          },
        ),
      ),
    );
  }
}
