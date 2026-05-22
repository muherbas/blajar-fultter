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
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
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
                    height: 220,
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

            // ==================== BARU: TABEL ANALISIS KOMPONEN UTAMA ====================
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
                    'MATRIKS EVALUASI BOXPLOT',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF10B981), // Emerald Green Elit
                      letterSpacing: 1.0
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 650, // Mengunci lebar tabel agar scannable via horizontal scroll di HP
                      child: Table(
                        border: TableBorder.all(color: const Color(0xFF334155), width: 1), // Slate 700 border
                        columnWidths: const {
                          0: FlexColumnWidth(1.2), // Komponen
                          1: FlexColumnWidth(1.3), // Makna Statistik
                          2: FlexColumnWidth(1.5), // Kekurangan
                          3: FlexColumnWidth(1.5), // Kelebihan
                          4: FlexColumnWidth(2.0), // Saran Dinamis
                        },
                        children: [
                          // HEADER TABEL
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                            children: [
                              _buildHeaderCell('KOMPONEN'),
                              _buildHeaderCell('MAKNA STATISTIK'),
                              _buildHeaderCell('KEKURANGAN'),
                              _buildHeaderCell('KELEBIHAN'),
                              _buildHeaderCell('SARAN DINAMIS'),
                            ],
                          ),
                          // DATA BARIS 1: STRENGTH
                          _buildDataRow(
                            'STRENGTH',
                            'Median 48, Outlier Atas (82)',
                            'Kekuatan dasar tim masih di bawah standar rata-rata global.',
                            'Ada satu murid yang memiliki bakat kekuatan ekstrem.',
                            'Fokus ke latihan beban fundamental (Hypertrophy) untuk menaikkan baseline tim.',
                          ),
                          // DATA BARIS 2: ENDURANCE
                          _buildDataRow(
                            'ENDURANCE',
                            'Box Seimbang, Outlier (88)',
                            'Distribusi lelah merata, fondasi aerobik belum merata.',
                            'Daya tahan puncak beberapa individu sangat tinggi.',
                            'Tambahkan sesi interval training intensitas rendah berdurasi panjang.',
                          ),
                          // DATA BARIS 3: SPEED
                          _buildDataRow(
                            'SPEED',
                            'Box Panjang (IQR Tinggi)',
                            'Kesenjangan kecepatan antar murid terlalu jauh (tidak konsisten).',
                            'Beberapa murid sudah memiliki kecepatan murni yang matang.',
                            'Kelompokkan latihan sprint berdasarkan klaster kecepatan agar efisien.',
                          ),
                          // DATA BARIS 4: COORD
                          _buildDataRow(
                            'COORD',
                            'Box Mampat / Sempit',
                            'Kemampuan motorik tim seragam namun stagnan di angka menengah.',
                            'Sangat konsisten, tidak ada murid yang tertinggal jauh.',
                            'Berikan variasi gerakan kompleks baru untuk memicu adaptasi saraf.',
                          ),
                          // DATA BARIS 5: FLEX
                          _buildDataRow(
                            'FLEX',
                            'Median Mendekati Q3',
                            'Sebagian kecil murid memiliki fleksibilitas sangat kaku.',
                            'Mayoritas tim memiliki kelenturan di atas rata-rata.',
                            'Berikan porsi peregangan (stretching) ekstra khusus bagi murid di IQR bawah.',
                          ),
                          // DATA BARIS 6: BALANCE
                          _buildDataRow(
                            'BALANCE',
                            'Median Mendekati Q1',
                            'Sebagian besar murid memiliki stabilitas yang buruk.',
                            'Batas atas pencapaian kestabilan tim cukup potensial.',
                            'Integrasikan latihan core stability (plank, bosu ball) di awal sesi.',
                          ),
                          // DATA BARIS 7: REACTION
                          _buildDataRow(
                            'REACTION',
                            'Whisker Bawah Panjang',
                            'Ada penurunan respons motorik drastis pada beberapa murid.',
                            'Kecepatan reaksi puncak (Q3) sudah sangat responsif.',
                            'Lakukan tes reaksi dalam kondisi segar (bukan di akhir sesi latihan).',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // ==================== CARD 3: RADAR SPIDER (KOMPONEN TURUNAN) ====================
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
                    height: 360, 
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

  // Fungsi pembantu untuk membuat Cell Header Tabel
  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF38BDF8),
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat Baris Data Tabel
  TableRow _buildDataRow(String comp, String stat, String minus, String plus, String advice) {
    return TableRow(
      children: [
        _buildDataCell(comp, isBold: true, textColor: const Color(0xFFF8FAFC)),
        _buildDataCell(stat, textColor: const Color(0xFF94A3B8)),
        _buildDataCell(minus, textColor: const Color(0xFFF43F5E)), // Merah soft untuk kekurangan
        _buildDataCell(plus, textColor: const Color(0xFF34D399)),  // Hijau soft untuk kelebihan
        _buildDataCell(advice, textColor: const Color(0xFFE2E8F0)), // Putih abu untuk saran
      ],
    );
  }

  // Fungsi pembantu untuk membuat isi Cell Data Tabel
  Widget _buildDataCell(String text, {bool isBold = false, required Color textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 8.5,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          height: 1.3,
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
  void drawValueText(Canvas canvas, Offset offset, String text, Color color) {
    TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.bold, color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..color = const Color(0xFF475569)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final Paint boxPaint = Paint()..color = const Color(0xFF0284C7)..style = PaintingStyle.fill;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    int dataCount = 7;
    double spacing = size.width / dataCount;

    List<List<double>> rawBoxData = [
      [82.0, 20.0, 35.0, 48.0, 60.0, 80.0], 
      [88.0, 25.0, 40.0, 52.0, 65.0, 82.0], 
      [0.0,  30.0, 45.0, 55.0, 70.0, 88.0], 
      [0.0,  18.0, 32.0, 45.0, 58.0, 76.0], 
      [0.0,  22.0, 38.0, 50.0, 62.0, 78.0], 
      [0.0,  12.0, 28.0, 40.0, 55.0, 72.0], 
      [90.0, 28.0, 42.0, 56.0, 68.0, 84.0], 
    ];

    for (int i = 0; i < dataCount; i++) {
      double x = (spacing * i) + (spacing / 2);
      var raw = rawBoxData[i];
      
      double outlierY = size.height - ((raw[0] / 100) * size.height);
      double bottomWhiskerY = size.height - ((raw[1] / 100) * size.height);
      double q1Y = size.height - ((raw[2] / 100) * size.height);
      double medianY = size.height - ((raw[3] / 100) * size.height);
      double q3Y = size.height - ((raw[4] / 100) * size.height);
      double topWhiskerY = size.height - ((raw[5] / 100) * size.height);
      double boxWidth = spacing * 0.35;

      if (raw[0] > 0) {
        canvas.drawCircle(Offset(x, outlierY), 2.5, Paint()..color = const Color(0xFF38BDF8));
        drawValueText(canvas, Offset(x + 5, outlierY - 4), raw[0].toStringAsFixed(0), const Color(0xFF38BDF8));
      }
      
      canvas.drawLine(Offset(x, q3Y), Offset(x, topWhiskerY), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, topWhiskerY), Offset(x + boxWidth/3, topWhiskerY), linePaint);
      drawValueText(canvas, Offset(x + boxWidth/2 + 2, topWhiskerY - 4), raw[5].toStringAsFixed(0), const Color(0xFF94A3B8));
      
      canvas.drawLine(Offset(x, q1Y), Offset(x, bottomWhiskerY), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, bottomWhiskerY), Offset(x + boxWidth/3, bottomWhiskerY), linePaint);
      drawValueText(canvas, Offset(x + boxWidth/2 + 2, bottomWhiskerY - 4), raw[1].toStringAsFixed(0), const Color(0xFF94A3B8));

      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3Y, x + boxWidth / 2, q1Y);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1);
      
      canvas.drawLine(Offset(x - boxWidth / 2, medianY), Offset(x + boxWidth / 2, medianY), Paint()..color = const Color(0xFFF8FAFC)..strokeWidth = 1.5);
      drawValueText(canvas, Offset(x + boxWidth/2 + 2, medianY - 4), raw[3].toStringAsFixed(0), const Color(0xFFF8FAFC));
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
    double maxRadius = math.min(size.width, size.height) / 2.8; 
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

    // 4. LAPISAN JARING B: DATA NILAI MURID & LABEL TEKS
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

    Paint pointPaint = Paint()..color = const Color(0xFFFFF1F2);
    for (int j = 0; j < studentPoints.length; j++) {
      Offset point = studentPoints[j];
      
      canvas.drawCircle(point, 3, pointPaint);
      canvas.drawCircle(point, 1.5, Paint()..color = const Color(0xFFE11D48));

      String displayScore = (studentValues[j] * 100).toStringAsFixed(0);

      TextPainter valuePainter = TextPainter(
        text: TextSpan(
          text: displayScore,
          style: const TextStyle(
            fontSize: 8.5, 
            fontWeight: FontWeight.w900, 
            color: Color(0xFFFFF1F2),
            backgroundColor: Color(0xFF1E293B),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double textX = point.dx + (6 * math.cos(angle)) - (valuePainter.width / 2);
      double textY = point.dy + (6 * math.sin(angle)) - (valuePainter.height / 2);
      
      valuePainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
