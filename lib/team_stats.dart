import 'package:flutter/material.dart';

import 'charts/stat_chart.dart';
import 'constants.dart' as constant;
import 'local_database.dart';
import 'setnote_widgets.dart';

/// Mostra la lista di squadre presenti nel DB locale.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class StatsTeamList extends StatefulWidget {
  @override
  State createState() => new _StatsTeamListState();
}

/// State di [StatsTeamList].
///
/// Crea una lista basata sulle squadre presenti in locale.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa del caricamento di alcune componenti.
class _StatsTeamListState extends State<StatsTeamList> {
  bool _reloadNeeded = true;

  /// Costruttore di _MatchTeamPageState.
  ///
  /// Per prima cosa avvia la lettura dei dati nelle SharedPreferences in
  /// quanto operazione potenzialmente lunga ed indispensabile allo
  /// svolgimento delle funzioni base del widget. A caricamento ultimato
  /// imposta la variabile [_reloadNeeded] in modo da aggiornare l'interfaccia.
  _StatsTeamListState() {
    LocalDB.readFromFile().then((x) => setState(() => _reloadNeeded = false));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> teamList = new List<Widget>();
    for (Map<String, dynamic> _team in LocalDB.teams) {
      teamList.add(_newTeamPageCard(_team));
    }
    setState(() => _reloadNeeded = false);
    return new SetnoteBaseLayout(
      title: 'Scegli una squadra',
      child: new ListView(
        padding: constant.standard_margin,
        children: _reloadNeeded ? [] : teamList,
      ),
    );
  }

  /// Costruisce una Card rappresentante la squadra passata in input.
  Card _newTeamPageCard(Map<String, dynamic> team) {
    return new Card(
      child: new FlatButton(
        onPressed: () async {
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new AggregateStats(team: team)));
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
}

class AggregateStats extends StatefulWidget {
  AggregateStats({this.team, this.player});

  final Map<String, dynamic> player;

  final Map<String, dynamic> team;

  @override
  State createState() => new _AggregateStatsState(team, player);
}

class _AggregateStatsState extends State<AggregateStats> {
  _AggregateStatsState(this.team, this.player)
      : this.dataSet = (team != null ? team['dataSet'] : player['dataSet']) {
    double _maxNumberOfActions = 0.0;
    double _numberOfActions = 0.0;
    for (String fondamentale in constant.fondamentali) {
      _numberOfActions = 0.0;
      for (String esito in constant.esiti) {
        _numberOfActions += dataSet[fondamentale][esito];
      }
      if (_numberOfActions > _maxNumberOfActions)
        _maxNumberOfActions = _numberOfActions;
    }
    if (_scaleCoefficient == 0 && _maxNumberOfActions != 0.0) {
      _scaleCoefficient = 400.0 / _maxNumberOfActions;
    }
  }

  Map<String, dynamic> team;
  Map<String, dynamic> player;
  final Map<String, Map<String, double>> dataSet;

  double _scaleCoefficient = 0.0;

  @override
  Widget build(BuildContext context) {
    return new SetnoteBaseLayout(
      title: 'Statistiche squadra',
      child: _gridBuilder(),
      drawer: new Drawer(
        child: new ListView(
          children: _playerListBuilder(),
        ),
      ),
    );
  }

  Widget _gridBuilder() {
    return new GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 2,
      children: <Widget> [
        _statsTableBuilder("Media dati", dataSet),
        new StatChart(dataSet: dataSet, scaleCoefficient: _scaleCoefficient)
      ],
    );
  }

  Widget _statsTableBuilder(String title, Map<String, dynamic> data) {
    double battuteTotali = 0.0;
    for (String esito in constant.esiti) {
      battuteTotali += data["Battuta"][esito];
    }
    double battutaPositivita = 0.0;
    if (battuteTotali != 0.0)
      battutaPositivita =
          (data['Battuta']['Ottimo'] + data['Battuta']['Buono']) *
              100 /
              battuteTotali;

    double ricezioniTotali = 0.0;
    for (String esito in constant.esiti) {
      ricezioniTotali += data["Ricezione"][esito];
    }
    double ricezionePositivita = 0.0;
    double ricezionePerfezione = 0.0;
    if (ricezioniTotali != 0.0) {
      ricezionePositivita =
          (data['Ricezione']['Ottimo'] + data['Ricezione']['Buono']) *
              100 /
              ricezioniTotali;

      ricezionePerfezione = data['Ricezione']['Ottimo'] * 100 / ricezioniTotali;
    }

    double attacchiTotali = 0.0;
    for (String esito in constant.esiti) {
      attacchiTotali += data["Attacco"][esito];
    }
    double attaccoEfficienza = 0.0;
    if (attacchiTotali != 0.0) {
      attaccoEfficienza = 5.0;
      attaccoEfficienza += (5.0 / attacchiTotali) *
          (data['Attacco']['Ottimo'] -
              (data['Attacco']['Scarso'] + data['Attacco']['Errato']));
    }

    double difeseTotali = 0.0;
    for (String esito in constant.esiti) {
      difeseTotali += data["Difesa"][esito];
    }
    double difesaPositivita = 0.0;
    double difesaPerfezione = 0.0;
    if (difeseTotali != 0.0) {
      difesaPositivita = (data['Difesa']['Ottimo'] + data['Difesa']['Buono']) *
          100 /
          difeseTotali;

      difesaPerfezione = data['Difesa']['Ottimo'] * 100 / difeseTotali;
    }

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
              new Text("$attacchiTotali")
            ]),
            new TableRow(children: <Widget>[
              const Text("Errori"),
              new Text("${data['Attacco']['Errato']}")
            ]),
            new TableRow(children: <Widget>[
              const Text("Punti"),
              new Text("${data['Attacco']['Ottimo']}")
            ]),
            new TableRow(children: <Widget>[
              const Text("Efficienza"),
              new Text("$attaccoEfficienza")
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
              new Text("$difeseTotali")
            ]),
            new TableRow(children: <Widget>[
              const Text("Errori"),
              new Text("${data['Difesa']['Errato']}")
            ]),
            new TableRow(children: <Widget>[
              const Text("Positività"),
              new Text("$difesaPositivita%")
            ]),
            new TableRow(children: <Widget>[
              const Text("Perfezione"),
              new Text("$difesaPerfezione%")
            ]),
          ],
        ),
      ],
    );
  }

  List<Widget> _playerListBuilder() {
    List<Widget> playerList = new List<Widget>();
    for (Map<String, dynamic> _player
        in LocalDB.getPlayersOf(teamKey: team['key'])) {
      playerList.add(_listEntryBuilder(_player));
    }
    return playerList;
  }

  Card _listEntryBuilder(Map<String, dynamic> _player) {
    return new Card(
      child: new FlatButton(
        onPressed: () async {
          if (player != null) {
            await Navigator.of(context).pushReplacement(
                new MaterialPageRoute<Null>(
                    builder: (BuildContext context) =>
                        new AggregateStats(player: _player)));
          } else {
            await Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) =>
                    new AggregateStats(player: _player)));
          }
        },
        child: new ListTile(
          leading: (_player['numeroMaglia'] != null
              ? new Text(
                  _player['numeroMaglia'],
                  style: const TextStyle(fontSize: 33.0),
                )
              : new Icon(
                  Icons.person,
                )),
          title: new Text(_player['nome']),
          subtitle: new Text(_player['ruolo']),
        ),
      ),
    );
  }
}
