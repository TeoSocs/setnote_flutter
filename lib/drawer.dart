import 'package:flutter/material.dart';

import 'google_auth.dart';

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
        (googleSignIn.currentUser != null
            ? new UserAccountsDrawerHeader(
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: new NetworkImage(googleSignIn.currentUser.photoUrl),
                ),
                accountName: new Text(googleSignIn.currentUser.displayName),
                accountEmail: new Text(googleSignIn.currentUser.email))
            : new UserAccountsDrawerHeader(
                accountName: new Text("Non sei ancora loggato"),
                accountEmail: new Text(""))),
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
