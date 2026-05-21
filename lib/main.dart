import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DataDistributionGauge extends StatelessWidget {
  final double score; // Nilai data yang ingin ditampilkan

  const DataDistributionGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      title: const GaugeTitle(
          text: 'Distribusi Performa',
          textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          // Mengatur label dan interval angka pada gauge
          showLabels: true,
          showTicks: true,
          ranges: <GaugeRange>[
            // Memvisualisasikan distribusi kategori
            GaugeRange(
                startValue: 0, 
                endValue: 35, 
                color: Colors.red, 
                label: 'RENDAH'),
            GaugeRange(
                startValue: 35, 
                endValue: 70, 
                color: Colors.orange, 
                label: 'SEDANG'),
            GaugeRange(
                startValue: 70, 
                endValue: 100, 
                color: Colors.green, 
                label: 'TINGGI'),
          ],
          pointers: <GaugePointer>[
            // Jarum penunjuk nilai data
            NeedlePointer(
              value: score,
              enableAnimation: true,
              needleColor: Colors.black,
              tailStyle: TailStyle(color: Colors.black, width: 5),
              knobStyle: KnobStyle(color: Colors.black),
            ),
          ],
          annotations: <GaugeAnnotation>[
            // Teks angka di tengah gauge
            GaugeAnnotation(
              widget: Text(
                score.toString(),
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              angle: 90,
              positionFactor: 0.5,
            )
          ],
        ),
      ],
    );
  }
}