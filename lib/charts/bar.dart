import 'dart:math';

import 'package:flutter/material.dart';

class Bar {
  Bar(this.height, this.color);

  factory Bar.empty() => new Bar(0.0, Colors.transparent);

  final double height;
  final Color color;

}


class StackedBar {
  StackedBar(this.bars);

  factory StackedBar.empty() => new StackedBar(<Bar>[
        new Bar.empty(),
        new Bar.empty(),
        new Bar.empty(),
        new Bar.empty(),
      ]);

  factory StackedBar.random(Random random) {
    return new StackedBar(
    <Bar>[
      new Bar(random.nextDouble() * 100.0, Colors.red[400]),
      new Bar(random.nextDouble() * 100.0, Colors.yellow[400]),
      new Bar(random.nextDouble() * 100.0, Colors.green[400]),
      new Bar(random.nextDouble() * 100.0, Colors.blue[400]),
    ]);
  }
  
  final List<Bar> bars;

}


class StackedBarChartPainter extends CustomPainter {
  StackedBarChartPainter(this.stackedBar);
  final StackedBar stackedBar;

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = new Paint()..style = PaintingStyle.fill;
    final linePaint = new Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 1.0;
    final linePath = new Path();
    var y = size.height;
    for (final bar in stackedBar.bars) {
      barPaint.color = bar.color;
      canvas.drawRect(
        new Rect.fromLTWH(
          0.0,
          y - bar.height,
          size.width,
          bar.height,
        ),
        barPaint,
      );
      if (y < size.height) {
        linePath.moveTo(0.0, y);
        linePath.lineTo(0.0 + size.width, y);
      }
      y -= bar.height;
    }
    canvas.drawPath(linePath, linePaint);
    linePath.reset();
  }

  @override
  bool shouldRepaint(StackedBarChartPainter old) => false;
}
