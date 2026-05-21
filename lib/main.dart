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
      title: 'Premium Athlete Dashboard',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Latar belakang gelap elit (Slate 900)
        fontFamily: 'Roboto',
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
          'ATHLETE PERFORMANCE DASHBOARD',
          style: TextStyle(
            color: Color(0xFFF8FAFC), 
            fontSize: 14, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.5
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B), // Slate 800
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // ==================== CARD 1: BOXPLOT (7 PARAMETER) ====================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Elegan dark card
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMPONENTS OF FITNESS (MAIN)',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF38BDF8), // Light Blue Accent
                      letterSpacing: 1.0
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    height: 200,
                    child: BoxplotChart(),
                  ),
                  const SizedBox(height: 16),
                  // Angka perbandingan ditaruh minimalis di pojok kanan bawah
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'GLOBAL TEAM AVERAGE',
                          style: TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '68.5',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFF8FAFC)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // ==================== CARD 2: RADAR SPIDER (10 PARAMETER) ====================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SPECIFIC ATHLETIC BIOMOTORIC (RADAR)',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFFF43F5E), // Rose Accent
                      letterSpacing: 1.0
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    height: 340, // Ruang ekstra agar teks perimeter tidak terpotong
                    child: RadarSpiderChart(),
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

// ==================== CODE IMPLEMENTASI BOXPLOT GRAPH ====================
class BoxplotChart extends StatelessWidget {
  const BoxplotChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sesuai request parameter Boxplot tunggal
    final List<String> labels = [
      'STRENGTH',
      'ENDURANCE',
      'SPEED',
      'COORD', // Disingkat sedikit agar pas di layar HP
      'FLEX',
      'BALANCE',
      'REACTION'
    ];
    
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: BoxplotPainter(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels.map((label) => SizedBox(
            width: 44,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
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
      ..color = const Color(0xFF475569) // Muted border
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Paint boxPaint = Paint()
      ..color = const Color(0xFF0284C7) // Elit Ocean Blue
      ..style = PaintingStyle.fill;

    // Baseline
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);

    int dataCount = 7;
    double spacing = size.width / dataCount;

    // Simulasi distribusi data Boxplot atlet
    List<List<double>> boxData = [
      [0.0, 0.20, 0.35, 0.48, 0.60, 0.80], // STRENGTH
      [0.15, 0.25, 0.40, 0.52, 0.65, 0.82], // ENDURANCE
      [0.0, 0.30, 0.45, 0.55, 0.70, 0.88], // SPEED
      [0.0, 0.18, 0.32, 0.45, 0.58, 0.76], // COORDINATION
      [0.0, 0.22, 0.38, 0.50, 0.62, 0.78], // FLEXIBILITY
      [0.0, 0.12, 0.28, 0.40, 0.55, 0.72], // BALANCE
      [0.20, 0.28, 0.42, 0.56, 0.68, 0.84], // REACTION TIME
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
      double boxWidth = spacing * 0.35; // Kotak dibuat lebih ramping agar elegan

      // Draw Outlier jika ada (> 0)
      if (data[0] > 0) {
        canvas.drawCircle(Offset(x, outlier), 2.5, Paint()..color = const Color(0xFF38BDF8));
      }
      
      // Kumis/Whisker Atas & Bawah
      canvas.drawLine(Offset(x, topWhisker), Offset(x, q3), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, topWhisker), Offset(x + boxWidth/3, topWhisker), linePaint);
      canvas.drawLine(Offset(x, q1), Offset(x, bottomWhisker), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, bottomWhisker), Offset(x + boxWidth/3, bottomWhisker), linePaint);

      // Kotak Utama (Q1 - Q3)
      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3, x + boxWidth / 2, q1);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1);

      // Garis Tengah Median (Warna kontras elit)
      canvas.drawLine(Offset(x - boxWidth / 2, median), Offset(x + boxWidth / 2, median), Paint()..color = const Color(0xFFF8FAFC)..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== CODE IMPLEMENTASI RADAR / SPIDER GRAPH ====================
class RadarSpiderChart extends StatelessWidget {
  const RadarSpiderChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: RadarSpiderPainter(),
    );
  }
}

class RadarSpiderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double maxRadius = math.min(size.width, size.height) / 2.7; // Radius disesuaikan agar ruang teks aman
    int numFeatures = 10;

    // Sesuai 10 Parameter Grafik Radar yang diminta
    List<String> labels = [
      'MUSCULAR END.',
      'POWER',
      'CORE STAB.',
      'DYN. FLEX',
      'SPEED END.',
      'REACTIVE SP.',
      'AGILITY',
      'ANTICIPATION',
      'MOBILITY',
      'REACT AGILITY'
    ];

    // 1. GRID JARING SPIDER BACKGROUND (POLYGON)
    Paint gridPaint = Paint()
      ..color = const Color(0xFF334155) // Slate 700 gelap halus
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Menggambar 4 tingkat ring jaring laba-laba
    for (int i = 1; i <= 4; i++) {
      double currentRadius = maxRadius * (i / 4);
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

    // 2. DRAW AXIS LINES & TEXT LABELS
    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double x = center.dx + maxRadius * math.cos(angle);
      double y = center.dy + maxRadius * math.sin(angle);
      
      canvas.drawLine(center, Offset(x, y), gridPaint);
      
      // Gambar Teks Parameter mengelilingi sudut jaring
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8), letterSpacing: 0.3),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      // Kalkulasi offset penempatan teks agar presisi di luar ujung sudut jaring
      double textX = center.dx + (maxRadius + 14) * math.cos(angle) - (textPainter.width / 2);
      double textY = center.dy + (maxRadius + 10) * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // 3. DRAW DATA ATHLETE POLYGON (DATA AREA SKOR)
    // Nilai dummy capaian latihan murid (skala 0.0 sampai 1.0)
    List<double> dataValues = [0.80, 0.65, 0.85, 0.50, 0.70, 0.90, 0.75, 0.60, 0.80, 0.55];

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

    // Isian warna dalam jaring (Neon Crimson Transparan)
    Paint fillPaint = Paint()
      ..color = const Color(0xFFF43F5E).withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Garis tepi area jaring nilai atlet
    Paint strokePaint = Paint()
      ..color = const Color(0xFFF43F5E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(dataPath, strokePaint);

    // Titik sendi kecil di tiap parameter nilai
    Paint pointPaint = Paint()..color = const Color(0xFFFFF1F2);
    for (Offset point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint);
      canvas.drawCircle(point, 1.5, Paint()..color = const Color(0xFFE11D48));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}