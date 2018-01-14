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
      title: "Team Downloader",
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
      if (int.parse(snapshot.value['ultimaModifica']) > int.parse(LocalDB.getByKey(snapshot.key).ultimaModifica)) {
        state = 'outdated';
      } else {
        state = 'updated';
      }
    } else {
      state = 'absent';
    }
    if ((snapshot.value['colore_maglia'] != null) &&
        (snapshot.value['colore_maglia'] != 'null')) {
      coloreMaglia = new Color(int
          .parse(snapshot.value['colore_maglia'].substring(8, 16), radix: 16));
    } else {
      coloreMaglia = Colors.blue[400];
    }
    return new Card(
        child: new FlatButton(
          onPressed: () async {
            setState(() => updated = false);
            // snapshot.value
          },
          child: new ListTile(
            leading: new Icon(
              Icons.android,
              color: coloreMaglia,
            ),
            title: new Text(snapshot.value['nome']),
            subtitle: new Text(
                snapshot.value['categoria'] + ' - ' + snapshot.value['stagione']),
            trailing: (state == 'absent'
            ? const Icon(Icons.cloud_off)
            : (state == 'updated'
                ? const Icon(Icons.cloud_done)
                : const Icon(Icons.cloud)
            ))
          )
        ));
  }

}
