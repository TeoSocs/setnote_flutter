import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/local_team_list.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

class RosterManager extends StatefulWidget {
  RosterManager({this.team});
  final Map<String, dynamic> team;

  @override
  State createState() => new _RosterManagerState(team: team);
}

class _RosterManagerState extends State<RosterManager> {
  _RosterManagerState({this.team}) {
    rosterDB = FirebaseDatabase.instance
        .reference()
        .child('squadre/' + team['key'] + '/giocatori');
  }
  Map<String, dynamic> team;
  bool logged = false;
  DatabaseReference rosterDB;

  @override
  Widget build(BuildContext context) {
    login();
    MediaQueryData media = MediaQuery.of(context);
    return new SetnoteBaseLayout(
      title: (media.orientation == Orientation.landscape &&
              media.size.width >= 950.00
          ? "Gestisci formazione"
          : team['nome']),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new DrawerHeader(
            child: new Align(
              alignment: Alignment.bottomLeft,
              child: new Text(
                team['nome'],
                style: Theme.of(context).primaryTextTheme.headline,
              ),
            ),
            decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          new ListTile(
            title: new Text(team['categoria'] + ' - ' + team['stagione']),
          ),
        ]),
      ),
      child: new LoadingWidget(
        condition: logged,
        child: new FirebaseAnimatedList(
          query: rosterDB,
          sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
          padding: constant.standard_margin,
          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
            return _newListEntry(snapshot);
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Aggiungi', // used by assistive technologies
        child: new Icon(Icons.add),
      ),
    );
  }

  Card _newListEntry(DataSnapshot snapshot) {
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
      ),
    );
  }

  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => logged = true);
  }
}
