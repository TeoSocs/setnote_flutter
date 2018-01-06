import 'package:flutter/material.dart';

import 'constants.dart' as constant;

class DrawerEntry extends StatelessWidget {
  DrawerEntry({this.label, this.address});
  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(label),
      onTap: () => Navigator.of(context).pushReplacementNamed(address),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: new Text(constant.app_name, style: Theme.of(context).primaryTextTheme.headline,),
          ),
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        new DrawerEntry(
          label: "Nuova partita",
          address: "/match",
        ),
        new DrawerEntry(
          label: "Gestione squadra",
          address: "/team",
        ),
        new DrawerEntry(
          label: "Statistiche squadra",
          address: "/stats",
        ),
        new DrawerEntry(
          label: "Archivio partite",
          address: "/history",
        ),
        new DrawerEntry(
          label: "Impostazioni",
          address: "/settings",
        ),
      ],
    );
  }
}
