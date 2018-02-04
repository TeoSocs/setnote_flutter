import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../constants.dart' as constant;
import 'bar.dart';

class StatChart extends StatefulWidget {
  final Map<String, Map<String, double>> dataSet;
  final double scaleCoefficient;

  StatChart({this.dataSet, this.scaleCoefficient});
  @override
  _StatChartState createState() =>
      new _StatChartState(dataSet, scaleCoefficient: scaleCoefficient);
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

  final Map<String, Color> _colors = {
    'Ottimo': Colors.blue[400],
    'Buono': Colors.green[400],
    'Scarso': Colors.yellow[400],
    'Errato': Colors.red[400],
  };

  final random = new Random();
  AnimationController animation;

  Map<String, StackedBar> stackedBars = new Map<String, StackedBar>();

  double scaleCoefficient;

  _StatChartState(this.dataSet, {this.scaleCoefficient});

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (dataSet != null) {
      List<Bar> list = new List<Bar>();
      for (String fondamentale in constant.fondamentali) {
        list = new List<Bar>();
        for (String esito in constant.esiti) {
          list.add(new Bar(
              dataSet[fondamentale][esito] * scaleCoefficient, _colors[esito]));
        }
        stackedBars[fondamentale] =
            new StackedBar(list);
      }
    } else {
      for (String fondamentale in constant.fondamentali) {
        stackedBars[fondamentale] = new StackedBar.random(random);
      }
    }
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  Widget _newBar(String fondamentale) {
    return new Expanded(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new CustomPaint(
            size: new Size(barWidth, height),
            painter: new StackedBarChartPainter(
                stackedBars[fondamentale]),
          ),
          new Text(fondamentale),
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
          _newBar('Battuta'),
          _newBar('Ricezione'),
          _newBar('Attacco'),
          _newBar('Difesa'),
        ],
      ),
    );
  }
}
