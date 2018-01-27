import 'package:flutter/material.dart';

import 'constants.dart' as constant;

/// Costruisce il menù principale
class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return new Scaffold(
      appBar: new AppBar(title: new Text(constant.app_name)),
      body: new Center(
        child: new ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420.0),
          child: new ListView(
            shrinkWrap: media.orientation == Orientation.landscape &&
                media.size.width >= 950.00,
            children: <Widget>[
              new Card(
                child: new FlatButton(
                    child: new ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text(constant.match_label),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed("/match")),
              ),
              new Card(
                child: new FlatButton(
                    child: new ListTile(
                      leading: const Icon(Icons.contacts),
                      title: const Text(constant.team_label),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed("/team")),
              ),
              new Card(
                child: new FlatButton(
                    child: new ListTile(
                      leading: const Icon(Icons.assessment),
                      title: const Text(constant.stats_label),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed("/stats")),
              ),
              new Card(
                child: new FlatButton(
                    child: new ListTile(
                      leading: const Icon(Icons.folder),
                      title: const Text(constant.history_label),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/history")),
              ),
              new Card(
                child: new FlatButton(
                    child: new ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text(constant.settings_label),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/settings")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
