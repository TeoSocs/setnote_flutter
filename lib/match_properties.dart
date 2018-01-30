import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
import 'local_database.dart'; //TODO aggiungere match qui dentro
import 'setnote_widgets.dart';
import 'google_auth.dart';

class MatchProperties extends StatefulWidget {
  const MatchProperties({this.title});
  final String title;

  @override
  _MatchPropertiesState createState() =>
      new _MatchPropertiesState(title: title);
}

class _MatchPropertiesState extends State<MatchProperties> {
  final String title;
  bool _enabled = false;
  bool _autovalidate = false;

  /// Template match:
  ///
  /// {
  ///   String opposingTeam = '';
  ///   String matchCode = '';
  ///   String day = '';
  ///   String month = '';
  ///   String year = '';
  ///   String manifestation = '';
  ///   String phase = '';
  ///   String place = '';
  ///   String isMale = 'false';
  /// }
  Map<String, dynamic> match = new Map<String, dynamic>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController _opposingTeamController =
      new TextEditingController();
  final TextEditingController _matchCodeController =
      new TextEditingController();
  final TextEditingController _dayController = new TextEditingController();
  final TextEditingController _monthController = new TextEditingController();
  final TextEditingController _yearController = new TextEditingController();
  final TextEditingController _manifestationController =
      new TextEditingController();
  final TextEditingController _phaseController = new TextEditingController();
  final TextEditingController _placeController = new TextEditingController();
 int radioValue = 0;
  /// Costruttore di _MatchPropertiesState.
  ///
  /// Riceve in input il [title] da applicare allo scaffold.
  _MatchPropertiesState({this.title}) {
    _opposingTeamController.addListener(
        () => match['opposingTeam'] = _opposingTeamController.text);

    _matchCodeController.addListener(
        () => match['matchCode'] = _matchCodeController.text);

    _dayController.addListener(
        () => match['day'] = _dayController.text);

    _monthController.addListener(
        () => match['month'] = _monthController.text);

    _yearController.addListener(
        () => match['year'] = _yearController.text);

    _manifestationController.addListener(
        () => match['manifestation'] = _manifestationController.text);

    _phaseController.addListener(
        () => match['phase'] = _phaseController.text);

    _placeController.addListener(
        () => match['place'] = _placeController.text);

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

//  String _validateYear(String value) {
//    final RegExp nameExp = new RegExp(r'^[0-9]+$');
//    if (nameExp.hasMatch(value)) {
//      if (int.parse(value) > 2100 && int.parse(value) < 1900) return null;
//    }
//    return 'Anno non valido';
//  }


/// Salva la partita nel database.
/// 
/// 
void _saveMatchOnDatabase(Map<String, dynamic> match) {
    DatabaseReference newMatch = FirebaseDatabase.instance.reference().child('partite').push();
    LocalDB.changeMatchKey(
      oldKey: match['key'],
      newKey: newMatch.key,
    );
    newMatch.set({
      //'ultima_modifica': match['ultima_modifica'],
      'myTeam': match['myTeam'],
      'opposingTeam': match['opposingTeam'],
      'matchCode': match['matchCode'],
      'day': match['day'],
      'month': match['month'],
      'year': match['year'],
      'manifestation': match['manifestation'],
      'phase': match['phase'],
      'place': match['place'],
      'isMale': match['isMale'],
    });
    analytics.logEvent(name: 'aggiunta_squadra');
}

  //void showInSnackBar(String value) {
  //  _scaffoldKey.currentState
  //      .showSnackBar(new SnackBar(content: new Text(value)));
 // }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    //if (!form.validate()) {
    //  setState(() => _autovalidate = true);
    //  _scaffoldKey.currentState
    //      .showSnackBar(new SnackBar(content: new Text('Input non valido')));
    //}
    form.save();
    _saveMatchOnDatabase(match);
    Navigator.of(context).pushNamed("/dataentry");
  }

///Metodo che modifica il label accanto allo switch
  String displaySwitchText() {
    if (_enabled == false) return "Femminile";
    else return "Maschile";
  }


/// Metodo che aggiorna il campo isMale di [match] quando l'utente usa lo switch
  void _changeSwitchValue(){
    if (_enabled==true) match['isMale']='maschile';
    else match['isMale']='femminile';
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: new Text(constant.app_name + " - " + title)),
      drawer: new Drawer(
        child: new MyDrawer(),
      ),
      body: new Center(
        child: new ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420.0),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Form(
                  key: _formKey,
                  autovalidate: _autovalidate,
                  child: new ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: <Widget>[
                      _newOpposingTeamInput(),
                      _newMatchCodeInput(),
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
                      _newSexSwitch(),
                      _newFormationsButton(),
                    ],
                  ),
                ),
              ),
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

  TextField _newMatchCodeInput() {
    return new TextField(
      controller: _matchCodeController,
      decoration: const InputDecoration(
        hintText: 'Qual è il codice della gara?',
        labelText: 'Codice Gara *',
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

  Row _newSexSwitch() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Switch(
          value: _enabled,
          activeColor: Colors.blue,
          inactiveThumbColor: Colors.pink,
          inactiveTrackColor: Colors.pink[200],
          onChanged: (bool value) {
            setState(() {
              _enabled = value;
              _changeSwitchValue();
            });
          },
        ),
        new Center(
            child: new Text(
            displaySwitchText(),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }

  SetnoteButton _newFormationsButton() {
    return new SetnoteButton(
      label: constant.formations_label,
      onPressed: _handleSubmitted,
    );
  }
}
