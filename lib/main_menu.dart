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
            children: _menuBuilder(context, media),
          ),
        ),
      ),
    );
  }

  List<Widget> _menuBuilder(BuildContext context, MediaQueryData media) {
    List<Widget> list = new List<Widget>();
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      list.add(new Card(
        child: new FlatButton(
            child: new ListTile(
              leading: const Icon(Icons.add),
              title: const Text(constant.match_label),
            ),
            onPressed: () => Navigator.of(context).pushNamed("/match")),
      ));
      list.add(
        new Card(
          child: new FlatButton(
              child: new ListTile(
                leading: const Icon(Icons.folder),
                title: const Text(constant.history_label),
              ),
              onPressed: () => Navigator.of(context).pushNamed("/history")),
        ),
      );
    }
    list.add(
      new Card(
        child: new FlatButton(
            child: new ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text(constant.team_label),
            ),
            onPressed: () => Navigator.of(context).pushNamed("/team")),
      ),
    );
    list.add(
      new Card(
        child: new FlatButton(
            child: new ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text(constant.stats_label),
            ),
            onPressed: () => Navigator.of(context).pushNamed("/stats")),
      ),
    );
    return list;
  }
}
