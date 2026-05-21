import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// 1. Model Murid dengan 3 Parameter
class Murid {
  final String nama;
  final double p1; // Kekuatan (Merah)
  final double p2; // Kecepatan (Hijau)
  final double p3; // Kelenturan (Biru)

  Murid({
    required this.nama, 
    required this.p1, 
    required this.p2, 
    required this.p3
  });

  // Menghitung rata-rata otomatis
  double get rataRata => (p1 + p2 + p3) / 3;
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
        brightness: Brightness.light,
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

    // 2. Generate Data 5 Murid dengan 3 Parameter Acak
    final List<Murid> dataMurid = List.generate(5, (index) {
      return Murid(
        nama: 'Murid ${index + 1}',
        p1: 40.0 + random.nextInt(51), // 40-90
        p2: 30.0 + random.nextInt(61), // 30-90
        p3: 50.0 + random.nextInt(41), // 50-90
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring 3 Parameter'),
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
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header: Nama & Rata-rata (Perbaikan spaceBetween)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      Text(
                        murid.nama,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Avg: ${murid.rataRata.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // CONCENTRIC RADIAL GAUGE
                  SizedBox(
                    height: 220,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          startAngle: 270,
                          endAngle: 270,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0, // Sembunyikan garis axis utama
                          ),
                          pointers: <GaugePointer>[
                            // Ring Luar (P1 - Strength)
                            RangePointer(
                              value: murid.p1,
                              width: 18,
                              pointerOffset: 0.1,
                              radiusFactor: 0.95,
                              color: Colors.redAccent,
                              enableAnimation: true,
                              cornerStyle: CornerStyle.bothCurve,
                            ),
                            // Ring Tengah (P2 - Speed)
                            RangePointer(
                              value: murid.p2,
                              width: 18,
                              pointerOffset: 0.1,
                              radiusFactor: 0.75,
                              color: Colors.greenAccent.shade700,
                              enableAnimation: true,
                              cornerStyle: CornerStyle.bothCurve,
                            ),
                            // Ring Dalam (P3 - Agility)
                            RangePointer(
                              value: murid.p3,
                              width: 18,
                              pointerOffset: 0.1,
                              radiusFactor: 0.55,
                              color: Colors.blueAccent,
                              enableAnimation: true,
                              cornerStyle: CornerStyle.bothCurve,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            // Angka Rata-rata di Tengah (Perbandingan Antar Murid)
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    murid.rataRata.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 32, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87
                                    ),
                                  ),
                                  const Text("SKOR", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                              angle: 90,
                              positionFactor: 0,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Legend Sederhana
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend("Str", Colors.redAccent),
                      const SizedBox(width: 15),
                      _buildLegend("Spd", Colors.greenAccent.shade700),
                      const SizedBox(width: 15),
                      _buildLegend("Agl", Colors.blueAccent),
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

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

