import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Atlet Syncfusion',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const SyncfusionDashboardPage(),
    );
  }
}

class SyncfusionDashboardPage extends StatelessWidget {
  const SyncfusionDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistik Atlet (Syncfusion)',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE3E7F1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // CARD 1: 7 GRAFIK BOXPLOT (KOMPONEN UTAMA)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1 Boxplot Atlet: Komponen Utama (7 Kategori)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: SfCartesianChart(
                      primaryXAxis: const CategoryAxis(),
                      primaryYAxis: const NumericAxis(minimum: 10, maximum: 100, interval: 20),
                      series: <CartesianSeries>[
                        BoxAndWhiskerSeries<BoxPlotData, String>(
                          dataSource: getBoxPlotData(),
                          xValueMapper: (BoxPlotData data, _) => data.x,
                          yValueMapper: (BoxPlotData data, _) => data.y,
                          boxPlotMode: BoxPlotMode.normal,
                          showMean: true,
                          color: const Color(0xFF4A90E2),
                          borderColor: Colors.black87,
                          borderWidth: 1.5,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 2: RADAR GAUGE DENGAN 10 PARAMETER BERLAPIS
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1 Radar Atlet: 10 Parameter Jarak/Durasi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 340,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        // Membuat 10 susunan parameter lingkaran bertingkat (luar ke dalam)
                        buildGaugeAxis(radiusFactor: 0.98, value: 85, color: Colors.orange, label: 'P1: 13M'),
                        buildGaugeAxis(radiusFactor: 0.90, value: 70, color: Colors.red, label: 'P2: 12M'),
                        buildGaugeAxis(radiusFactor: 0.82, value: 75, color: Colors.purple, label: 'P3: 11M'),
                        buildGaugeAxis(radiusFactor: 0.74, value: 90, color: Colors.blue, label: 'P4: 10M'),
                        buildGaugeAxis(radiusFactor: 0.66, value: 55, color: Colors.teal, label: 'P5: 9M'),
                        buildGaugeAxis(radiusFactor: 0.58, value: 65, color: Colors.green, label: 'P6: 8M'),
                        buildGaugeAxis(radiusFactor: 0.50, value: 40, color: Colors.amber, label: 'P7: 7M'),
                        buildGaugeAxis(radiusFactor: 0.42, value: 80, color: Colors.indigo, label: 'P8: 6M'),
                        buildGaugeAxis(radiusFactor: 0.34, value: 50, color: Colors.pink, label: 'P9: 5M'),
                        buildGaugeAxis(radiusFactor: 0.26, value: 35, color: Colors.cyan, label: 'P10: 4M'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembangun struktur Radial Axis untuk menumpuk Gauge
  RadialAxis buildGaugeAxis({
    required double radiusFactor, 
    required double value, 
    required Color color, 
    required String label
  }) {
    return RadialAxis(
      maximum: 100,
      showLabels: false,
      showTicks: false,
      startAngle: 270, 
      endAngle: 270,
      radiusFactor: radiusFactor,
      axisLineStyle: const AxisLineStyle(
        thickness: 7,
        color: Color(0xFFE0E0E0),
      ),
      pointers: <GaugePointer>[
        RangePointer(
          value: value,
          width: 7,
          color: color,
          pointerShape: PointerShape.rectangle,
          cornerStyle: CornerStyle.bothCurve,
        ),
      ],
      annotations: <GaugeAnnotation>[
        GaugeAnnotation(
          angle: 274,
          positionFactor: radiusFactor + 0.02,
          widget: Text(
            label,
            style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // Kumpulan data acak / dummy untuk 7 tipe Boxplot
  List<BoxPlotData> getBoxPlotData() {
    return [
      BoxPlotData('Gly', [20, 35, 45, 50, 65, 75, 85]),
      BoxPlotData('End', [25, 40, 50, 55, 60, 70, 90]),
      BoxPlotData('Spd', [30, 42, 48, 52, 65, 78, 88]),
      BoxPlotData('Coord', [15, 30, 40, 48, 58, 72, 80]),
      BoxPlotData('Flex', [40, 50, 55, 62, 70, 82, 95]),
      BoxPlotData('Bal', [35, 45, 58, 65, 72, 85, 98]),
      BoxPlotData('React', [22, 38, 44, 54, 63, 75, 86]),
    ];
  }
}

class BoxPlotData {
  BoxPlotData(this.x, this.y);
  final String x;
  final List<num> y;
}
