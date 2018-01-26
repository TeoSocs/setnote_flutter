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

/// Pagina di gestione della formazione di un team.
///
/// [team] è la squadra che si sta modificando e viene passata da costruttore.
/// [logged] è una variabile ausiliaria che permette di mostrare
/// un'indicatore di caricamento in attesa che sia verificato il login
/// dell'utente. [rosterDB] mantiene un riferimento al database in cui si
/// trovano i giocatori della squadra.
class _RosterManagerState extends State<RosterManager> {
  Map<String, dynamic> team;
  bool logged = false;
  DatabaseReference rosterDB;

  /// Costruttore di _RosterManagerState.
  ///
  /// Riceve in input [team] e recupera da Firebase il riferimento [rosterDB].
  _RosterManagerState({this.team}) {
    rosterDB = FirebaseDatabase.instance
        .reference()
        .child('squadre/' + team['key'] + '/giocatori');
  }

  @override
  Widget build(BuildContext context) {
    login();
    MediaQueryData media = MediaQuery.of(context);
    return new SetnoteBaseLayout(
      title: (media.orientation == Orientation.landscape &&
              media.size.width >= 950.00
          ? "Gestisci formazione"
          : team['nome']),
      drawer: _newRosterManagerDrawer(),
      child: new LoadingWidget(
        condition: logged,
        child: _newRosterFirebaseAnimatedList(),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Aggiungi', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: null,
      ),
    );
  }

  /// Costruisce il drawer per RosterManager
  Drawer _newRosterManagerDrawer() {
    return new Drawer(
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
    );
  }

  /// Costruisce la FirebaseAnimatedList legata a [rosterDB].
  FirebaseAnimatedList _newRosterFirebaseAnimatedList() {
    return new FirebaseAnimatedList(
      query: rosterDB,
      sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
      padding: constant.standard_margin,
      itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
        return _newListEntry(snapshot);
      },
    );
  }

  /// Costruisce la card che presenta ciascun giocatore recuperato dal DB.
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

  /// Controlla il login dell'utente e setta la variabile [logged] di
  /// conseguenza.
  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => logged = true);
  }
}
