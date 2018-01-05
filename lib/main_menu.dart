import 'package:flutter/material.dart';

import 'constants.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Setnote")),
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            new MenuButton(label: match_label, address: "/match"),
            new MenuButton(label: team_label, address: "/team"),
            new MenuButton(label: stats_label, address: "/stats"),
            new MenuButton(label: history_label, address: "/history"),
            new MenuButton(label: settings_label, address: "/settings"),
          ],
        ));
  }
}

class MenuButton extends StatelessWidget {
  MenuButton({this.label, this.address});
  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new RaisedButton(
        child: new Padding(
            padding: new EdgeInsets.all(10.0), child: new Text(label)),
        onPressed: () => Navigator.of(context).pushNamed(address),
      ),
    );
  }
}
