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
      title: 'Dashboard Atlet Manual',
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
          'Statistik Atlet (Boxplot & Radar)',
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
                  const SizedBox(height: 12),
                  // Informasi Perbandingan Rata-rata di Pojok Kanan
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
                            'Rata-rata Keseluruhan Murid',
                            style: TextStyle(fontSize: 9, color: Colors.black54),
                          ),
                          const Text(
                            '68.5',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // CARD 2: RADAR POLYGON (10 PARAMETER)
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
                    '1 Radar Atlet: 10 Parameter (Jaring Polygon)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 300,
                    child: RadarPolygonChart(),
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

// ==================== WIDGET & PAINTER BOXPLOT ====================
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

    // Data Koordinat Gambar Boxplot (Skala 0.0 sampai 1.0 dari atas ke bawah)
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

// ==================== WIDGET & PAINTER RADAR POLYGON ====================
class RadarPolygonChart extends StatelessWidget {
  const RadarPolygonChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: RadarPolygonPainter(),
    );
  }
}

class RadarPolygonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double maxRadius = math.min(size.width, size.height) / 2.3;
    int numFeatures = 10; // 10 Parameter sesuai kolom data excel/materi

    // Label 10 Parameter untuk ditaruh di ujung sudut
    List<String> labels = ['P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'P10'];

    // 1. MENGGAMBAR JARING LABA-LABA BACKGROUND (POLYGON SEGI-10)
    Paint gridPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Membuat 5 lapis jaring polygon (Skala tingkat nilai 20%, 40%, 60%, 80%, 100%)
    for (int i = 1; i <= 5; i++) {
      double currentRadius = maxRadius * (i / 5);
      Path gridPath = Path();
      
      for (int j = 0; j < numFeatures; j++) {
        double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
        double x = center.dx + currentRadius * math.cos(angle);
        double y = center.dy + currentRadius * math.sin(angle);
        
        if (j == 0) {
          gridPath.moveTo(x, y);
        } else {
          gridPath.lineTo(x, y);
        }
      }
      gridPath.close();
      canvas.drawPath(gridPath, gridPaint);
    }

    // 2. MENGGAMBAR GARIS JARI-JARI / AXIS TIAP PARAMETER
    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double x = center.dx + maxRadius * math.cos(angle);
      double y = center.dy + maxRadius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
      
      // Menggambar Text Label kecil di setiap ujung garis parameter
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      // Atur posisi teks sedikit melompat keluar dari ujung garis agar rapi
      double textX = center.dx + (maxRadius + 12) * math.cos(angle) - (textPainter.width / 2);
      double textY = center.dy + (maxRadius + 12) * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // 3. MENGGAMBAR AREA DATA MURID (POLYGON BERWARNA TRANSPARAN)
    // Angka acak/dummy pencapaian murid skala 0.0 sampai 1.0 untuk 10 parameter
    List<double> dataValues = [0.85, 0.60, 0.75, 0.90, 0.50, 0.70, 0.45, 0.80, 0.65, 0.55];

    Path dataPath = Path();
    List<Offset> dataPoints = [];

    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double currentRadius = maxRadius * dataValues[j];
      double x = center.dx + currentRadius * math.cos(angle);
      double y = center.dy + currentRadius * math.sin(angle);
      
      dataPoints.add(Offset(x, y));
      if (j == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    // Warnai isi jaring area nilai murid dengan warna merah transparan cerah
    Paint fillPaint = Paint()
      ..color = const Color(0xFFE91E63).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Gambar garis tepi jaring nilai murid agar tampak tegas
    Paint strokePaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(dataPath, strokePaint);

    // Beri titik bulat kecil di setiap koordinat nilai data murid
    Paint pointPaint = Paint()..color = const Color(0xFF880E4F);
    for (Offset point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
