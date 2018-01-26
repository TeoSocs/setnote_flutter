import 'package:flutter/material.dart';

import 'constants.dart' as constant;

/// Elemento del drawer principale.
///
/// Voce del menù che riporta la scritta [label] e rimanda al route indicato
/// in [address].
class DrawerEntry extends StatelessWidget {
  final String label;
  final String address;

  DrawerEntry({this.label, this.address});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(label),
      onTap: () => Navigator.of(context).pushReplacementNamed(address),
    );
  }
}

/// Drawer principale.
///
/// Riprende gli elementi del menù principale e li presenta sotto forma di
/// drawer.
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: new Text(
              constant.app_name,
              style: Theme.of(context).primaryTextTheme.headline,
            ),
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
