import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
import 'setnote_widgets.dart';

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

  /// Costruttore di _MatchPropertiesState.
  ///
  /// Riceve in input il [title] da applicare allo scaffold.
  _MatchPropertiesState({this.title});

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    form.save();
    Navigator.of(context).pushNamed("/formations");
  }

  int radioValue = 0;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
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

  TextFormField _newOpposingTeamInput() {
    return new TextFormField(
      controller: _opposingTeamController,
      initialValue: _opposingTeamController.text,
      decoration: const InputDecoration(
        hintText: 'Qual è il nome della squadra avversaria?',
        labelText: 'Squadra Avversaria *',
      ),
    );
  }

  TextFormField _newMatchCodeInput() {
    return new TextFormField(
      controller: _matchCodeController,
      initialValue: _matchCodeController.text,
      decoration: const InputDecoration(
        hintText: 'Qual è il codice della gara?',
        labelText: 'Codice Gara *',
      ),
    );
  }

  TextFormField _newDayInput() {
    return new TextFormField(
      controller: _dayController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'GG',
        labelText: 'Giorno *',
      ),
    );
  }

  TextFormField _newMonthInput() {
    return new TextFormField(
      controller: _monthController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'MM',
        labelText: 'Mese *',
      ),
    );
  }

  TextFormField _newYearInput() {
    return new TextFormField(
      controller: _yearController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'AAAA',
        labelText: 'Anno *',
      ),
    );
  }

  TextFormField _newManifestationInput() {
    return new TextFormField(
      controller: _manifestationController,
      decoration: const InputDecoration(
        hintText: 'Che manifestazione è?',
        labelText: 'Manifestazione *',
      ),
    );
  }

  TextFormField _newPhaseInput() {
    return new TextFormField(
      controller: _phaseController,
      decoration: const InputDecoration(
        hintText: 'Che fase della competizione è?',
        labelText: 'Fase *',
      ),
    );
  }

  TextFormField _newPlaceInput() {
    return new TextFormField(
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
            });
          },
        ),
        new Center(
            child: new Text(
          'asdasd',
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
