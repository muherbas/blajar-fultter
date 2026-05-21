import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DashboardAtlet(),
    );
  }
}

class DashboardAtlet extends StatefulWidget {
  const DashboardAtlet({super.key});

  @override
  State<DashboardAtlet> createState() => _DashboardAtletState();
}

// Model data untuk Box and Whisker (Boxplot)
class BoxPlotData {
  final String x;
  final List<num> y;
  BoxPlotData(this.x, this.y);
}

// Model data untuk Radial Bar Chart
class RadialData {
  final String x;
  final num y;
  final Color color;
  RadialData(this.x, this.y, this.color);
}

class _DashboardAtletState extends State<DashboardAtlet> {
  @override
  Widget build(BuildContext context) {
    // 1. Data Dummy Boxplot sebaran nilai 20 murid (Min, Q1, Median, Q3, Max)
    final List<BoxPlotData> dataBoxPlot = [
      BoxPlotData('Gly', [40, 55, 68, 80, 92]),
      BoxPlotData('End', [30, 48, 62, 75, 90]),
      BoxPlotData('Spd', [35, 50, 65, 78, 88]),
      BoxPlotData('Coord', [45, 60, 72, 82, 95]),
      BoxPlotData('Flex', [42, 58, 70, 84, 93]),
      BoxPlotData('Bal', [50, 65, 76, 88, 98]),
      BoxPlotData('React', [32, 46, 60, 72, 85]),
    ];

    // 2. Data Dummy Radial Bar untuk komponen turunan melingkar berlapis
    final List<RadialData> dataRadial = [
      RadialData('M.Endur', 85, Colors.orange),
      RadialData('Power', 78, Colors.red.shade700),
      RadialData('Core', 70, Colors.blue.shade700),
      RadialData('Dyn.Flex', 62, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik Ruri", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ========================================================
            // GRAFIK 1: BOXPLOT ATLET (KOMPONEN UTAMA)
            // ========================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "1 Boxplot Atlet: Komponen Utama",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 260,
                      child: SfCartesianChart(
                        primaryXAxis: const CategoryAxis(
                          majorGridLines: MajorGridLines(width: 0),
                          labelStyle: TextStyle(fontSize: 10),
                        ),
                        primaryYAxis: const NumericAxis(
                          minimum: 0,
                          maximum: 100,
                          interval: 20,
                          majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey),
                        ),
                        plotAreaBorderWidth: 0,
                        series: <CartesianSeries<BoxPlotData, String>>[
                          BoxAndWhiskerSeries<BoxPlotData, String>(
                            dataSource: dataBoxPlot,
                            xValueMapper: (BoxPlotData data, _) => data.x,
                            yValueMapper: (BoxPlotData data, _) => data.y,
                            boxPlotMode: BoxPlotMode.normal,
                            showMean: true,
                            fillColor: Colors.blueAccent.withOpacity(0.7),
                            strokeColor: Colors.blue.shade900,
                            strokeWidth: 1.5,
                          )
                        ],
                      ),
                    ),
                    // Rata-rata card di pojok bawah kanan sesuai gambar
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.プリント(color: Colors.grey.shade200, width: 1) ?? Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Nilai Rata-Rata Keseluruhan Murid", style: TextStyle(fontSize: 9, color: Colors.black54)),
                            Text("68.5", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ========================================================
            // GRAFIK 2: RADAR / RADIAL BAR ATLET (KOMPONEN TURUNAN)
            // ========================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "1 Radar Atlet: Komponen Turunan",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                        Text("Avg: 73.7", style: TextStyle(fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text(
                        "Shot put distance",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Menggunakan RadialBarSeries berlapis melingkar seperti gambar target
                    SizedBox(
                      height: 240,
                      child: SfCircularChart(
                        key: UniqueKey(),
                        series: <CircularSeries<RadialData, String>>[
                          RadialBarSeries<RadialData, String>(
                            dataSource: dataRadial,
                            xValueMapper: (RadialData data, _) => data.x,
                            yValueMapper: (RadialData data, _) => data.y,
                            pointColorMapper: (RadialData data, _) => data.color,
                            maximumValue: 100,
                            radius: '90%',
                            innerRadius: '35%',
                            gap: '8%',
                            cornerStyle: CornerStyle.bothCurve,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: false,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}