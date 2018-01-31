import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
import 'local_database.dart';
import 'setnote_widgets.dart';
import 'collect_data.dart';

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
      title: 'Squadre salvate',
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
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => new MatchProperties(team)));
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
  const MatchProperties(this.selectedTeam);
  final Map<String, dynamic> selectedTeam;

  @override
  _MatchPropertiesState createState() =>
      new _MatchPropertiesState(selectedTeam);
}

class _MatchPropertiesState extends State<MatchProperties> {
  // Template match:
  //
  // {
  //   String myTeam;
  //   String opposingTeam = '';
  //   String matchCode = '';
  //   String day = '';
  //   String month = '';
  //   String year = '';
  //   String manifestation = '';
  //   String phase = '';
  //   String place = '';
  // }
  Map<String, dynamic> match = new Map<String, dynamic>();

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
  /// Riceve in input [selectedTeam] ovvero quella che sarà [myTeam].
  _MatchPropertiesState(Map<String, dynamic> selectedTeam) {
    match['myTeam'] = selectedTeam;
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
    Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => new CollectData()));
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
        child: const Icon(Icons.library_add),
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
