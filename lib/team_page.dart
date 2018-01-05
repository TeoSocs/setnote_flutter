import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
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
    return new Scaffold(
      appBar: new AppBar(title: new Text(constant.app_name + " - " + title)),
      drawer: new Drawer(
        child: new MyDrawer(),
      ),
      body: (logged
          ? new Column(children: <Widget>[
              new Flexible(
                child: new FirebaseAnimatedList(
                  query: teamDB,
                  sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
                  padding: new EdgeInsets.all(8.0),
                  // reverse: true,
                  itemBuilder:
                      (_, DataSnapshot snapshot, Animation<double> animation) {
                    return new TeamListEntry(
                      snapshot: snapshot,
                    );
                  },
                ),
              ),
              new Center(
                child: new RaisedButton(
                  child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text("Carica squadre di prova")),
                  onPressed: () => creaEntryDiProva(),
                ),
              ),
            ])
          : new Center(child: new CircularProgressIndicator())),
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
    return new Text(snapshot.value['nome'] + ' ' + snapshot.value['categoria'] + ' ' + snapshot.value['stagione']);
  }
}
