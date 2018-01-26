import 'package:setnote_flutter/local_team_list.dart';
import 'package:flutter/material.dart';
import 'package:setnote_flutter/setnote_widgets.dart';
import 'package:setnote_flutter/team_downloader.dart';
import 'package:setnote_flutter/constants.dart' as constant;
import 'package:setnote_flutter/manage_team.dart';

class MyTeamPage extends StatefulWidget {
  @override
  State createState() => new _MyTeamPageState();
}

class _MyTeamPageState extends State<MyTeamPage> {
  _MyTeamPageState() {
    LocalDB.readFromFile().then((x) => setState(() => reloadNeeded = false));
  }
  bool reloadNeeded = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> teamList = new List<Widget>();
    for (Map<String, dynamic> team in LocalDB.teams) {
      teamList.add(new Card(
        child: new FlatButton(
          onPressed: () async {
            reloadNeeded = true;
            await Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) =>
                    new ManageTeam(selectedTeam: team)));
            setState(() => reloadNeeded = false);
          },
          child: new ListTile(
            leading: new Icon(
              Icons.group,
              color: (team['colore_maglia'] != 'null' &&
                      team['colore_maglia'] != null
                  ? new Color(int.parse(team['colore_maglia'].substring(8, 16),
                      radix: 16))
                  : Theme.of(context).buttonColor),
            ),
            title: new Text(team['nome']),
            subtitle: new Text(team['categoria'] + ' - ' + team['stagione']),
          ),
        ),
      ));
    }
    teamList.add(new Card(
      elevation: 0.5,
      child: new FlatButton(
        onPressed: () async {
          reloadNeeded = true;
          Map<String, dynamic> team = new Map<String, dynamic>();
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new ManageTeam(selectedTeam: team)));
          setState(() => reloadNeeded = false);
        },
        child: new ListTile(
          leading: new Icon(Icons.add),
          title: const Text('Aggiungi una nuova squadra'),
        ),
      ),
    ));
    setState(() => reloadNeeded = false);
    return new SetnoteBaseLayout(
      title: 'Squadre salvate',
      child: new ListView(
        padding: constant.standard_margin,
        children: reloadNeeded ? [] : teamList,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          reloadNeeded = true;
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => new TeamDownloader()));
          setState(() => reloadNeeded = false);
        },
        child: const Icon(Icons.cloud),
      ),
    );
  }
}
