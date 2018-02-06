import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'help.dart';

/// Drawer principale.
///
/// Riprende gli elementi del menù principale e li presenta sotto forma di
/// drawer.
class MyDrawer extends StatelessWidget {
  const MyDrawer();

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: new FlatButton(
              onPressed: () =>
                  Navigator.of(context).popUntil(ModalRoute.withName('/')),
              child: new Text(
                constant.app_name,
                style: Theme.of(context).primaryTextTheme.headline,
              ),
            ),
          ),
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        new ListTile(
          title: new Text("Nuova partita"),
          leading: const Icon(Icons.add),
          onTap: () => Navigator.of(context).pushReplacementNamed("/match"),
        ),
        new ListTile(
          leading: const Icon(Icons.folder),
          title: const Text("Archivio partite"),
          onTap: () => Navigator.of(context).pushReplacementNamed("/history"),
        ),
        new ListTile(
          leading: const Icon(Icons.contacts),
          title: const Text("Gestione squadra"),
          onTap: () => Navigator.of(context).pushReplacementNamed("/team"),
        ),
        new ListTile(
          leading: const Icon(Icons.assessment),
          title: const Text("Statistiche squadra"),
          onTap: () => Navigator.of(context).pushReplacementNamed("/stats"),
        ),
        const Divider(),
        new ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text("Manuale"),
          onTap: () => showDialog<bool>(
            context: context,
            child: new HelpDialog(),
          ),
        ),
      ],
    );
  }
}
