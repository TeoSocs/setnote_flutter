import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

final teamDB = FirebaseDatabase.instance.reference().child('squadre');

class TeamPage extends StatefulWidget {
  TeamPage({this.title});
  final String title;

  @override
  State createState() => new _TeamPageState(title: title);
}

class _TeamPageState extends State<TeamPage> {
  _TeamPageState({this.title});

  final String title;
  bool logged = false;

  @override
  Widget build(BuildContext context) {
    login();
    return new SetnoteBaseLayout(
      title: title,
      child: new LoadingWidget(
        condition: logged,
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                query: teamDB,
                sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
                padding: constant.standard_margin,
                itemBuilder:
                    (_, DataSnapshot snapshot, Animation<double> animation) {
                  return new TeamListEntry(
                    snapshot: snapshot,
                  );
                },
              ),
            ),
            new RaisedButton(
              child: new Padding(
                  padding: constant.standard_margin,
                  child: new Text("Carica squadre di prova")),
              onPressed: () => creaEntryDiProva(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => logged = true);
  }

  void creaEntryDiProva() {
    //TODO: elimina alla fine dei test
    teamDB.push().set({
      'id': 'cas18CM',
      'nome': 'Casier',
      'stagione': '2018',
      'categoria': 'Serie C Maschile',
      'giocatori': {
        'pincopallo': 'schifo',
      },
    });
    analytics.logEvent(name: 'Aggiunta squadra');
    teamDB.push().set({
      'id': 'mog18IM',
      'nome': 'Mogliano',
      'stagione': '2018',
      'categoria': 'Prima divisione Maschile',
    });
    analytics.logEvent(name: 'Aggiunta squadra');
  }
}

class TeamListEntry extends StatelessWidget {
  TeamListEntry({this.snapshot});
  final DataSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return new Text(snapshot.value['nome'] +
        ' ' +
        snapshot.value['categoria'] +
        ' ' +
        snapshot.value['stagione']);
  }
}
