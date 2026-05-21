import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Atlet Standar',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const DashboardAtletPage(),
    );
  }
}

class DashboardAtletPage extends StatelessWidget {
  const DashboardAtletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistik Atlet (Custom Paint)',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE3E7F1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // CARD 1: 7 GRAFIK BOXPLOT (KOMPONEN UTAMA)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1 Boxplot Atlet: Komponen Utama (7 Kategori)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 220,
                    child: BoxplotChart(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // CARD 2: RADAR GAUGE BERLAPIS (10 PARAMETER)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1 Radar Atlet: 10 Parameter Jarak/Durasi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 320,
                    child: RadialDistanceChart(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== GENERATOR BOXPLOT WIDGET ====================
class BoxplotChart extends StatelessWidget {
  const BoxplotChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ['Gly', 'End', 'Spd', 'Coord', 'Flex', 'Bal', 'React'];
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: BoxplotPainter(),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels.map((label) => SizedBox(
            width: 40,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class BoxplotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Paint boxPaint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..style = PaintingStyle.fill;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    int dataCount = 7;
    double spacing = size.width / dataCount;

    // Koordinat acak 7 Boxplot
    List<List<double>> boxData = [
      [0.0, 0.25, 0.38, 0.50, 0.65, 0.82],
      [0.23, 0.28, 0.42, 0.56, 0.70, 0.85],
      [0.25, 0.32, 0.45, 0.55, 0.68, 0.88],
      [0.0, 0.22, 0.35, 0.48, 0.62, 0.80],
      [0.0, 0.20, 0.32, 0.44, 0.58, 0.75],
      [0.0, 0.15, 0.28, 0.40, 0.55, 0.76],
      [0.24, 0.30, 0.46, 0.58, 0.72, 0.86],
    ];

    for (int i = 0; i < dataCount; i++) {
      double x = (spacing * i) + (spacing / 2);
      var data = boxData[i];
      double outlier = data[0] * size.height;
      double topWhisker = data[1] * size.height;
      double q3 = data[2] * size.height;
      double median = data[3] * size.height;
      double q1 = data[4] * size.height;
      double bottomWhisker = data[5] * size.height;
      double boxWidth = spacing * 0.45;

      if (data[0] > 0) {
        canvas.drawCircle(Offset(x, outlier), 3, Paint()..color = const Color(0xFF0D47A1));
      }
      canvas.drawLine(Offset(x, topWhisker), Offset(x, q3), linePaint);
      canvas.drawLine(Offset(x - boxWidth/4, topWhisker), Offset(x + boxWidth/4, topWhisker), linePaint);
      canvas.drawLine(Offset(x, q1), Offset(x, bottomWhisker), linePaint);
      canvas.drawLine(Offset(x - boxWidth/4, bottomWhisker), Offset(x + boxWidth/4, bottomWhisker), linePaint);

      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3, x + boxWidth / 2, q1);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, linePaint);
      canvas.drawLine(Offset(x - boxWidth / 2, median), Offset(x + boxWidth / 2, median), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== GENERATOR 10 TINGKAT GAUGE WIDGET ====================
class RadialDistanceChart extends StatelessWidget {
  const RadialDistanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size.infinite,
          painter: RadialDistancePainter(),
        ),
        // Menampilkan teks indikator parameter acak secara bertingkat di atas garis cincin
        const Positioned(top: 18, left: 145, child: Text('P1: 13M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 32, left: 145, child: Text('P2: 12M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 46, left: 145, child: Text('P3: 11M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 60, left: 145, child: Text('P4: 10M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 74, left: 145, child: Text('P5: 9M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 88, left: 145, child: Text('P6: 8M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 102, left: 145, child: Text('P7: 7M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 116, left: 145, child: Text('P8: 6M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 130, left: 145, child: Text('P9: 5M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 144, left: 145, child: Text('P10: 4M', style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.black54))),
      ],
    );
  }
}

class RadialDistancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    
    // Radius bertingkat untuk mengakomodasi total 10 cincin parameter secara pas
    List<double> radii = [135, 121, 107, 93, 79, 65, 51, 37, 23, 9];
    
    // Warna acak untuk masing-masing 10 ring parameter
    List<Color> colors = [
      Colors.orange, Colors.red, Colors.purple, Colors.blue, Colors.teal,
      Colors.green, Colors.amber, Colors.indigo, Colors.pink, Colors.cyan
    ];
    
    // Panjang nilai acak isi bar (0.0 sampai 1.0) untuk 10 parameter
    List<double> sweepPercentages = [0.85, 0.65, 0.72, 0.90, 0.45, 0.78, 0.60, 0.83, 0.52, 0.40];
    
    // Arah titik mulai lengkungan lingkaran yang diacak agar estetik
    List<double> startAngles = [
      -math.pi / 2, -math.pi / 4, 0.0, math.pi / 3, math.pi / 1.5,
      -math.pi / 3, math.pi / 4, math.pi / 6, -math.pi / 6, math.pi / 2
    ];

    Paint bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = const Color(0xFFE0E0E0).withOpacity(0.4);

    for (int i = 0; i < radii.length; i++) {
      double radius = radii[i];
      if (radius <= 0) continue; // Mencegah nilai radius minus atau nol
      
      // Menggambar track abu-abu dasar
      canvas.drawCircle(center, radius, bgPaint);

      // Menggambar nilai warna parameter aktif
      Paint progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = colors[i]
        ..strokeCap = StrokeCap.round;

      double sweepAngle = 2 * math.pi * sweepPercentages[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngles[i],
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
