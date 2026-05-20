import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Variabel Global untuk menandai apakah aplikasi baru pertama kali dibuka
bool apakahAplikasiBaruBuka = true;

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
      // Aplikasi pertama kali dibuka akan mengarah ke Menu Utama
      home: const MenuUtamaPage(),
    );
  }
}

// ==========================================================
// 1. WIDGET REUSABLE SPLASH SCREEN (KOMPONEN TRANSISI)
// ==========================================================
class MemuatHalaman extends StatefulWidget {
  final Widget halamanTujuan;
  final String pesanLoading;

  const MemuatHalaman({
    super.key, 
    required this.halamanTujuan, 
    this.pesanLoading = 'Memuat Data...',
  });

  @override
  State<MemuatHalaman> createState() => _MemuatHalamanState();
}

class _MemuatHalamanState extends State<MemuatHalaman> {
  @override
  void initState() {
    super.initState();

    // Tentukan durasi: 6 detik jika baru buka aplikasi, 3 detik jika pindah halaman biasa
    int durasiDetik = apakahAplikasiBaruBuka ? 6 : 3;

    Future.delayed(Duration(seconds: durasiDetik), () {
      // Setelah 6 detik pertama terlewati, matikan status booting awal secara permanen
      if (apakahAplikasiBaruBuka) {
        apakahAplikasiBaruBuka = false;
      }

      // Jalankan perpindahan ke halaman tujuan murni
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.halamanTujuan),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.analytics_rounded,
              size: 90,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              apakahAplikasiBaruBuka ? 'Memulai Aplikasi...' : widget.pesanLoading,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Teks penunjuk waktu biar pengguna tidak bingung
            Text(
              apakahAplikasiBaruBuka ? 'Mohon tunggu 6 detik...' : 'Tunggu 3 detik...',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// 2. HALAMAN MENU UTAMA
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
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.bar_chart),
          label: const Text('Lihat Grafik Boxplot', style: TextStyle(fontSize: 18)),
          onPressed: () {
            // SAAT PINDAH: Bungkus halaman tujuan dengan widget MemuatHalaman
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
      ),
    );
  }
}

// ==========================================================
// 3. HALAMAN GRAFIK BOXPLOT
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
            // Tombol untuk kembali ke menu utama (akan memicu loading 3 detik lagi)
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