import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const AplikasiBoxplot());
}

class AplikasiBoxplot extends StatelessWidget {
  const AplikasiBoxplot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grafik Boxplot!',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HalamanBoxplot(),
    );
  }
}

class HalamanBoxplot extends StatefulWidget {
  const HalamanBoxplot({super.key});

  @override
  State<HalamanBoxplot> createState() => _HalamanBoxplotState();
}

class _HalamanBoxplotState extends State<HalamanBoxplot> {
  // Variabel untuk menampung data
  late List<DataKategori> _dataNilai;

  @override
  void initState() {
    super.initState();
    
    // Menyiapkan sekumpulan (array) angka untuk tiap kategori.
    // Perhatikan Kelas A: Angka 20 sangat kecil dan angka 98 sangat besar.
    // Nanti angka 20 dan 98 ini akan otomatis terdeteksi sebagai titik Outlier.
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
        title: const Text('Belajar Grafik Boxplot'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          // Memanggil Widget Grafik Cartesian dari Syncfusion
          child: SfCartesianChart(
            title: const ChartTitle(text: 'Sebaran Nilai Ujian per Kelas\n(Mendeteksi Outlier)'),
            
            // Pengaturan Sumbu X (Kategori: Kelas A, Kelas B, dsb)
            primaryXAxis: const CategoryAxis(
              title: AxisTitle(text: 'Kategori Kelas'),
            ),
            
            // Pengaturan Sumbu Y (Angka Nilai)
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: 'Poin Ujian'),
            ),
            
            // Jenis seri grafik yang dipilih adalah BoxAndWhiskerSeries
            series: <CartesianSeries>[
              BoxAndWhiskerSeries<DataKategori, String>(
                dataSource: _dataNilai,
                xValueMapper: (DataKategori data, _) => data.namaKelas,
                
                // Pada Boxplot, nilai Y harus dikembalikan dalam bentuk List angka
                yValueMapper: (DataKategori data, _) => data.daftarNilai,
                
                name: 'Distribusi Nilai',
                // Tampilkan rata-rata (Mean) sebagai tanda silang
                showMean: true, 
                // Opsional: Anda bisa mengubah warna kotaknya
                color: Colors.blueAccent.withOpacity(0.7),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Class cetakan dasar untuk menyimpan format data Boxplot
class DataKategori {
  DataKategori(this.namaKelas, this.daftarNilai);
  
  final String namaKelas;
  final List<num> daftarNilai; // Array berisi kumpulan nilai
}
