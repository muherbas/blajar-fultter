import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RadarChartPage(),
  ));
}

class RadarChartPage extends StatefulWidget {
  const RadarChartPage({super.key});

  @override
  State<RadarChartPage> createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage> {
  List<RadarData> radarData = [];
  bool isLoading = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchRadarData();
  }

  Future<void> fetchRadarData() async {
    try {
      // GANTI URL INI DENGAN API KAMU
      final response = await http.get(
        Uri.parse('https://api.example.com/stats'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List dataList = jsonData['data'];

        setState(() {
          radarData = dataList.map((e) => RadarData.fromJson(e)).toList();
          isLoading = false;
          errorMsg = '';
        });
      } else {
        throw Exception('Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        // Data dummy kalau API gagal
        radarData = [
          RadarData(label: 'Attack', value: 80),
          RadarData(label: 'Defense', value: 65),
          RadarData(label: 'Speed', value: 90),
          RadarData(label: 'Magic', value: 70),
          RadarData(label: 'Health', value: 85),
          RadarData(label: 'Luck', value: 50),
        ];
        isLoading = false;
        errorMsg = 'Gagal load API, pakai data dummy. Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radar Chart API')),
      body: RefreshIndicator(
        onRefresh: fetchRadarData,
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  if (errorMsg.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.orange.shade100,
                      child: Text(errorMsg, style: const TextStyle(color: Colors.orange)),
                    ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: RadarChartPainter(
                        data: radarData,
                        maxValue: 100,
                        strokeColor: Colors.blue,
                        fillColor: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLegend(),
                ],
              ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: radarData.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: Colors.blue),
            const SizedBox(width: 4),
            Text('${item.label}: ${item.value.toInt()}'),
          ],
        );
      }).toList(),
    );
  }
}

class RadarData {
  final String label;
  final double value;

  RadarData({required this.label, required this.value});

  factory RadarData.fromJson(Map<String, dynamic> json) {
    return RadarData(
      label: json['label'],
      value: (json['value'] as num).toDouble(),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<RadarData> data;
  final double maxValue;
  final Color strokeColor;
  final Color fillColor;
  final int ticks;

  RadarChartPainter({
    required this.data,
    required this.maxValue,
    required this.strokeColor,
    required this.fillColor,
    this.ticks = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 0.8;
    final angle = 2 * pi / data.length;

    final gridPaint = Paint()
    ..color = Colors.grey.shade300
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

    final axisPaint = Paint()
    ..color = Colors.grey.shade400
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

    final dataPaint = Paint()
    ..color = fillColor
    ..style = PaintingStyle.fill;

    final dataStrokePaint = Paint()
    ..color = strokeColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

    // 1. Grid
    for (int i = 1; i <= ticks; i++) {
      final r = radius * i / ticks;
      final path = Path();
      for (int j = 0; j < data.length; j++) {
        final x = center.dx + r * cos(angle * j - pi / 2);
        final y = center.dy + r * sin(angle * j - pi / 2);
        if (j == 0) path.moveTo(x, y); else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // 2. Sumbu + Label
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < data.length; i++) {
      final x = center.dx + radius * cos(angle * i - pi / 2);
      final y = center.dy + radius * sin(angle * i - pi / 2);
      canvas.drawLine(center, Offset(x, y), axisPaint);

      textPainter.text = TextSpan(
        text: data[i].label,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      );
      textPainter.layout();
      final labelOffset = Offset(
        center.dx + (radius + 16) * cos(angle * i - pi / 2) - textPainter.width / 2,
        center.dy + (radius + 16) * sin(angle * i - pi / 2) - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);
    }

    // 3. Data polygon
    final dataPath = Path();
    for (int i = 0; i < data.length; i++) {
      final valueRatio = (data[i].value / maxValue).clamp(0.0, 1.0);
      final x = center.dx + radius * valueRatio * cos(angle * i - pi / 2);
      final y = center.dy + radius * valueRatio * sin(angle * i - pi / 2);
      if (i == 0) dataPath.moveTo(x, y); else dataPath.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = strokeColor);
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, dataStrokePaint);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    return oldDelegate.data!= data || oldDelegate.maxValue!= maxValue;
  }
}