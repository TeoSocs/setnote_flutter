import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Bar {
  Bar(this.height, this.color);

  factory Bar.empty() => new Bar(0.0, Colors.transparent);

  final double height;
  final Color color;

  static Bar lerp(Bar begin, Bar end, double t) {
    return new Bar(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
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

  static StackedBar lerp(StackedBar begin, StackedBar end, double t) {
    return new StackedBar(
      <Bar>[
        Bar.lerp(begin.bars[0], end.bars[0], t),
        Bar.lerp(begin.bars[1], end.bars[1], t),
        Bar.lerp(begin.bars[2], end.bars[2], t),
        Bar.lerp(begin.bars[3], end.bars[3], t),
      ],
    );
  }
}

class StackedBarTween extends Tween<StackedBar> {
  StackedBarTween(StackedBar begin, StackedBar end)
      : super(begin: begin, end: end);

  @override
  StackedBar lerp(double t) => StackedBar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  BarChartPainter(Animation<Bar> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<Bar> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final bar = animation.value;
    final paint = new Paint()
      ..color = bar.color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      new Rect.fromLTWH(
        0.0,
        size.height - bar.height,
        size.width,
        bar.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}

class StackedBarChartPainter extends CustomPainter {
  StackedBarChartPainter(Animation<StackedBar> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<StackedBar> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final stackedBar = animation.value;
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
