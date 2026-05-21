import 'dart:math'; // Diperlukan untuk generate angka acak
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProgressMurid {
  final String nama;
  final double skorAwal;
  final double skorSekarang;

  ProgressMurid({
    required this.nama, 
    required this.skorAwal, 
    required this.skorSekarang
  });
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DashboardProgress(),
    );
  }
}

class DashboardProgress extends StatelessWidget {
  const DashboardProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    // Membuat data acak untuk 5 orang murid saja gpp
    final List<ProgressMurid> dataMurid = List.generate(
      5,
      (index) {
        // Skor awal acak antara 20 sampai 50
        double awal = 20.0 + random.nextInt(31); 
        // Skor sekarang acak dari skor awal sampai maksimal 100
        double sekarang = awal + random.nextInt(41); 
        if (sekarang > 100) sekarang = 100;
        
        return ProgressMurid(
          nama: 'Murid ${index + 1}',
          skorAwal: awal,
          skorSekarang: sekarang,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Progress Murid'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: dataMurid.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final murid = dataMurid[index];
          double peningkatan = murid.skorSekarang - murid.skorAwal;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // BAGIAN YANG TYPO SUDAH DIPERBAIKI DI SINI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pake spaceBetween, bukan between
                    children: [
                      Text(
                        murid.nama,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Naik: +${peningkatan.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.green, 
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // GAUGE PROGRESS
                  SizedBox(
                    height: 140, 
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          startAngle: 180,
                          endAngle: 0,
                          canScaleToFit: true,
                          showLabels: false,
                          showTicks: true,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0, 
                              endValue: murid.skorAwal, 
                              color: Colors.grey.shade300,
                              label: 'AWAL',
                              labelStyle: const GaugeTextStyle(color: Colors.black54),
                            ),
                            GaugeRange(
                              startValue: murid.skorAwal, 
                              endValue: 100, 
                              color: Colors.indigo.shade100,
                              label: 'TARGET',
                              labelStyle: const GaugeTextStyle(color: Colors.indigo),
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: murid.skorSekarang,
                              needleLength: 0.75,
                              needleColor: Colors.indigo,
                              knobStyle: const KnobStyle(
                                knobRadius: 0.07, 
                                color: Colors.indigo
                              ),
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                '${murid.skorSekarang.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
