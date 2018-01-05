import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'setnote_widgets.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(constant.app_name)),
        body: new Center(
          child: new ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420.0),
            child: new ListView(
              shrinkWrap: true,
              padding: constant.standard_margin,
              children: <Widget>[
                new SetnoteButton(label: constant.match_label, onPressed: () => Navigator.of(context).pushNamed("/match")),
                new SetnoteButton(label: constant.team_label, onPressed: () => Navigator.of(context).pushNamed("/team")),
                new SetnoteButton(label: constant.stats_label, onPressed: () => Navigator.of(context).pushNamed("/stats")),
                new SetnoteButton(label: constant.history_label, onPressed: () => Navigator.of(context).pushNamed("/history")),
                new SetnoteButton(
                    label: constant.settings_label, onPressed: () => Navigator.of(context).pushNamed("/settings")),
              ],
            ),
          ),
        ));
  }
}