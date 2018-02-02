import 'package:flutter/material.dart';

import 'setnote_widgets.dart';

class MatchStats extends StatefulWidget {
  MatchStats(this.match);

  Map<String, dynamic> match;

  @override
  State createState() => new _MatchStatsState(match);
}

class _MatchStatsState extends State<MatchStats> {
  _MatchStatsState(this.match);

  Map<String, dynamic> match;

  @override
  Widget build(BuildContext context) {
    return new SetnoteBaseLayout(

    );
  }
}