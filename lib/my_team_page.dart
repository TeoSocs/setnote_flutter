import 'local_team_list.dart' as local;
import 'package:flutter/material.dart';


class MyTeamPage extends StatefulWidget {
  @override
  State createState() => new _MyTeamPageState();
}

class _MyTeamPageState extends State<MyTeamPage> {
  bool reloadNeeded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> teamList = new List<Widget>();
    for (local.TeamInstance team in local.myTeams) {
      teamList.add(new Card(
        child: new ListTile(
          leading: const Icon(Icons.group),
          title: new Text(team.nomeSquadra),
          subtitle: new Text(team.categoria + ' - ' + team.stagione),
        ),
      ));
    }
    return new Scaffold(
      appBar: new AppBar(title: const Text('MyTeamPage'),),
      body: new ListView(
        children: reloadNeeded?[]:teamList,
      ),
    );
  }
}