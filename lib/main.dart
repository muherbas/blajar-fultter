import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Untuk Boxplot atas
import 'package:syncfusion_flutter_gauges/gauges.dart';  // Untuk Gauge interaktif bawah

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
  Widget build(BuildContext context) {
    return const DashboardAtletView();
  }
}

class DashboardAtletView extends StatefulWidget {
  const DashboardAtletView({super.key});

  @override
  State<DashboardAtletView> createState() => _DashboardAtletViewState();
}

// Model data untuk Box and Whisker (Boxplot) 7 Parameter Utama
class BoxPlotData {
  final String x;
  final List<num> y;
  BoxPlotData(this.x, this.y);
}

class _DashboardAtletViewState extends State<DashboardAtletView> {
  String parameterTurunanTerpilih = "MUSCULAR ENDURANCE"; // Default terpilih awal

  // Data 10 Parameter Komponen Turunan Murid (Sistem Key-Value Map)
  final Map<String, double> komponenTurunan = {
    "MUSCULAR ENDURANCE": 78,
    "POWER": 82,
    "CORE STABILITY": 70,
    "DYNAMIC FLEXIBILITY": 65,
    "SPEED ENDURANCE": 75,
    "REACTIVE SPEED": 60,
    "AGILITY": 88,
    "ANTICIPATION & SPATIAL AWARENESS": 80,
    "MOBILITY": 72,
    "OPEN REACTIVE AGILITY": 67,
  };

  // Fungsi menghitung rata-rata total untuk baseline jarum pembanding
  double get rataRataTurunan {
    double total = komponenTurunan.values.fold(0, (sum, item) => sum + item);
    return total / komponenTurunan.length;
  }

  @override
  Widget build(BuildContext context) {
    // Data sebaran nilai 20 murid untuk 7 Parameter Utama (Format: [Min, Q1, Median, Q3, Max])
    final List<BoxPlotData> dataBoxPlot = [
      BoxPlotData('STRENGTH', [45, 60, 75, 82, 95]),
      BoxPlotData('ENDURANCE', [50, 58, 68, 78, 92]),
      BoxPlotData('SPEED', [40, 52, 65, 74, 88]),
      BoxPlotData('COORD', [55, 65, 72, 85, 96]),
      BoxPlotData('FLEX', [35, 48, 60, 72, 85]),
      BoxPlotData('BALANCE', [60, 68, 76, 88, 98]),
      BoxPlotData('REACTION', [42, 50, 63, 75, 90]),
    ];

    double nilaiGaugeAktif = komponenTurunan[parameterTurunanTerpilih] ?? 0;

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
            // GRAFIK 1: BOXPLOT 7 PARAMETER (KOMPONEN UTAMA)
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
                      height: 220,
                      child: SfCartesianChart(
                        primaryXAxis: const CategoryAxis(
                          majorGridLines: MajorGridLines(width: 0),
                          labelStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
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
                            fillColor: Colors.blueAccent.withOpacity(0.6),
                            strokeColor: Colors.blue.shade900,
                            strokeWidth: 1.5,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Nilai Rata-Rata Keseluruhan Murid", style: TextStyle(fontSize: 9, color: Colors.black54)),
                            Text("68.5", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
            // GRAFIK 2: RADIAL GAUGE INTERAKTIF (10 PARAMETER TURUNAN)
            // ========================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "1 Radar Atlet: Komponen Turunan",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'Avg: ${rataRataTurunan.toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),

                    // RADIAL GAUGE ASLI DENGAN RANGE POINTER & NEEDLE POINTER
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 160,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  showLabels: false,
                                  showTicks: false,
                                  startAngle: 270,
                                  endAngle: 270,
                                  radiusFactor: 0.95,
                                  axisLineStyle: AxisLineStyle(thickness: 18, color: Colors.orange.shade100),
                                  pointers: <GaugePointer>[
                                    // 1. Batang Melingkar Skor Aktif Parameter Terpilih
                                    RangePointer(
                                      value: nilaiGaugeAktif,
