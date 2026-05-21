import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// 1. Model Data diletakkan di atas agar terbaca oleh class di bawahnya
class Murid {
  final String nama;
  final double skor;

  Murid({required this.nama, required this.skor});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const DaftarGaugeMurid(),
    );
  }
}

class DaftarGaugeMurid extends StatelessWidget {
  const DaftarGaugeMurid({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Simulasi data 20 murid
    final List<Murid> listMurid = List.generate(
      20,
      (index) => Murid(nama: 'Murid ${index + 1}', skor: (index * 4.5) + 10),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Skor Murid'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listMurid.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final murid = listMurid[index];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    murid.nama,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // GAUGE WIDGET
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
                          interval: 10,
                          showLabels: false,
                          showTicks: true,
                          ranges: <GaugeRange>[
                            GaugeRange(startValue: 0, endValue: 40, color: Colors.red.shade400),
                            GaugeRange(startValue: 40, endValue: 75, color: Colors.orange.shade400),
                            GaugeRange(startValue: 75, endValue: 100, color: Colors.green.shade400),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: murid.skor,
                              needleLength: 0.7,
                              needleColor: Colors.black87,
                              knobStyle: const KnobStyle(knobRadius: 0.06),
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                '${murid.skor.toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              angle: 90,
                              positionFactor: 0.5,
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
