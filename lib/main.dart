import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sf; // Untuk Boxplot
import 'radar_chart.dart'; // Import lokal kustom kita

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
            
            // Tombol 2: Radar Chart Jaring Laba-Laba Lokal
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
    // Isian data wajib pakai .0 agar terbaca sebagai num desimal yang sah
    _dataNilai = [
      DataKategori('Kelas A', [20.0, 55.0, 60.0, 62.0, 65.0, 68.0, 70.0, 72.0, 98.0]),
      DataKategori('Kelas B', [45.0, 48.0, 50.0, 53.0, 56.0, 58.0, 60.0, 62.0, 65.0]),
      DataKategori('Kelas C', [70.0, 72.0, 75.0, 78.0, 80.0, 83.0, 85.0, 88.0, 90.0]),
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
                  sf.SfBoxAndWhiskerSeries<DataKategori, String>(
                    name: 'Rentang Nilai',
                    dataSource: _dataNilai,
                    xValueMapper: (DataKategori data, _) => data.namaKelas,
                    yValueMapper: (DataKategori data, _) => data.kumpulanNilai, // Klop dengan List<num>?
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
// HALAMAN GRAFIK RADAR ASLI (MENGGUNAKAN FILE LOKAL)
// ==========================================================
class RadarChartPage extends StatelessWidget {
  const RadarChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const namaLatihan = ['Push Up', 'Sit Up', 'Back Up', 'Pull Up', 'Squat'];
    const penandaNilai = [20, 40, 60, 80, 100];

    const dataFisikSiswa = [
      [80, 70, 85, 60, 90], 
      [60, 85, 70, 75, 65], 
      [90, 65, 75, 80, 85], 
    ];

    const warnaJaring = [Colors.red, Colors.green, Colors.blue];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Fisik - Radar Chart Lokal'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
            const SizedBox(height: 20),
            Expanded(
              child: RadarChart(
                ticks: penandaNilai,
                features: namaLatihan,
                data: dataFisikSiswa,
                graphColors: warnaJaring,
                outlineColor: Colors.grey,
                axisColor: Colors.grey.shade400,
                featuresTextStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
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
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ==========================================================
// MODEL DATA BOXPLOT (KEMBALI KE NUM YANG SAH)
// ==========================================================
class DataKategori {
  DataKategori(this.namaKelas, this.kumpulanNilai);
  final String namaKelas;
  final List<num> kumpulanNilai; // <--- Kembali ke num sesuai titah Syncfusion
}
