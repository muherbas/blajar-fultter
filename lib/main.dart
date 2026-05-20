import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sf; // Diberi alias agar tidak bentrok
import 'package:fl_chart/fl_chart.dart'; // Library khusus untuk Radar Chart asli

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Grafika',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MenuUtamaPage(),
    );
  }
}

// ==========================================================
// HALAMAN MENU UTAMA (DASHBOARD)
// ==========================================================
class MenuUtamaPage extends StatelessWidget {
  const MenuUtamaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Utama'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol 1: Boxplot
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.bar_chart),
              label: const Text('Lihat Grafik Boxplot', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoxPlotPage(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Tombol 2: Radar Chart Asli
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.pie_chart_outline),
              label: const Text('Lihat Grafik Radar', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RadarChartPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// HALAMAN GRAFIK BOXPLOT (MENGGUNAKAN SYNCFUSION)
// ==========================================================
class BoxPlotPage extends StatefulWidget {
  const BoxPlotPage({super.key});

  @override
  State<BoxPlotPage> createState() => _BoxPlotPageState();
}

class _BoxPlotPageState extends State<BoxPlotPage> {
  late List<DataKategori> _dataNilai;

  @override
  void initState() {
    super.initState();
    _dataNilai = [
      DataKategori('Kelas A', [20, 55, 60, 62, 65, 68, 70, 72, 98]),
      DataKategori('Kelas B', [45, 48, 50, 53, 56, 58, 60, 62, 65]),
      DataKategori('Kelas C', [70, 72, 75, 78, 80, 83, 85, 88, 90]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Nilai - Boxplot Diagram'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: sf.SfCartesianChart(
                title: const sf.ChartTitle(text: 'Sebaran Nilai Ujian per Kelas'),
                legend: const sf.Legend(isVisible: true, position: sf.LegendPosition.bottom),
                primaryXAxis: const sf.CategoryAxis(majorGridLines: sf.MajorGridLines(width: 0)),
                primaryYAxis: const sf.NumericAxis(minimum: 0, maximum: 100, interval: 10),
                series: <sf.BoxAndWhiskerSeries<DataKategori, String>>[
                  sf.BoxAndWhiskerSeries<DataKategori, String>(
                    name: 'Rentang Nilai',
                    dataSource: _dataNilai,
                    xValueMapper: (DataKategori data, _) => data.namaKelas,
                    yValueMapper: (DataKategori data, _) => data.kumpulanNilai,
                    showMean: true,
                    boxPlotMode: sf.BoxPlotMode.normal,
                    color: Colors.blueAccent.withOpacity(0.7),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali ke Menu Utama'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// HALAMAN GRAFIK RADAR ASLI JARING LABA-LABA (fl_chart)
// ==========================================================
class RadarChartPage extends StatelessWidget {
  const RadarChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Fisik - Radar Chart Asli'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Perbandingan Biomotorik Siswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Indikator Legenda Manual
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicator(Colors.red, 'Siswa A'),
                const SizedBox(width: 15),
                _buildIndicator(Colors.green, 'Siswa B'),
                const SizedBox(width: 15),
                _buildIndicator(Colors.blue, 'Siswa C'),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              // Widget RadarChart Asli dari FL Chart
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.circle, // Bentuk lingkaran jaring laba-laba
                  dataSets: [
                    // Jaring Siswa A
                    RadarDataSet(
                      fillColor: Colors.red.withOpacity(0.2),
                      borderColor: Colors.red,
                      entryRadius: 3,
                      dataEntries: [
                        const RadarChartCell(value: 80), // Push Up
                        const RadarChartCell(value: 70), // Sit Up
                        const RadarChartCell(value: 85), // Back Up
                        const RadarChartCell(value: 60), // Pull Up
                        const RadarChartCell(value: 90), // Squat
                      ],
                    ),
                    // Jaring Siswa B
                    RadarDataSet(
                      fillColor: Colors.green.withOpacity(0.2),
                      borderColor: Colors.green,
                      entryRadius: 3,
                      dataEntries: [
                        const RadarChartCell(value: 60),
                        const RadarChartCell(value: 85),
                        const RadarChartCell(value: 70),
                        const RadarChartCell(value: 75),
                        const RadarChartCell(value: 65),
                      ],
                    ),
                    // Jaring Siswa C
                    RadarDataSet(
                      fillColor: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue,
                      entryRadius: 3,
                      dataEntries: [
                        const RadarChartCell(value: 90),
                        const RadarChartCell(value: 65),
                        const RadarChartCell(value: 75),
                        const RadarChartCell(value: 80),
                        const RadarChartCell(value: 85),
                      ],
                    ),
                  ],
                  // Judul latihan di setiap pojok jaring
                  getTitle: (index, angle) {
                    switch (index) {
                      case 0: return const RadarChartTitle(text: 'Push Up');
                      case 1: return const RadarChartTitle(text: 'Sit Up');
                      case 2: return const RadarChartTitle(text: 'Back Up');
                      case 3: return const RadarChartTitle(text: 'Pull Up');
                      case 4: return const RadarChartTitle(text: 'Squat');
                      default: return const RadarChartTitle(text: '');
                    }
                  },
                  tickCount: 5,
                  ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 1),
                  radarBorderData: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali ke Menu Utama'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// ==========================================================
// MODEL DATA
// ==========================================================
class DataKategori {
  DataKategori(this.namaKelas, this.kumpulanNilai);
  final String namaKelas;
  final List<num> kumpulanNilai;
}
