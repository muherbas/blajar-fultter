import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// 1. Model Data dengan 3 Parameter Fisik Riil
class ProgressMurid {
  final String nama;
  final double kekuatan;   // Parameter 1 (Cincin Luar)
  final double kecepatan;  // Parameter 2 (Cincin Tengah)
  final double kelenturan;  // Parameter 3 (Cincin Dalam)

  ProgressMurid({
    required this.nama, 
    required this.kekuatan, 
    required this.kecepatan, 
    required this.kelenturan,
  });

  // Fungsi menghitung rata-rata untuk perbandingan antar murid
  double get rataRata => (kekuatan + kecepatan + kelenturan) / 3;
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: Colors.indigo,
      ),
      home: const DashboardMultiParameter(),
    );
  }
}

class DashboardMultiParameter extends StatelessWidget {
  const DashboardMultiParameter({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    // 2. Data Acak 5 Murid dengan 3 Nilai Parameter Berbeda
    final List<ProgressMurid> dataMurid = List.generate(5, (index) {
      return ProgressMurid(
        nama: 'Murid ${index + 1}',
        kekuatan: 40.0 + random.nextInt(51),   // Skor acak 40 - 90
        kecepatan: 35.0 + random.nextInt(56),  // Skor acak 35 - 90
        kelenturan: 50.0 + random.nextInt(41),  // Skor acak 50 - 90
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis 3 Parameter Murid'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade50,
      ),
      body: ListView.builder(
        itemCount: dataMurid.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final murid = dataMurid[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // HEADER: Nama Murid & Rata-rata Kemampuan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      Text(
                        murid.nama,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rata-rata: ${murid.rataRata.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // 3 PARAMETER GAUGE (Setengah Lingkaran Berlapis)
                  SizedBox(
                    height: 160,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        // LAPISAN 1: KEKUATAN (Paling Luar - Merah)
                        RadialAxis(
                          minimum: 0, maximum: 100,
                          showLabels: false, showTicks: false,
                          startAngle: 180, endAngle: 0,
                          canScaleToFit: true,
                          radiusFactor: 0.95, 
                          axisLineStyle: AxisLineStyle(thickness: 12, color: Colors.red.shade100),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: murid.kekuatan,
                              width: 12, color: Colors.redAccent,
                              cornerStyle: CornerStyle.bothCurve,
                            )
                          ],
                        ),
                        
                        // LAPISAN 2: KECEPATAN (Tengah - Hijau)
                        RadialAxis(
                          minimum: 0, maximum: 100,
                          showLabels: false, showTicks: false,
                          startAngle: 180, endAngle: 0,
                          canScaleToFit: true,
                          radiusFactor: 0.78, 
                          axisLineStyle: AxisLineStyle(thickness: 12, color: Colors.green.shade100),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: murid.kecepatan,
                              width: 12, color: Colors.greenAccent.shade700,
                              cornerStyle: CornerStyle.bothCurve,
                            )
                          ],
                        ),
                        
                        // LAPISAN 3: KELENTURAN (Paling Dalam - Biru) + Angka Perbandingan di Tengah
                        RadialAxis(
                          minimum: 0, maximum: 100,
                          showLabels: false, showTicks: false,
                          startAngle: 180, endAngle: 0,
                          canScaleToFit: true,
                          radiusFactor: 0.61, 
                          axisLineStyle: AxisLineStyle(thickness: 12, color: Colors.blue.shade100),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: murid.kelenturan,
                              width: 12, color: Colors.blueAccent,
                              cornerStyle: CornerStyle.bothCurve,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    murid.rataRata.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 32, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87
                                    ),
                                  ),
                                  const Text("OVERALL", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              angle: 90,
                              positionFactor: 0.2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // LEGEND / KETERANGAN PARAMETER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem("Kekuatan (Str)", Colors.redAccent),
                      const SizedBox(width: 12),
                      _buildLegendItem("Kecepatan (Spd)", Colors.greenAccent.shade700),
                      const SizedBox(width: 12),
                      _buildLegendItem("Kelenturan (Flx)", Colors.blueAccent),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8, height: 8, 
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label, 
          style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
