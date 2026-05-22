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
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Latar belakang Slate 900
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
    const String idMurid = "001";
    const String namaMurid = "BUDI SANTOSO";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DASHBOARD PERFORMANCE [$idMurid - $namaMurid]',
          style: TextStyle(
            color: Color(0xFFF8FAFC), 
            fontSize: 13, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.2
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
            // ==================== CARD 1: BOXPLOT (KOMPONEN UTAMA) ====================
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
                    'KOMPONEN UTAMA',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF38BDF8),
                      letterSpacing: 1.0
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    height: 200,
                    child: BoxplotChart(),
                  ),
                  const SizedBox(height: 16),
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
            
            // ==================== CARD 2: RADAR SPIDER (KOMPONEN TURUNAN) ====================
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
                    'KOMPONEN TURUNAN',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFFF43F5E), 
                      letterSpacing: 1.0
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(width: 8, height: 8, color: const Color(0xFFF43F5E)),
                      const SizedBox(width: 4),
                      const Text('Murid', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(width: 8, height: 8, color: const Color(0xFF0EA5E9)),
                      const SizedBox(width: 4),
                      const Text('Tim Avg', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    height: 340, 
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

// ==================== IMPLEMENTASI GRAFIK BOXPLOT ====================
class BoxplotChart extends StatelessWidget {
  const BoxplotChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [
      'STRENGTH',
      'ENDURANCE',
      'SPEED',
      'COORD',
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
    final Paint linePaint = Paint()..color = const Color(0xFF475569)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final Paint boxPaint = Paint()..color = const Color(0xFF0284C7)..style = PaintingStyle.fill;

    // Garis dasar chart (X-Axis line) berada di paling bawah
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    int dataCount = 7;
    double spacing = size.width / dataCount;

    // Nilai data (0.0 sampai 1.0)
    // Format indeks: [outlier, bottomWhisker, q1, median, q3, topWhisker]
    List<List<double>> boxData = [
      [0.82, 0.20, 0.35, 0.48, 0.60, 0.80], 
      [0.88, 0.25, 0.40, 0.52, 0.65, 0.82], 
      [0.00, 0.30, 0.45, 0.55, 0.70, 0.88], 
      [0.00, 0.18, 0.32, 0.45, 0.58, 0.76], 
      [0.00, 0.22, 0.38, 0.50, 0.62, 0.78], 
      [0.00, 0.12, 0.28, 0.40, 0.55, 0.72], 
      [0.90, 0.28, 0.42, 0.56, 0.68, 0.84], 
    ];

    for (int i = 0; i < dataCount; i++) {
      double x = (spacing * i) + (spacing / 2);
      var data = boxData[i];
      
      // PERBAIKAN: Membalik titik koordinat Y agar 0 berada di bawah dan 1 di atas canvas
      double outlier = size.height - (data[0] * size.height);
      double bottomWhisker = size.height - (data[1] * size.height);
      double q1 = size.height - (data[2] * size.height);
      double median = size.height - (data[3] * size.height);
      double q3 = size.height - (data[4] * size.height);
      double topWhisker = size.height - (data[5] * size.height);
      double boxWidth = spacing * 0.35;

      // Gambar titik pencilan (outlier) jika nilainya > 0
      if (data[0] > 0) {
        canvas.drawCircle(Offset(x, outlier), 2.5, Paint()..color = const Color(0xFF38BDF8));
      }
      
      // Garis Whisker Atas (dari Q3 ke Top Whisker)
      canvas.drawLine(Offset(x, q3), Offset(x, topWhisker), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, topWhisker), Offset(x + boxWidth/3, topWhisker), linePaint);
      
      // Garis Whisker Bawah (dari Q1 ke Bottom Whisker)
      canvas.drawLine(Offset(x, q1), Offset(x, bottomWhisker), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, bottomWhisker), Offset(x + boxWidth/3, bottomWhisker), linePaint);

      // Gambar Kotak Boxplot (Rect dari Q3 ke Q1 secara visual koordinat inverted)
      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3, x + boxWidth / 2, q1);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1);
      
      // Garis Median di dalam kotak
      canvas.drawLine(Offset(x - boxWidth / 2, median), Offset(x + boxWidth / 2, median), Paint()..color = const Color(0xFFF8FAFC)..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== IMPLEMENTASI GRAFIK RADAR SPIDER ====================
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
    double maxRadius = math.min(size.width, size.height) / 2.7; 
    int numFeatures = 10;

    List<String> labels = [
      'MUSCULAR END.', 'POWER', 'CORE STAB.', 'DYN. FLEX', 'SPEED END.',
      'REACTIVE SP.', 'AGILITY', 'ANTICIPATION', 'MOBILITY', 'REACT AGILITY'
    ];

    // 1. GRID JARING SPIDER BACKGROUND
    Paint gridPaint = Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    for (int i = 1; i <= 4; i++) {
      double currentRadius = maxRadius * (i / 4);
      Path gridPath = Path();
      for (int j = 0; j < numFeatures; j++) {
        double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
        double x = center.dx + currentRadius * math.cos(angle);
        double y = center.dy + currentRadius * math.sin(angle);
        if (j == 0) gridPath.moveTo(x, y); else gridPath.lineTo(x, y);
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
      
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8), letterSpacing: 0.3),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      double textX = center.dx + (maxRadius + 14) * math.cos(angle) - (textPainter.width / 2);
      double textY = center.dy + (maxRadius + 10) * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // 3. LAPISAN JARING A: GLOBAL TEAM AVERAGE
    List<double> teamAvgValues = [0.65, 0.70, 0.60, 0.65, 0.68, 0.70, 0.62, 0.65, 0.70, 0.60];
    Path teamPath = Path();
    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double currentRadius = maxRadius * teamAvgValues[j];
      double x = center.dx + currentRadius * math.cos(angle);
      double y = center.dy + currentRadius * math.sin(angle);
      if (j == 0) teamPath.moveTo(x, y); else teamPath.lineTo(x, y);
    }
    teamPath.close();
    canvas.drawPath(teamPath, Paint()..color = const Color(0xFF0EA5E9).withOpacity(0.12)..style = PaintingStyle.fill);
    canvas.drawPath(teamPath, Paint()..color = const Color(0xFF0EA5E9).withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // 4. LAPISAN JARING B: DATA NILAI MURID
    List<double> studentValues = [0.80, 0.65, 0.85, 0.50, 0.70, 0.90, 0.75, 0.60, 0.80, 0.55];
    Path studentPath = Path();
    List<Offset> studentPoints = [];
    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double currentRadius = maxRadius * studentValues[j];
      double x = center.dx + currentRadius * math.cos(angle);
      double y = center.dy + currentRadius * math.sin(angle);
      studentPoints.add(Offset(x, y));
      if (j == 0) studentPath.moveTo(x, y); else studentPath.lineTo(x, y);
    }
    studentPath.close();
    canvas.drawPath(studentPath, Paint()..color = const Color(0xFFF43F5E).withOpacity(0.28)..style = PaintingStyle.fill);
    canvas.drawPath(studentPath, Paint()..color = const Color(0xFFF43F5E)..style = PaintingStyle.stroke..strokeWidth = 2.0);

    // Titik sudut nilai murid
    Paint pointPaint = Paint()..color = const Color(0xFFFFF1F2);
    for (Offset point in studentPoints) {
      canvas.drawCircle(point, 3, pointPaint);
      canvas.drawCircle(point, 1.5, Paint()..color = const Color(0xFFE11D48));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
