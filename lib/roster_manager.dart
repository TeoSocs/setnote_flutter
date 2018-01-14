import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/manage_team_model.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

class RosterManager extends StatefulWidget {
  RosterManager({this.team});
  final TeamInstance team;

  @override
  State createState() => new _RosterManagerState(team: team);
}

class _RosterManagerState extends State<RosterManager> {
  _RosterManagerState({this.team}) {
    rosterDB = constant.teamDB.child(team.key + '/giocatori');
  }
  TeamInstance team;
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
          : team.nomeSquadra),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new DrawerHeader(
            child: new Align(
              alignment: Alignment.bottomLeft,
              child: new Text(
                team.nomeSquadra,
                style: Theme.of(context).primaryTextTheme.headline,
              ),
            ),
            decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          new ListTile(
            title: new Text(team.categoria + ' - ' + team.stagione),
          ),
        ]),
      ),
      child: new LoadingWidget(
        condition: logged,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Scaffold(
                body: new Form(
                  child: new FirebaseAnimatedList(
                    query: rosterDB,
                    sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
                    padding: constant.standard_margin,
                    itemBuilder: (_, DataSnapshot snapshot,
                        Animation<double> animation) {
                      return _newListEntry(snapshot);
                    },
                  ),
                ),
                floatingActionButton: new FloatingActionButton(
                  onPressed: null,
                  tooltip: 'Aggiungi', // used by assistive technologies
                  child: new Icon(Icons.add),
                ),
              ),
            ),
            new Expanded(
              child: new Scaffold(
                  body: new Center(
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    new Text("qui ci andranno i giocatori selezionati"),
                    new Text("qui ci andranno i giocatori selezionati"),
                    new Text("qui ci andranno i giocatori selezionati"),
                  ],
                ),
              )),
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

  Widget _newListEntry(DataSnapshot snapshot) {
    bool _titolare = false;
    return new Card(
      child: new Row(
        children: <Widget>[
          new Expanded(
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
          ),
          new Checkbox(value: _titolare, onChanged: (bool newValue) => setState(() => _titolare = newValue)),
        ],
      )
    );
  }
}
