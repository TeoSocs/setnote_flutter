import 'local_team_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';
import 'team_downloader.dart';
import 'dart:async';

class MyTeamPage extends StatefulWidget {
  @override
  State createState() => new _MyTeamPageState();
}

class _MyTeamPageState extends State<MyTeamPage> {
  bool reloadNeeded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> teamList = new List<Widget>();
    for (TeamInstance team in LocalDB.teams) {
      teamList.add(new Card(
        child: new ListTile(
          leading: const Icon(Icons.group),
          title: new Text(team.nomeSquadra),
          subtitle: new Text(team.categoria + ' - ' + team.stagione),
        ),
      ));
    }
    return new SetnoteBaseLayout(
      title: 'MyTeamPage',
      child: new ListView(
        children: reloadNeeded ? [] : teamList,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          reloadNeeded = true;
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
              new TeamDownloader()));
          setState(() => reloadNeeded = false);
        },
        child: const Icon(Icons.cloud_download),
      ),
    );
  }
}
