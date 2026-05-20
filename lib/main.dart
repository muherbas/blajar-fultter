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
            
            // Tombol 2: Radar Chart (Wujud Modifikasi)
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
// HALAMAN GRAFIK RADAR (MODIFIKASI AMAN DARI CARTESIAN)
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
    // Kita tambahkan "Push Up" lagi di akhir data agar ujung garisnya menutup melingkar sempurna
    _dataFisik = [
      DataRadar('Push Up', 80.0, 60.0, 90.0),
      DataRadar('Sit Up', 70.0, 85.0, 65.0),
      DataRadar('Back Up', 85.0, 70.0, 75.0),
      DataRadar('Pull Up', 60.0, 75.0, 80.0),
      DataRadar('Squat', 90.0, 65.0, 85.0),
      DataRadar('Push Up ', 80.0, 60.0, 90.0), // Spasi di nama agar terbaca titik penutup
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Fisik - Radar Modifikasi'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              // Trik Utama: Menggunakan SfCartesianChart bawaan dasar, tapi sumbunya kita bikin melingkar
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Perbandingan Biomotorik Siswa'),
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                
                // Mengubah tipe grid menjadi polygon (segi lima jaring laba-laba)
                primaryXAxis: const CategoryAxis(
                  gridLineType: GridLineType.polygon,
                  majorGridLines: MajorGridLines(width: 1),
                ),
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                  gridLineType: GridLineType.polygon,
                  majorGridLines: MajorGridLines(width: 1),
                ),
                
                series: <CartesianSeries<DataRadar, String>>[
                  // Siswa A diubah jadi LineSeries tapi memutar
                  LineSeries<DataRadar, String>(
                    name: 'Siswa A',
                    dataSource: _dataFisik,
                    xValueMapper: (DataRadar data, _) => data.jenisLatihan,
                    yValueMapper: (DataRadar data, _) => data.nilaiSiswaA,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.red,
                    width: 2,
                  ),
                  // Siswa B
                  LineSeries<DataRadar, String>(
                    name: 'Siswa B',
                    dataSource: _dataFisik,
                    xValueMapper: (DataRadar data, _) => data.jenisLatihan,
                    yValueMapper: (DataRadar data, _) => data.nilaiSiswaB,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.green,
                    width: 2,
                  ),
                  // Siswa C
                  LineSeries<DataRadar, String>(
                    name: 'Siswa C',
                    dataSource: _dataFisik,
                    xValueMapper: (DataRadar data, _) => data.jenisLatihan,
                    yValueMapper: (DataRadar data, _) => data.nilaiSiswaC,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.blue,
                    width: 2,
                  ),
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
// MODEL DATA
// ==========================================================
class DataKategori {
  DataKategori(this.namaKelas, this.kumpulanNilai);
  final String namaKelas;
  final List<num> kumpulanNilai;
}

class DataRadar {
  DataRadar(this.jenisLatihan, this.nilaiSiswaA, this.nilaiSiswaB, this.nilaiSiswaC);
  final String jenisLatihan;
  final double nilaiSiswaA;
  final double nilaiSiswaB;
  final double nilaiSiswaC;
}
