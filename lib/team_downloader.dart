import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';
import 'package:setnote_flutter/google_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'constants.dart' as constant;
import 'local_team_list.dart';

class TeamDownloader extends StatefulWidget {
  @override
  State createState() => new _TeamDownloaderState();
}

class _TeamDownloaderState extends State<TeamDownloader> {
  bool logged = false;
  bool updated = true;

  @override
  Widget build(BuildContext context) {
    login();
    return new SetnoteBaseLayout(
      title: "Squadre nel cloud",
      child: new LoadingWidget(
        condition: logged && updated,
        child: new FirebaseAnimatedList(
          query: FirebaseDatabase.instance.reference().child('squadre'),
          sort: (a, b) => a.value['nome'].compareTo(b.value['nome']),
          padding: constant.standard_margin,
          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
            return _newListEntry(snapshot);
          },
        ),
      ),
    );
  }

  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => logged = true);
  }

  Widget _newListEntry(DataSnapshot snapshot) {
    Color coloreMaglia;
    String state;
    if (LocalDB.has(snapshot.key)) {
      int local = int.parse(LocalDB.getByKey(snapshot.key)['ultima_modifica']);
      int remote = int.parse(snapshot.value['ultima_modifica']);

      if (remote > local) {
        state = 'outdated';
      } else if (remote == local){
        state = 'updated';
      } else { // if remote < local
        state = 'ahead';
      }
    } else {
      state = 'absent';
    }
    if ((snapshot.value['colore_maglia'] != null) ||
        (snapshot.value['colore_maglia'] != 'null')) {
      coloreMaglia = new Color(int
          .parse(snapshot.value['colore_maglia'].substring(8, 16), radix: 16));
    } else {
      coloreMaglia = Colors.blue[400];
    }
    Icon cloudIcon;
    switch (state) {
      case 'outdated':
        cloudIcon = const Icon(Icons.cloud_download);
        break;
      case 'updated':
        cloudIcon = const Icon(Icons.cloud_done);
        break;
      case 'absent':
        cloudIcon = const Icon(Icons.cloud_off);
        break;
      case 'ahead':
        cloudIcon = const Icon(Icons.cloud_upload);
        break;
    }
    return new Card(
        child: new FlatButton(
            onPressed: () => _clickedTeam(state, snapshot),
            child: new ListTile(
                leading: new Icon(
                  Icons.group,
                  color: coloreMaglia,
                ),
                title: new Text(snapshot.value['nome']),
                subtitle: new Text(snapshot.value['categoria'] +
                    ' - ' +
                    snapshot.value['stagione']),
                trailing: cloudIcon)));
  }

  Future<Null> _clickedTeam(String state, DataSnapshot snapshot) async {
    setState(() => updated = false);
    switch (state) {
      case 'absent':
        Map<String, dynamic> newTeam = new Map<String, dynamic>();
        newTeam['ultima_modifica'] = snapshot.value['ultima_modifica'];
        newTeam['key'] = snapshot.key;
        newTeam['stagione'] = snapshot.value['stagione'];
        newTeam['categoria'] = snapshot.value['categoria'];
        newTeam['nome'] = snapshot.value['nome'];
        newTeam['colore_maglia'] = snapshot.value['colore_maglia'];
        newTeam['allenatore'] = snapshot.value['allenatore'];
        newTeam['assistente'] = snapshot.value['assistente'];
        // newTeam['giocatori'];
        LocalDB.add(newTeam);
        break;
      case 'outdated':
        bool agree = await showDialog<bool>(
          context: context,
          child: new AlertDialog(
            content: const Text('Questo sovrascriverà i dati locali di questa squadra, sei sicuro?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Annulla'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          )
        );
        if (agree) {
          Map<String,dynamic> team = LocalDB.getByKey(snapshot.key);
          team['ultima_modifica'] = snapshot.value['ultima_modifica'];
          team['key'] = snapshot.key;
          team['stagione'] = snapshot.value['stagione'];
          team['categoria'] = snapshot.value['categoria'];
          team['nome'] = snapshot.value['nome'];
          team['colore_maglia'] = snapshot.value['colore_maglia'];
          team['allenatore'] = snapshot.value['allenatore'];
          team['assistente'] = snapshot.value['assistente'];
          LocalDB.store();
        }
        break;
      case 'ahead':
        break;
      case 'updated':
        break;
    }
    Navigator.of(context).pop();
  }
}
