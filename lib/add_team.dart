import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_color_picker/material_color_picker.dart';
import 'package:setnote_flutter/form_items.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;

class AddTeam extends StatefulWidget {
  AddTeam({this.title});
  final String title;

  @override
  AddTeamState createState() => new AddTeamState(title: title);
}

class AddTeamState extends State<AddTeam> {
  AddTeamState({this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return new SetnoteFormLayout(
      title: title,
      largeScreen: new Form(
        autovalidate: true,
        child: new ListView(
          padding: constant.standard_margin,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new MyTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome squadra',
                    hintText: 'CAME Casier',
                  ),
                ),
                new MyTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    hintText: 'Serie C Maschile',
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new MyTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Allenatore',
                    hintText: 'G. Povia',
                  ),
                ),
                new MyTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Assistente',
                    hintText: 'A. Uscolo',
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new MyTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Stagione',
                    hintText: '2018',
                  ),
                ),
                new RaisedButton(
                  child: new Text(
                    'Colore maglia',
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    child: new SimpleDialog(
                      title: const Text('Scegli il colore'),
                      children: <Widget>[
                        new ColorPicker(
                          type: MaterialType.transparency,
                          onColor: (color) {
                            Navigator.pop(context, color);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      smallScreen: new Text("Non ancora ottimizzato per schermi piccoli"),
    );
  }
}

Future<Color> askedToLead(BuildContext context) async => await showDialog(
      context: context,
      child: new SimpleDialog(
        title: const Text('Scegli il colore'),
        children: <Widget>[
          new ColorPicker(
            type: MaterialType.transparency,
            onColor: (color) {
              Navigator.pop(context, color);
            },
            currentColor: Theme.of(context).buttonColor,
          ),
        ],
      ),
    );
