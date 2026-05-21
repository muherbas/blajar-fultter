import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// 1. Model Data Lengkap 17 Parameter untuk 1 Murid
class DetailPerformaMurid {
  final String nama;
  
  // 7 Parameter Komponen Utama (Boxplot / Bar Chart)
  final double strength;
  final double endurance;
  final double speed;
  final double coordination;
  final double flexibility;
  final double balance;
  final double reactionTime;

  // 10 Parameter Komponen Turunan (Gauge / Batang Radial)
  final Map<String, double> komponenTurunan;

  DetailPerformaMurid({
    required this.nama,
    required this.strength,
    required this.endurance,
    required this.speed,
    required this.coordination,
    required this.flexibility,
    required this.balance,
    required this.reactionTime,
    required this.komponenTurunan,
  });

  // Hitung Rata-rata otomatis untuk 10 parameter turunan
  double get rataRataTurunan {
    double total = komponenTurunan.values.fold(0, (sum, item) => sum + item);
    return total / komponenTurunan.length;
  }
}

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

class _DashboardAtletState extends State<DashboardAtlet> {
  late DetailPerformaMurid muridAktif;
  String parameterTurunanTerpilih = "MUSCULAR ENDURANCE"; // Default awal

  @override
  void initState() {
    super.initState();
    // 2. Simulasi Data Riil 1 Murid (Misal: Ruri) sesuai contoh parameter Anda
    muridAktif = DetailPerformaMurid(
      nama: "Statistik Ruri",
      strength: 75,
      endurance: 80,
      speed: 65,
      coordination: 85,
      flexibility: 70,
      balance: 90,
      reactionTime: 60,
      komponenTurunan: {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List data untuk mempermudah pembuatan grafik Bar Chart atas
    final List<Map<String, dynamic>> dataUtama = [
      {"label": "Str", "value": muridAktif.strength},
      {"label": "End", "value": muridAktif.endurance},
      {"label": "Spd", "value": muridAktif.speed},
      {"label": "Coord", "value": muridAktif.coordination},
      {"label": "Flex", "value": muridAktif.flexibility},
      {"label": "Bal", "value": muridAktif.balance},
      {"label": "React", "value": muridAktif.reactionTime},
    ];

    double nilaiGaugeAktif = muridAktif.komponenTurunan[parameterTurunanTerpilih] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(muridAktif.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // SEKSI 1: BOXPLOT / BAR CHART (7 KOMPONEN UTAMA)
            // ========================================================
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "1 Boxplot Atlet: Komponen Utama",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 20),
                    // Grafik Batang Sederhana & Ringan untuk HP
                    SizedBox(
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: dataUtama.map((item) {
                          double tinggiPersen = item["value"] / 100;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${item["value"].toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                width: 24,
                                height: 110 * tinggiPersen,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(item["label"], style: const TextStyle(fontSize: 11, color: Colors.black54)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ========================================================
            // SEKSI 2: GAUGE BATANG RADIAL INTERAKTIF (10 KOMPONEN TURUNAN)
            // ========================================================
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "1 Radar Atlet: Komponen Turunan",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Avg: ${muridAktif.rataRataTurunan.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Tampilan Grafik Batang Radial Tunggal yang Besar & Lega
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            height: 150,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0, maximum: 100,
                                  showLabels: false, showTicks: false,
                                  startAngle: 270, endAngle: 270, // 360 Derajat utuh
                                  radiusFactor: 0.95,
                                  axisLineStyle: AxisLineStyle(thickness: 16, color: Colors.orange.shade100),
                                  pointers: <GaugePointer>[
                                    RangePointer(
                                      value: nilaiGaugeAktif,
                                      width: 16,
                                      color: Colors.orangeAccent.shade700,
                                      cornerStyle: CornerStyle.bothCurve,
                                      enableAnimation: true,
                                    )
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${nilaiGaugeAktif.toStringAsFixed(0)}%',
                                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                          const Text("SKOR", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      angle: 90, positionFactor: 0,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        // Detail Singkat Parameter yang Sedang Dipilih
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("PARAMETER TERPILIH:", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  parameterTurunanTerpilih,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 5),

                    // LIST TOMBOL INTERAKTIF UNTUK MEMILIH 10 PARAMETER
                    const Text("Sentuh parameter untuk melihat skor grafik:", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 130, // Area scroll list parameter
                      child: ListView(
                        shrinkWrap: true,
                        children: muridAktif.komponenTurunan.keys.map((String key) {
                          bool isSelected = parameterTurunanTerpilih == key;
                          return Card(
                            color: isSelected ? Colors.orange.shade700 : Colors.grey.shade100,
                            elevation: isSelected ? 2 : 0,
                            margin: const EdgeInsets.only(bottom: 6),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                key,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                '${muridAktif.komponenTurunan[key]?.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.orange.shade900,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  parameterTurunanTerpilih = key; // Grafik otomatis berputar menyesuaikan data baru
                                });
                              },
                            ),
                          );
                        }).toList(),
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
