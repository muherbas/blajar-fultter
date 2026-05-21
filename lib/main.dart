import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Murid {
  final String nama;
  final double p1; // Parameter 1 (Misal: Kekuatan)
  final double p2; // Parameter 2 (Misal: Kecepatan)
  final double p3; // Parameter 3 (Misal: Kelenturan)

  Murid({
    required this.nama, 
    required this.p1, 
    required this.p2, 
    required this.p3
  });

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

    // Data acak untuk 5 orang murid dengan 3 parameter kemampuan
    final List<Murid> dataMurid = List.generate(5, (index) {
      return Murid(
        nama: 'Murid ${index + 1}',
        p1: 40.0 + random.nextInt(51), // Skor 40 - 90
        p2: 35.0 + random.nextInt(56), // Skor 35 - 90
        p3: 50.0 + random.nextInt(41), // Skor 50 - 90
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
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header Kartu Murid
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
                          'Rata-rata: ${murid.rataRata.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // CONCENTRIC MULTI-AXIS RADIAL GAUGE (Gaya Cincin Aktivitas)
                  SizedBox(
                    height: 220,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        // Lingkaran 1: LUAR (Parameter 1 - Merah)
                        RadialAxis(
                          minimum: 0, maximum: 100,
                          showLabels: false, showTicks: false,
                          startAngle: 270, endAngle: 270,
                          radiusFactor: 0.95, // Mengatur ukuran lingkaran luar
                          axisLineStyle: AxisLineStyle(thickness: 14, color: Colors.red.shade100),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: murid.p1,
                              width: 14,
                              color: Colors.redAccent,
                              cornerStyle: CornerStyle.bothCurve,
                            )
                          ],
                        ),
                        
                        // Lingkaran 2: TENGAH (Parameter 2 - Hijau)
                        RadialAxis(
                          minimum: 0, maximum: 100,
                          showLabels: false, showTicks: false,
                          startAngle: 270, endAngle: 270,
                          radiusFactor: 0.77, // Mengecil masuk ke dalam
                          axisLineStyle: AxisLineStyle(thickness: 14, color: Colors.green.shade100),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: murid.p2,
                              width: 14,
                              color: Colors.greenAccent.shade700,
                              cornerStyle: CornerStyle.bothCurve,
                            )
                          ],
                        ),
                        
                        // Lingkaran 3: DALAM (Parameter 3 - Biru) + Angka Rata-Rata di Tengah
                        RadialAxis(
                          minimum: 0, maximum: 100,
                          showLabels: false, showTicks: false,
                          startAngle: 270, endAngle: 270,
                          radiusFactor: 0.59, // Paling dalam
                          axisLineStyle: AxisLineStyle(thickness: 14, color: Colors.blue.shade100),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: murid.p3,
                              width: 14,
                              color: Colors.blueAccent,
                              cornerStyle: CornerStyle.bothCurve,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    murid.rataRata.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 28, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87
                                    ),
                                  ),
                                  const Text("SKOR", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
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
                  
                  // Keterangan Warna Parameter (Legend)
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem("Kekuatan", Colors.redAccent),
                      const SizedBox(width: 16),
                      _buildLegendItem("Kecepatan", Colors.greenAccent.shade700),
                      const SizedBox(width: 16),
                      _buildLegendItem("Kelenturan", Colors.blueAccent),
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
          width: 10, 
          height: 10, 
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label, 
          style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}