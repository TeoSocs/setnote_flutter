import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

class AddTeam extends StatefulWidget {
  AddTeam({this.title});
  final String title;

  @override
  AddTeamState createState() => new AddTeamState(title: title);
}

class AddTeamState extends State<AddTeam> {
  AddTeamState({this.title});
  String title;
  String _nomeSquadra;
  String _allenatore;
  String _assistente;
  String _categoria;
  String _stagione;
  Color _coloreMaglia;
  bool _whiteButtonText = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_coloreMaglia == null) {
      _coloreMaglia = Theme.of(context).buttonColor;
    }
    return new SetnoteFormLayout(
      title: title,
      largeScreen: new Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: constant.standard_margin,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new MyTabletTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome squadra',
                    hintText: 'CAME Casier',
                  ),
                  onSaved: (String value) {
                    _nomeSquadra = value;
                  },
                ),
                new RaisedButton(
                  color: _coloreMaglia,
                  child: new Text(
                    "Colore di maglia",
                    style: new TextStyle(
                        color:
                            (_whiteButtonText ? Colors.white : Colors.black)),
                  ),
                  onPressed: () {
                    showDialog<Color>(
                      context: context,
                      child: new SetnoteColorSelector(),
                    )
                        .then((Color newColor) => setState(() {
                              _coloreMaglia = newColor;
                              if (newColor.computeLuminance() > 0.179) {
                                _whiteButtonText = false;
                              } else {
                                _whiteButtonText = true;
                              }
                            }));
                  },
                )
              ],
            ),
            new Row(
              children: <Widget>[
                new MyTabletTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Allenatore',
                    hintText: 'G. Povia',
                  ),
                  onSaved: (String value) {
                    _allenatore = value;
                  },
                ),
                new MyTabletTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Assistente',
                    hintText: 'A. Uscolo',
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new MyTabletTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    hintText: 'Serie C Maschile',
                  ),
                  onSaved: (String value) {
                    _categoria = value;
                  },
                ),
                new MyTabletTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Stagione',
                    hintText: '2018',
                  ),
                  onSaved: (String value) {
                    _stagione = value;
                  },
                ),
              ],
            ),
            new SetnoteButton(
              label: "Aggiungi squadra",
              onPressed: submit,
            )
          ],
        ),
      ),
      smallScreen: new Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: constant.standard_margin,
          children: <Widget>[
            new MyPhoneTextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome squadra',
                hintText: 'CAME Casier',
              ),
              onSaved: (String value) {
                _nomeSquadra = value;
              },
            ),
            new Center(
              child: new Padding(
                padding: constant.standard_margin,
                child: new RaisedButton(
                  color: _coloreMaglia,
                  child: new Text(
                    "Colore di maglia",
                    style: new TextStyle(
                        color: (_whiteButtonText ? Colors.white : Colors.black)),
                  ),
                  onPressed: () {
                    showDialog<Color>(
                      context: context,
                      child: new SetnoteColorSelector(),
                    )
                        .then((Color newColor) => setState(() {
                              _coloreMaglia = newColor;
                              if (newColor.computeLuminance() > 0.179) {
                                _whiteButtonText = false;
                              } else {
                                _whiteButtonText = true;
                              }
                            }));
                  },
                ),
              ),
            ),
            new MyPhoneTextFormField(
              decoration: const InputDecoration(
                labelText: 'Allenatore',
                hintText: 'G. Povia',
              ),
              onSaved: (String value) {
                _allenatore = value;
              },
            ),
            new MyPhoneTextFormField(
              decoration: const InputDecoration(
                labelText: 'Assistente',
                hintText: 'A. Uscolo',
              ),
            ),
            new MyPhoneTextFormField(
              decoration: const InputDecoration(
                labelText: 'Categoria',
                hintText: 'Serie C Maschile',
              ),
              onSaved: (String value) {
                _categoria = value;
              },
            ),
            new MyPhoneTextFormField(
              decoration: const InputDecoration(
                labelText: 'Stagione',
                hintText: '2018',
              ),
              onSaved: (String value) {
                _stagione = value;
              },
            ),
            new SetnoteButton(
              label: "Aggiungi squadra",
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    final FormState form = _formKey.currentState;
    form.save();
    constant.teamDB.push().set({
      'nome': _nomeSquadra,
      'allenatore': _allenatore,
      'assistente': _assistente,
      'stagione': _stagione,
      'categoria': _categoria,
      'colore_maglia': _coloreMaglia.toString(),
    });
    analytics.logEvent(name: 'Aggiunta squadra');
    Navigator.of(context).pushReplacementNamed("/team");
  }
}
