import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

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
        child: new Scaffold(
          body: new FirebaseAnimatedList(
            query: constant.teamDB,
            sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
            padding: constant.standard_margin,
            itemBuilder:
                (_, DataSnapshot snapshot, Animation<double> animation) {
              return new TeamListEntry(
                snapshot: snapshot,
              );
            },
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              constant.selectedTeam.clear();
              Navigator.of(context).pushNamed("/manage_team");
            },
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
}

class TeamListEntry extends StatelessWidget {
  TeamListEntry({this.snapshot});
  final DataSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new FlatButton(
          onPressed: () {
            constant.selectedTeam.key = snapshot.key;
            constant.selectedTeam.nomeSquadra = snapshot.value['nome'];
            constant.selectedTeam.allenatore = snapshot.value['allenatore'];
            constant.selectedTeam.assistente = snapshot.value['assistente'];
            constant.selectedTeam.categoria = snapshot.value['stagione'];
            constant.selectedTeam.stagione = snapshot.value['categoria'];
            constant.selectedTeam.coloreMaglia = new Color(int.parse(snapshot.value['colore_maglia'].substring(8,16), radix: 16));
            Navigator.of(context).pushNamed("/manage_team");
          },
      child: new ListTile(
            leading: new Icon(Icons.android, color: new Color(int.parse(snapshot.value['colore_maglia'].substring(8,16), radix: 16)),),
        title: new Text(snapshot.value['nome']),
        subtitle: new Text(
            snapshot.value['categoria'] + ' - ' + snapshot.value['stagione']),
      ),
    ));
  }
}

