library flutter_radar_chart;

import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

const defaultGraphColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
];

class RadarChart extends StatefulWidget {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;

  const RadarChart({
    Key? key,
    required this.ticks,
    required this.features,
    required this.data,
    this.reverseAxis = false,
    this.ticksTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
    this.featuresTextStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.outlineColor = Colors.black,
    this.axisColor = Colors.grey,
    this.graphColors = defaultGraphColors,
    this.sides = 0, // Sudah default 0 aman
  }) : super(key: key);

  factory RadarChart.light({
    required List<int> ticks,
    required List<String> features,
    required List<List<num>> data,
    bool reverseAxis = false,
    bool useSides = false,
  }) {
    return RadarChart(
        ticks: ticks,
        features: features,
        data: data,
        reverseAxis: reverseAxis,
        sides: useSides ? features.length : 0);
  }

  factory RadarChart.dark({
    required List<int> ticks,
    required List<String> features,
    required List<List<num>> data,
    bool reverseAxis = false,
    bool useSides = false,
  }) {
    return RadarChart(
        ticks: ticks,
        features: features,
        data: data,
        featuresTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        outlineColor: Colors.white,
        axisColor: Colors.grey,
        reverseAxis: reverseAxis,
        sides: useSides ? features.length : 0);
  }

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        if (mounted) setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: RadarChartPainter(
        widget.ticks,
        widget.features,
        widget.data,
        widget.reverseAxis,
        widget.ticksTextStyle,
        widget.featuresTextStyle,
        widget.outlineColor,
        widget.axisColor,
        widget.graphColors,
        widget.sides,
        _animation.value,
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final double fraction;

  RadarChartPainter(
    this.ticks,
    this.features,
    this.data,
    this.reverseAxis,
    this.ticksTextStyle,
    this.featuresTextStyle,
    this.outlineColor,
    this.axisColor,
    this.graphColors,
    this.sides,
    this.fraction,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (features.isEmpty || ticks.isEmpty) return; // Pelindung jika data kosong

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY) * 0.8;

    final scale = radius / ticks.last;
    final angle = (2 * pi) / features.length;

    // Perbaikan null-safety aman untuk fontSize
    double baseFontSize = featuresTextStyle.fontSize ?? 16.0;
    var featuresTextStyleWithFraction = featuresTextStyle.copyWith(
        fontSize: baseFontSize * fraction);

    // Painting the ticks lines
    var tickPaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    ticks.asMap().forEach((index, tick) {
      var tickRadius = tick * scale;
      if (sides > 2) {
        var path = Path();
        for (var i = 0; i < sides; i++) {
          var xAngle = cos(angle * i - pi / 2);
          var yAngle = sin(angle * i - pi / 2);
          if (i == 0) {
            path.moveTo(centerX + tickRadius * xAngle, centerY + tickRadius * yAngle);
          } else {
            path.lineTo(centerX + tickRadius * xAngle, centerY + tickRadius * yAngle);
          }
        }
        path.close();
        canvas.drawPath(path, tickPaint);
      } else {
        canvas.drawCircle(Offset(centerX, centerY), tickRadius, tickPaint);
      }

      // Paint text ticks
      var textPainter = TextPainter(
        text: TextSpan(text: tick.toString(), style: ticksTextStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(centerX, centerY - tickRadius - textPainter.height));
    });

    // Painting the feature lines and texts
    var axisPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    features.asMap().forEach((index, feature) {
      var xAngle = cos(angle * index - pi / 2);
      var yAngle = sin(angle * index - pi / 2);

      var featureOffset = Offset(centerX + radius * xAngle, centerY + radius * yAngle);

      canvas.drawLine(Offset(centerX, centerY), featureOffset, axisPaint);

      var featureTextPainter = TextPainter(
        text: TextSpan(text: feature, style: featuresTextStyleWithFraction),
        textDirection: TextDirection.ltr,
      )..layout();

      var featureTextOffset = Offset(
          centerX + (radius + 15) * xAngle - featureTextPainter.width / 2,
          centerY + (radius + 15) * yAngle - featureTextPainter.height / 2);

      featureTextPainter.paint(canvas, featureTextOffset);
    });

    // Painting each graph
    data.asMap().forEach((index, graph) {
      if (graph.isEmpty) return; // Pelindung aman

      var graphPaint = Paint()
        ..color = graphColors[index % graphColors.length].withOpacity(0.3)
        ..style = PaintingStyle.fill;

      var graphOutlinePaint = Paint()
        ..color = graphColors[index % graphColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      var scaledPoint = scale * graph[0] * fraction;
      var path = Path();

      if (reverseAxis) {
        path.moveTo(centerX, centerY - (radius * fraction - scaledPoint));
      } else {
        path.moveTo(centerX, centerY - scaledPoint);
      }

      graph.asMap().forEach((index, point) {
        if (index == 0) return;

        var xAngle = cos(angle * index - pi / 2);
        var yAngle = sin(angle * index - pi / 2);
        var scaledPoint = scale * point * fraction;

        if (reverseAxis) {
          path.lineTo(centerX + (radius * fraction - scaledPoint) * xAngle,
              centerY + (radius * fraction - scaledPoint) * yAngle);
        } else {
          path.lineTo(
              centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
        }
      });

      path.close();
      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    });
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
