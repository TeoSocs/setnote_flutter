import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/manage_team_model.dart';
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
              selectedTeam.clear();
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
  TeamListEntry({this.snapshot}) {
    if (snapshot.value['colore_maglia'] != null) {
      coloreMaglia = new Color(int.parse(snapshot.value['colore_maglia'].substring(8,16), radix: 16));
    } else {
      coloreMaglia = Colors.green[400];
    }
  }
  Color coloreMaglia;
  final DataSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new FlatButton(
          onPressed: () {
            selectedTeam.key = snapshot.key;
            selectedTeam.nomeSquadra = snapshot.value['nome'];
            selectedTeam.allenatore = snapshot.value['allenatore'];
            selectedTeam.assistente = snapshot.value['assistente'];
            selectedTeam.categoria = snapshot.value['stagione'];
            selectedTeam.stagione = snapshot.value['categoria'];
            selectedTeam.coloreMaglia = coloreMaglia;
            Navigator.of(context).pushNamed("/manage_team");
          },
      child: new ListTile(
            leading: new Icon(Icons.android, color: coloreMaglia,),
        title: new Text(snapshot.value['nome']),
        subtitle: new Text(
            snapshot.value['categoria'] + ' - ' + snapshot.value['stagione']),
      ),
    ));
  }
}

