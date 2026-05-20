import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
            
            // Tombol 2: Grafik Fisik Siswa (Bar Chart Aman)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.equalizer),
              label: const Text('Lihat Analisis Fisik', style: TextStyle(fontSize: 18)),
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
// HALAMAN GRAFIK BOXPLOT
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
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Sebaran Nilai Ujian per Kelas'),
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: const CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
                primaryYAxis: const NumericAxis(minimum: 0, maximum: 100, interval: 10),
                series: <BoxAndWhiskerSeries<DataKategori, String>>[
                  BoxAndWhiskerSeries<DataKategori, String>(
                    name: 'Rentang Nilai',
                    dataSource: _dataNilai,
                    xValueMapper: (DataKategori data, _) => data.namaKelas,
                    yValueMapper: (DataKategori data, _) => data.kumpulanNilai,
                    showMean: true,
                    boxPlotMode: BoxPlotMode.normal,
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
// HALAMAN GRAFIK ANALISIS FISIK (BAR CHART - 100% AMAN PABRIK)
// ==========================================================
class RadarChartPage extends StatefulWidget {
  const RadarChartPage({super.key});

  @override
  State<RadarChartPage> createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage> {
  late List<DataRadar> _dataFisik;

  @override
  void initState() {
    super.initState();
    _dataFisik = [
      DataRadar('Push Up', 80.0, 60.0, 90.0),
      DataRadar('Sit Up', 70.0, 85.0, 65.0),
      DataRadar('Back Up', 85.0, 70.0, 75.0),
      DataRadar('Pull Up', 60.0, 75.0, 80.0),
      DataRadar('Squat', 90.0, 65.0, 85.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Fisik Siswa'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              // Pakai Cartesian standar tanpa aneh-aneh agar lulus sensor GitHub
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Perbandingan Kemampuan Biomotorik'),
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: const NumericAxis(minimum: 0, maximum: 100, interval: 20),
