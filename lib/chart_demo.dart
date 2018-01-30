import 'package:flutter/material.dart';

import 'charts/stat_chart.dart';
import 'setnote_widgets.dart';

class ChartDemo extends StatefulWidget {
  @override
  _ChartDemoState createState() => new _ChartDemoState();
}

class _ChartDemoState extends State<ChartDemo> {
  @override
  Widget build(BuildContext context) {
    return new SetnoteBaseLayout(
      child: new StatChart(),
      title: "Demo diagrammi",
    );
  }
}