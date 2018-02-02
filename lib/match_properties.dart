import 'package:flutter/material.dart';

import 'collect_data.dart';
import 'constants.dart' as constant;
import 'drawer.dart';
import 'local_database.dart';
import 'setnote_widgets.dart';

/// Mostra la lista di squadre presenti nel DB locale.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class MatchTeamList extends StatefulWidget {
  @override
  State createState() => new _MatchTeamListState();
}

/// State di TeamPage.
///
/// Crea una lista basata sulle squadre presenti in locale.
/// [_reloadNeeded] è una variabile ausiliaria che permette di gestire
/// l'attesa del caricamento di alcune componenti.
class _MatchTeamListState extends State<MatchTeamList> {
  bool _reloadNeeded = true;

  /// Costruttore di _MatchTeamPageState.
  ///
  /// Per prima cosa avvia la lettura dei dati nelle SharedPreferences in
  /// quanto operazione potenzialmente lunga ed indispensabile allo
  /// svolgimento delle funzioni base del widget. A caricamento ultimato
  /// imposta la variabile [_reloadNeeded] in modo da aggiornare l'interfaccia.
  _MatchTeamListState() {
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
          _reloadNeeded = true;
          Map<String, dynamic> match = new Map<String, dynamic>();
          match['myTeam'] = team['key'];
          match['key'] = new DateTime.now().millisecondsSinceEpoch.toString();
          match['ended'] = 'false';
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => new MatchProperties(match)));
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
}

class MatchProperties extends StatefulWidget {
  const MatchProperties(this.match);
  final Map<String, dynamic> match;

  @override
  _MatchPropertiesState createState() => new _MatchPropertiesState(match);
}

class _MatchPropertiesState extends State<MatchProperties> {
  Map<String, dynamic> match;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _opposingTeamController =
      new TextEditingController();
  final TextEditingController _dayController = new TextEditingController();
  final TextEditingController _monthController = new TextEditingController();
  final TextEditingController _yearController = new TextEditingController();
  final TextEditingController _manifestationController =
      new TextEditingController();
  final TextEditingController _phaseController = new TextEditingController();
  final TextEditingController _placeController = new TextEditingController();

  /// Costruttore di _MatchPropertiesState.
  ///
  /// Riceve in input [selectedTeamKey] ovvero quella che sarà [myTeam].
  _MatchPropertiesState(this.match) {
    if (match['opposingTeam'] != null)
      _opposingTeamController.text = match['opposingTeam'];
    if (match['day'] != null)
      _opposingTeamController.text = match['day'];
    if (match['month'] != null)
      _opposingTeamController.text = match['month'];
    if (match['year'] != null)
      _opposingTeamController.text = match['year'];
    if (match['manifestation'] != null)
      _opposingTeamController.text = match['manifestation'];
    if (match['phase'] != null)
      _opposingTeamController.text = match['phase'];
    if (match['place'] != null)
      _opposingTeamController.text = match['place'];
    _opposingTeamController.addListener(
        () => match['opposingTeam'] = _opposingTeamController.text);
    _dayController.addListener(() => match['day'] = _dayController.text);
    _monthController.addListener(() => match['month'] = _monthController.text);
    _yearController.addListener(() => match['year'] = _yearController.text);
    _manifestationController.addListener(
        () => match['manifestation'] = _manifestationController.text);
    _phaseController.addListener(() => match['phase'] = _phaseController.text);
    _placeController.addListener(() => match['place'] = _placeController.text);
  }

  // String _validateDay(String value) {
  //   final RegExp nameExp = new RegExp(r'^[0-9]+$');
  //   if (nameExp.hasMatch(value)) {
  //     if (int.parse(value) > 31 && int.parse(value) < 1) return null;
  //   }
  //   return 'Giorno non valido';
  // }

  // String _validateMonth(String value) {
  //   final RegExp nameExp = new RegExp(r'^[0-9]+$');
  //   if (nameExp.hasMatch(value)) {
  //     if (int.parse(value) > 12 && int.parse(value) < 1) return null;
  //   }
  //   return 'Mese non valido';
  // }

  // String _validateYear(String value) {
  //   final RegExp nameExp = new RegExp(r'^[0-9]+$');
  //   if (nameExp.hasMatch(value)) {
  //     if (int.parse(value) > 2100 && int.parse(value) < 1900) return null;
  //   }
  //   return 'Anno non valido';
  // }

  //void showInSnackBar(String value) {
  //  _scaffoldKey.currentState
  //      .showSnackBar(new SnackBar(content: new Text(value)));
  // }

  void _handleSubmitted() {
    //if (!form.validate()) {
    //  setState(() => _autovalidate = true);
    //  _scaffoldKey.currentState
    //      .showSnackBar(new SnackBar(content: new Text('Input non valido')));
    //}
    if (match['ended'] == 'false') {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) => new CollectData(match)));
    } else {
      Navigator.of(context).pop();
    }
  }

  // Metodo che modifica il label accanto allo switch
  // String displaySwitchText() {
  //   if (_enabled == false) return "Femminile";
  //   else return "Maschile";
  // }

  // Metodo che aggiorna il campo isMale di [match] quando l'utente usa lo switch
  // void _changeSwitchValue(){
  //   if (_enabled==true) match['isMale']='maschile';
  //   else match['isMale']='femminile';
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: new Text("Nuova partita")),
      drawer: new Drawer(
        child: new MyDrawer(),
      ),
      floatingActionButton: new FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: _handleSubmitted,
      ),
      body: new Center(
        child: new ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              _newOpposingTeamInput(),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: _newDayInput(),
                  ),
                  new Expanded(
                    child: _newMonthInput(),
                  ),
                  new Expanded(
                    child: _newYearInput(),
                  ),
                ],
              ),
              _newManifestationInput(),
              _newPhaseInput(),
              _newPlaceInput(),
              _newDeleteMatch(),
              //_newSexSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  TextField _newOpposingTeamInput() {
    return new TextField(
      controller: _opposingTeamController,
      decoration: const InputDecoration(
        hintText: 'Qual è il nome della squadra avversaria?',
        labelText: 'Squadra Avversaria *',
      ),
    );
  }

  TextField _newDayInput() {
    return new TextField(
      controller: _dayController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'GG',
        labelText: 'Giorno *',
      ),
    );
  }

  TextField _newMonthInput() {
    return new TextField(
      controller: _monthController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'MM',
        labelText: 'Mese *',
      ),
    );
  }

  TextField _newYearInput() {
    return new TextField(
      controller: _yearController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'AAAA',
        labelText: 'Anno *',
      ),
    );
  }

  TextField _newManifestationInput() {
    return new TextField(
      controller: _manifestationController,
      decoration: const InputDecoration(
        hintText: 'Che manifestazione è?',
        labelText: 'Manifestazione *',
      ),
    );
  }

  TextField _newPhaseInput() {
    return new TextField(
      controller: _phaseController,
      decoration: const InputDecoration(
        hintText: 'Che fase della competizione è?',
        labelText: 'Fase *',
      ),
    );
  }

  TextField _newPlaceInput() {
    return new TextField(
      controller: _placeController,
      decoration: const InputDecoration(
        hintText: 'Dove si svolge la partita?',
        labelText: 'Luogo *',
      ),
    );
  }

  /// Genera un nuovo pulsante per eliminare la partita correntemente
  /// selezionata dal database locale.
  Widget _newDeleteMatch() {
    // Se nessuna partita è selezionata (sto creando una nuova partita) non
    // mostrare nulla.
    if (match['ended'] == 'false') {
      return new Container(width: 0.0, height: 0.0);
    }
    return new Padding(
      padding: constant.standard_margin,
      child: new Center(
        child: new RaisedButton(
          child: const Text('Elimina partita'),
          onPressed: _deleteMatch,
        ),
      ),
    );
  }

  /// Elimina il giocatore correntemente selezionato dal database locale.
  void _deleteMatch() {
    LocalDB.removeMatch(match['key']);
    Navigator.of(context).pop();
  }

  // Row _newSexSwitch() {
  //   return new Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //       new Switch(
  //         value: _enabled,
  //         activeColor: Colors.blue,
  //         inactiveThumbColor: Colors.pink,
  //         inactiveTrackColor: Colors.pink[200],
  //         onChanged: (bool value) {
  //           setState(() {
  //             _enabled = value;
  //             _changeSwitchValue();
  //           });
  //         },
  //       ),
  //       new Center(
  //           child: new Text(
  //           displaySwitchText(),
  //         textAlign: TextAlign.center,
  //       )),
  //     ],
  //   );
  // }
}
