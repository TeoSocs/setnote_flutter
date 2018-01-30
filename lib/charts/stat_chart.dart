import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'bar.dart';

class StatChart extends StatefulWidget {
  final Map<String, String> dataSet;

  StatChart({this.dataSet});

  @override
  _StatChartState createState() => new _StatChartState(dataSet);
}

class _StatChartState extends State<StatChart> with TickerProviderStateMixin {
  final double barWidth = 20.0;
  final double height = 400.0;

  /*
  Mi aspetto un dataset formattato nel modo seguente:
  {
    battute: {
      errate,
      scarse,
      buone,
      ottime,
    },
    ricezioni: {
      errate,
      scarse,
      buone,
      ottime,
    },
    attacchi: {
      errate,
      scarse,
      buone,
      ottime,
    },
    difese: {
      errate,
      scarse,
      buone,
      ottime,
    },
  }
  */
  final Map<String, dynamic> dataSet;

  final colors = [
    Colors.red[400],
    Colors.yellow[400],
    Colors.green[400],
    Colors.blue[400]
  ];

  final fondamentali = ['battute', 'ricezioni', 'attacchi', 'difese'];

  final random = new Random();
  AnimationController animation;

  Map<String, StackedBarTween> tweens = new Map<String, StackedBarTween>();
  StackedBarTween tweenBattuta;
  StackedBarTween tweenRicezione;
  StackedBarTween tweenAttacco;
  StackedBarTween tweenDifesa;

  _StatChartState(this.dataSet);

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    final StackedBar empty = new StackedBar.empty();
    if (dataSet != null) {
      List<Bar> list = new List<Bar>();
      for (String fondamentale in fondamentali) {
        list.clear();
        for (int i = 0; i < dataSet[fondamentale].length; i++) {
          list.add(new Bar(double.parse([fondamentale][i]), colors[i]));
        }
        tweens[fondamentale] = new StackedBarTween(empty, new StackedBar(list));
      }
    } else {
      for (String fondamentale in fondamentali) {
        tweens[fondamentale] = new StackedBarTween(
            new StackedBar.empty(), new StackedBar.random(random));
      }
    }
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  Widget _newBar(String fondamentale) {
    String label;
    switch (fondamentale) {
      case "battute":
        label = "Battute";
        break;
      case "ricezioni":
        label = "Ricezioni";
        break;
      case "attacchi":
        label = "Attacchi";
        break;
      case "difese":
        label = "Difese";
        break;
    }
    return new Expanded(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new CustomPaint(
            size: new Size(barWidth, height),
            painter: new StackedBarChartPainter(tweens[fondamentale].animate(animation)),
          ),
          new Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _newBar('battute'),
          _newBar('ricezioni'),
          _newBar('attacchi'),
          _newBar('difese'),
        ],
      ),
    );
  }
}
