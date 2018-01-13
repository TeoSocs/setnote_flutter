import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

class RosterManager extends StatefulWidget {
  RosterManager({this.teamKey});
  final String teamKey;

  @override
  State createState() => new _RosterManagerState(teamKey: teamKey);
}

class _RosterManagerState extends State<RosterManager> {
  _RosterManagerState({this.teamKey}) {
    rosterDB = constant.teamDB.child(teamKey+'/giocatori');
  }
  String teamKey;
  bool logged = false;
  DatabaseReference rosterDB;

  @override
  Widget build(BuildContext context) {
    login();
    return new Scaffold(
      appBar: new AppBar(title: const Text("Gestisci formazione")),
      body: new LoadingWidget(
        condition: logged,
        child: new Scaffold(
          body: new FirebaseAnimatedList(
            query: rosterDB,
            sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
            padding: constant.standard_margin,
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
              return _newListEntry(snapshot);
            },
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: null,
            tooltip: 'Aggiungi', // used by assistive technologies
            child: new Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => logged = true);
  }

  Widget _newListEntry(DataSnapshot snapshot) {
    return new Card(
        child: new FlatButton(
      onPressed: null,
      child: new ListTile(
        leading: new Icon(
          Icons.android,
        ),
        title: new Text(snapshot.value['nome']),
        subtitle: new Text(snapshot.value['ruolo']),
      ),
    ));
  }
}
