import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Memanggil berkas overlay yang sudah kita pisah tadi
import 'splash_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Boxplot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Layar pertama aplikasi langsung dibungkus MemuatHalaman agar loading 6 detik bekerja
      home: const MemuatHalaman(
        halamanTujuan: MenuUtamaPage(),
      ),
    );
  }
}

// ==========================================================
// HALAMAN MENU UTAMA
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
          // Tombol 1: Untuk membuka Boxplot (Tombol lama Anda)
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
                  builder: (context) => const MemuatHalaman(
                    halamanTujuan: BoxPlotPage(),
                    pesanLoading: 'Menyiapkan Grafik Boxplot...',
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20), // Jarak aman antar tombol biar tidak nempel
          
          // Tombol 2: Untuk membuka Radar Chart (Tombol Baru)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.pie_chart_outlined),
            label: const Text('Lihat Grafik Radar', style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemuatHalaman(
                    halamanTujuan: RadarChartPage(),
                    pesanLoading: 'Menghitung Jaring Radar...',
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
      ), // Di sini tanda kurung dan koma sudah dikoreksi total!
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemuatHalaman(
                      halamanTujuan: MenuUtamaPage(),
                      pesanLoading: 'Kembali ke Dashboard...',
                    ),
                  ),
                );
              },
              child: const Text('Kembali ke Menu Utama'),
            ),
          ],
        ),
      ),
    );
  }
}

class DataKategori {
  DataKategori(this.namaKelas, this.kumpulanNilai);
  final String namaKelas;
  final List<num> kumpulanNilai;
}

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
    // Isi data sampel nilai fisik biomotorik untuk 3 siswa
    _dataFisik = [
      DataRadar('Push Up', 80, 60, 90),
      DataRadar('Sit Up', 70, 85, 65),
      DataRadar('Back Up', 85, 70, 75),
      DataRadar('Pull Up', 60, 75, 80),
      DataRadar('Squat', 90, 65, 85),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Fisik - Radar Chart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              // SfradarChart adalah komponen utama pembuat jaring laba-laba
              child: SfRadarChart(
                title: const ChartTitle(text: 'Perbandingan Biomotorik Siswa'),
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                
                // Mengatur garis melingkar pembatas nilai (0 - 100)
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                ),
                
                // Menaruh garis jaring untuk masing-masing siswa
                series: <RadarSeries<DataRadar, String>>[
                  // Jaring Siswa A (Warna Merah transparan)
                  RadarSeries<DataRadar, String>(
                    name: 'Siswa A',
                    dataSource: _dataFisik,
                    xValueMapper: (DataRadar data, _) => data.jenisLatihan,
                    yValueMapper: (DataRadar data, _) => data.nilaiSiswaA,
                    color: Colors.red.withOpacity(0.3),
                    borderColor: Colors.red,
                    borderWidth: 2,
                  ),
                  // Jaring Siswa B (Warna Hijau transparan)
                  RadarSeries<DataRadar, String>(
                    name: 'Siswa B',
                    dataSource: _dataFisik,
                    xValueMapper: (DataRadar data, _) => data.jenisLatihan,
                    yValueMapper: (DataRadar data, _) => data.nilaiSiswaB,
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.green,
                    borderWidth: 2,
                  ),
                  // Jaring Siswa C (Warna Biru transparan)
                  RadarSeries<DataRadar, String>(
                    name: 'Siswa C',
                    dataSource: _dataFisik,
                    xValueMapper: (DataRadar data, _) => data.jenisLatihan,
                    yValueMapper: (DataRadar data, _) => data.nilaiSiswaC,
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderWidth: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tombol kembali ke dashboard utama
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemuatHalaman(
                      halamanTujuan: MenuUtamaPage(),
                      pesanLoading: 'Kembali ke Dashboard...',
                    ),
                  ),
                );
              },
              child: const Text('Kembali ke Menu Utama'),
            ),
          ],
        ),
      ),
    );
  }
}


// Cetakan data khusus untuk Grafik Radar Fitur Fisik Siswa
class DataRadar {
  DataRadar(this.jenisLatihan, this.nilaiSiswaA, this.nilaiSiswaB, this.nilaiSiswaC);
  
  final String jenisLatihan; // Contoh: 'Push Up'
  final double nilaiSiswaA;  // Nilai siswa pertama
  final double nilaiSiswaB;  // Nilai siswa kedua
  final double nilaiSiswaC;  // Nilai siswa ketiga
}

