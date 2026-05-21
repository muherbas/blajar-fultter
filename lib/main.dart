import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatistikPage(),
    );
  }
}

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  // Fungsi baca JSON dari assets
  Future<Map<String, dynamic>> loadAtletData() async {
    String jsonString = await rootBundle.loadString('assets/atlet_data.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Ruri', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F6FA), // Background abu-abu muda ala dashboard web
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadAtletData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final dataAplikasi = snapshot.data!;
          
          // Ambil data untuk Boxplot
          final List<dynamic> boxplotDataRaw = dataAplikasi['komponen_utama_boxplot']['data_parameter'];
          
          // Ambil data untuk Radial Bar
          final List<dynamic> radialDataRaw = dataAplikasi['komponen_turunan_radial_bar']['data_komparasi'];
          final String parameterTerpilih = dataAplikasi['komponen_turunan_radial_bar']['parameter_terpilih'];
          final double avgKeseluruhan = dataAplikasi['nilai_rata_rata_keseluruhan_murid'].toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------------------
                // 1. KELOMPOK GRAFIK BOXPLOT (KOMPONEN UTAMA)
                // -------------------------------------------------------------
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "1 Boxplot Atlet: Komponen Utama",
                          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        
                        // Menggunakan Stack agar bisa menaruh box nilai rata-rata di pojok kanan bawah chart
                        Stack(
                          children: [
                            Container(
                              height: 300,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 20),
                                series: <BoxAndWhiskerSeries<dynamic, String>>[
                                  BoxAndWhiskerSeries<dynamic, String>(
                                    dataSource: boxplotDataRaw,
                                    xValueMapper: (dynamic data, _) => data['parameter'],
                                    // Mapping seluruh nilai statistik boxplot dari JSON
                                    minimumMapper: (dynamic data, _) => data['min'].toDouble(),
                                    lowerQuartileMapper: (dynamic data, _) => data['q1'].toDouble(),
                                    medianMapper: (dynamic data, _) => data['median'].toDouble(),
                                    upperQuartileMapper: (dynamic data, _) => data['q3'].toDouble(),
                                    maximumMapper: (dynamic data, _) => data['max'].toDouble(),
                                    outliersMapper: (dynamic data, _) => (data['outliers'] as List).map((e) => e.toDouble()).toList(),
                                    boxPlotMode: BoxPlotMode.normal,
                                    color: Colors.blue.withOpacity(0.7),
                                    borderColor: Colors.blue,
                                    strokeWidth: 2,
                                  )
                                ],
                              ),
                            ),
                            
                            // Kotak Nilai Rata-Rata Keseluruhan Murid di pojok kanan bawah
                            Positioned(
                              bottom: 20,
                              right: 15,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text("Nilai Rata-Rata Keseluruhan Murid", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                    Text("$avgKeseluruhan", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black80)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // 2. KELOMPOK GRAFIK RADIAL BAR (KOMPONEN TURUNAN)
                // -------------------------------------------------------------
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            const Text(
                              "1 Radar Atlet: Komponen Turunan",
                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              "PARAMETER TERPILIH:\n$parameterTerpilih",
                              textAlign: MainAxisAlignment.right,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        
                        // Grafik Radial Bar
                        Container(
                          height: 320,
                          child: SfCircularChart(
                            // Legenda di pojok kanan/kiri otomatis menampilkan nama dan nilai
                            legend: Legend(
                              isVisible: true, 
                              position: LegendPosition.right,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                            series: <CircularSeries<dynamic, String>>[
                              RadialBarSeries<dynamic, String>(
                                dataSource: radialDataRaw,
                                xValueMapper: (dynamic data, _) => "${data['nama_murid']} (${data['skor_persentase']}% )",
                                yValueMapper: (dynamic data, _) => data['skor_persentase'],
                                maximumValue: 100,
                                radius: '100%',
                                innerRadius: '30%',
                                gap: '8%', // Jarak antar ring bar lingkaran
                                useAnchorPoint: false, // Menghilangkan penunjuk garis/dot tambahan
                                trackColor: Colors.grey[200]!, // Warna jalur kosong lingkaran
                                dataLabelSettings: const DataLabelSettings(isVisible: false), // Garis penunjuk luar dimatikan
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
          );
        },
      ),
    );
  }
}
