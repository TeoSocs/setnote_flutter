import 'package:flutter/material.dart';
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
                new SetnoteColorSelectorButton(
                  child: new Text("Colore di maglia"),
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
                    labelText: 'Categoria',
                    hintText: 'Serie C Maschile',
                  ),
                ),
                new MyTextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Stagione',
                    hintText: '2018',
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
