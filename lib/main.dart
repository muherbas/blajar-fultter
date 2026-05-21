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
      title: 'Statistik Atlet',
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
          'Statistik Ruri',
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
            // CARD 1: BOXPLOT ATLET (KOMPONEN UTAMA)
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
                    '1 Boxplot Atlet: Komponen Utama',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 220,
                    child: BoxplotChart(),
                  ),
                  const SizedBox(height: 12),
                  
                  // Info Box Rata-rata Keseluruhan Murid
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Nilai Rata-Rata Keseluruhan Murid',
                            style: TextStyle(fontSize: 9, color: Colors.black54),
                          ),
                          const Text(
                            '68.5',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.685,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Avg: 68.5',
                            style: TextStyle(fontSize: 9, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // CARD 2: RADAR ATLET (KOMPONEN TURUNAN / SHOT PUT DISTANCE)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '1 Radar Atlet: Komponen Turunan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF880E4F),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECB3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Avg: 73.7',
                          style: TextStyle(fontSize: 9, color: Colors.brown, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Shot put distance',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'PARAMETER TERPILIH:',
                          style: TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'MUSCULAR ENDURANCE',
                          style: TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 260,
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

// === WIDGET GRAFIK BOXPLOT ===
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

    // Menggambar baseline horizontal bawah
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    
    int dataCount = 7;
    double spacing = size.width / dataCount;

    // Format Data: [outlierY, topWhiskerY, q3Y, medianY, q1Y, bottomWhiskerY] (skala 0.0 sampai 1.0)
    List<List<double>> boxData = [
      [0.0, 0.25, 0.38, 0.50, 0.65, 0.82],   // Gly
      [0.23, 0.28, 0.42, 0.56, 0.70, 0.85],  // End (dengan Outlier)
      [0.25, 0.32, 0.45, 0.55, 0.68, 0.88],  // Spd (dengan Outlier)
      [0.0, 0.22, 0.35, 0.48, 0.62, 0.80],   // Coord
      [0.0, 0.20, 0.32, 0.44, 0.58, 0.75],   // Flex
      [0.0, 0.15, 0.28, 0.40, 0.55, 0.76],   // Bal
      [0.24, 0.30, 0.46, 0.58, 0.72, 0.86],  // React (dengan Outlier)
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

      // Gambar titik Outlier (jika terdeteksi nilai > 0)
      if (data[0] > 0) {
        canvas.drawCircle(Offset(x, outlier), 3, Paint()..color = const Color(0xFF0D47A1));
      }
      
      // Menggambar garis Whisker T-Bar Atas & Bawah
      canvas.drawLine(Offset(x, topWhisker), Offset(x, q3), linePaint);
      canvas.drawLine(Offset(x - boxWidth/4, topWhisker), Offset(x + boxWidth/4, topWhisker), linePaint);
      canvas.drawLine(Offset(x, q1), Offset(x, bottomWhisker), linePaint);
      canvas.drawLine(Offset(x - boxWidth/4, bottomWhisker), Offset(x + boxWidth/4, bottomWhisker), linePaint);

      // Menggambar Kotak Utama Boxplot (Q1 ke Q3)
      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3, x + boxWidth / 2, q1);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, linePaint);
      
      // Menggambar Garis Nilai Tengah (Median)
      canvas.drawLine(Offset(x - boxWidth / 2, median), Offset(x + boxWidth / 2, median), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// === WIDGET GRAFIK RADAR/CONCENTRIC RING BAR ===
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
        // Skala Indikator Jarak (13M, 12M, dll.) diposisikan manual di tengah atas cincin grafik
        const Positioned(top: 42, left: 145, child: Text('13M', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 58, left: 145, child: Text('12M', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 74, left: 145, child: Text('11M', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54))),
        const Positioned(top: 90, left: 145, child: Text('10M', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54))),
      ],
    );
  }
}

class RadialDistancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    
    // Konfigurasi radius cincin berlapis dari luar ke dalam
    List<double> radii = [100, 85, 70, 55, 40];
    
    // Warna tiap bar sesuai screenshot asli (Orange, Merah Tua, Ungu, Biru Tua, Biru Muda)
    List<Color> colors = [
      const Color(0xFFE67E22),
      const Color(0xFFC0392B),
      const Color(0xFF9B59B6),
      const Color(0xFF2980B9),
      const Color(0xFF3498DB),
    ];
    
    // Persentase panjang bar & sudut mulai lingkaran (agar melengkung dinamis tidak searah)
    List<double> sweepPercentages = [0.85, 0.65, 0.72, 0.90, 0.45];
    List<double> startAngles = [-math.pi / 2, -math.pi / 4, 0.0, math.pi / 3, math.pi / 1.5];

    // Kuas untuk background track lingkaran abu-abu transparan
    Paint bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = const Color(0xFFE0E0E0).withOpacity(0.4);

    for (int i = 0; i < radii.length; i++) {
      double radius = radii[i];
      // Gambar lingkaran abu-abu sebagai base jalur tracker
      canvas.drawCircle(center, radius, bgPaint);

      // Kuas untuk progress bar berwarna dengan ujung melengkung halus (StrokeCap.round)
      Paint progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
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