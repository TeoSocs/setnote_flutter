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
    LocalDB.readFromFile();
  }
  bool reloadNeeded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> teamList = new List<Widget>();
    for (TeamInstance team in LocalDB.teams) {
      teamList.add(new Card(
        child: new FlatButton(
          onPressed: () async {
            reloadNeeded = true;
            await Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) => new ManageTeam(selectedTeam: team)));
            setState(() => reloadNeeded = false);
          },
          child: new ListTile(
            leading: new Icon(
              Icons.group,
              color: (team.coloreMaglia != 'null'
              ? new Color(
                  int.parse(team.coloreMaglia.substring(8, 16), radix: 16))
              : Theme.of(context).buttonColor),
            ),
            title: new Text(team.nome),
            subtitle: new Text(team.categoria + ' - ' + team.stagione),
          ),
        ),
      ));
    }
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
        child: const Icon(Icons.cloud_download),
      ),
    );
  }
}
