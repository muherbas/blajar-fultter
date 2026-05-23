import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Rute utama - sesuaikan dengan halaman kamu yang udah ada
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(), // Dashboard tetap
        '/page2': (context) => const Page2(),    // Halaman 2 tetap
        '/page3': (context) => const Page3(),    // Halaman 3 tetap
        '/page4': (context) => const Page4(),    // Halaman 4 tetap
        '/page5': (context) => const Page5(),    // Halaman 5 tetap
        // 2 Halaman baru untuk fitur input
        '/pushup-matrix': (context) => const PushUpMatrixPage(),
        '/latihan-filter': (context) => const LatihanFilterPage(),
      },
    );
  }
}

// ========== HALAMAN LAMA KAMU - JANGAN DIUBAH ==========
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/pushup-matrix'),
              child: const Text('Fitur 1: Matrix 17 Push Up'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/latihan-filter'),
              child: const Text('Fitur 2: Filter Latihan by Klasifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Page 2')));
}

class Page3 extends StatelessWidget {
  const Page3({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Page 3')));
}

class Page4 extends StatelessWidget {
  const Page4({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Page 4')));
}

class Page5 extends StatelessWidget {
  const Page5({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Page 5')));
}

// ========== FITUR 1: INPUT LATIHAN -> 17 MACAM PUSH UP ==========
class PushUpMatrixPage extends StatefulWidget {
  const PushUpMatrixPage({super.key});
  @override
  State<PushUpMatrixPage> createState() => _PushUpMatrixPageState();
}

class _PushUpMatrixPageState extends State<PushUpMatrixPage> {
  final TextEditingController _latihanController = TextEditingController();
  List<PushUpData> _hasilMatrix = [];
  bool _isLoading = false;

  // Database 17 klasifikasi kemampuan push up
  final List<PushUpData> _databasePushUp = [
    PushUpData('1. Kekuatan Dasar', 'Wall Push Up', 'Pemula', 
      'Berdiri hadap tembok, tangan lurus ke tembok', 
      'Cocok untuk pemulihan cedera atau lansia', 
      '1. Tempel telapak tangan di tembok setinggi dada\n2. Tekuk siku mendekati tembok\n3. Dorong kembali'),
    PushUpData('2. Stabilisasi Bahu', 'Scapular Push Up', 'Pemula', 
      'Fokus gerak tulang belikat saja', 
      'Latih stabilitas scapula sebelum push up normal', 
      '1. Posisi plank\n2. Tanpa tekuk siku, dorong punggung atas ke atas\n3. Turunkan dengan menarik scapula'),
    PushUpData('3. Kekuatan Inti', 'Knee Push Up', 'Pemula', 
      'Push up dengan lutut sebagai tumpuan', 
      'Progress setelah wall push up', 
      '1. Posisi plank dengan lutut napak\n2. Badan lurus dari kepala ke lutut\n3. Turun-naik dengan kontrol'),
    PushUpData('4. Koordinasi', 'Incline Push Up', 'Pemula-Menengah', 
      'Tangan di bangku/tempat lebih tinggi', 
      'Kurangi beban dibanding push up lantai', 
      '1. Tangan di bangku\n2. Kaki lurus ke belakang\n3. Turunkan dada ke bangku'),
    PushUpData('5. Daya Tahan Otot', 'Standard Push Up', 'Menengah', 
      'Push up klasik lantai', 
      'Base line untuk ukur kekuatan upper body', 
      '1. Plank tangan lurus\n2. Turun sampai siku 90°\n3. Dorong sampai lengan lurus'),
    PushUpData('6. Power', 'Clap Push Up', 'Menengah-Lanjut', 
      'Push up eksplosif + tepuk tangan', 
      'Latih power dan fast twitch muscle', 
      '1. Dari posisi bawah dorong sekuatnya\n2. Tepuk tangan di udara\n3. Landing dengan siku soft'),
    PushUpData('7. Keseimbangan Unilateral', 'Archer Push Up', 'Lanjut', 
      'Satu tangan lurus ke samping saat turun', 
      'Transisi menuju one arm push up', 
      '1. Posisi lebar\n2. Saat turun, geser beban ke satu sisi\n3. Lengan satunya lurus'),
    PushUpData('8. Core Anterior', 'Pike Push Up', 'Menengah', 
      'Posisi V terbalik, fokus bahu', 
      'Progress menuju handstand push up', 
      '1. Posisi downward dog\n2. Tekuk siku, kepala menuju lantai\n3. Dorong ke atas'),
    PushUpData('9. Core Posterior', 'Reverse Hand Push Up', 'Lanjut', 
      'Telapak tangan menghadap ke kaki', 
      'Latih rotator cuff & posterior chain', 
      '1. Posisi push up, putar telapak ke belakang\n2. Turun dengan kontrol ekstra'),
    PushUpData('10. Pelvic Floor', 'Hollow Body Push Up', 'Lanjut', 
      'Jaga hollow position selama push up', 
      'Integrasi core + pelvic floor stability', 
      '1. Plank dengan PPT + ribs down\n2. Pertahankan hollow saat turun-naik'),
    PushUpData('11. Mobilitas Pergelangan', 'Fingertip Push Up', 'Lanjut', 
      'Tumpuan di ujung jari', 
      'Kuatkan jari & forearm', 
      '1. Posisi push up normal\n2. Angkat telapak, tumpu di 10 jari\n3. Lakukan perlahan'),
    PushUpData('12. Kekuatan Cengkeram', 'Knuckle Push Up', 'Menengah', 
      'Tumpuan di kepalan tangan', 
      'Kuatkan pergelangan + stabilitas', 
      '1. Kepal tangan di lantai\n2. Pergelangan lurus\n3. Push up normal'),
    PushUpData('13. Kontrol Eksentrik', 'Slow Negative Push Up', 'Semua Level', 
      'Turun 5 detik, naik 1 detik', 
      'Bangun kekuatan dengan time under tension', 
      '1. Dari atas turun hitung 5 detik\n2. Di bawah pause 1 detik\n3. Naik eksplosif'),
    PushUpData('14. Stabilitas Rotasi', 'T-Push Up', 'Menengah', 
      'Push up + rotasi ke T-pose', 
      'Latih core anti-rotasi + bahu', 
      '1. Push up 1x\n2. Rotasi buka tangan ke atas bentuk T\n3. Balik, ganti sisi'),
    PushUpData('15. Plyometric', 'Superman Push Up', 'Expert', 
      'Tangan dan kaki terbang bersamaan', 
      'Power maksimum seluruh badan', 
      '1. Dari bawah ledakkan tubuh\n2. Tangan lurus depan, kaki lurus belakang\n3. Landing soft'),
    PushUpData('16. Ketahanan Tendon', 'Pseudo Planche Push Up', 'Expert', 
      'Tangan di pinggang, badan condong depan', 
      'Progress planche, beban bahu tinggi', 
      '1. Putar jari ke samping/belakang\n2. Condongkan badan ke depan\n3. Push up dengan lean'),
    PushUpData('17. Unilateral Maksimal', 'One Arm Push Up', 'Expert', 
      'Satu tangan push up', 
      'Puncak kekuatan unilateral + core anti-rotasi', 
      '1. Kaki lebar untuk stabil\n2. Satu tangan di belakang punggung\n3. Turun-naik tanpa rotasi badan'),
  ];

  void _generateMatrix() {
    if (_latihanController.text.toLowerCase().contains('push')) {
      setState(() {
        _isLoading = true;
        _hasilMatrix = [];
      });
      // Simulasi "online AI" - di real app ini ganti dengan API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _hasilMatrix = _databasePushUp;
          _isLoading = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Input harus mengandung kata "push up"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matrix 17 Klasifikasi Push Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _latihanController,
              decoration: InputDecoration(
                labelText: 'Input Latihan',
                hintText: 'Contoh: push up',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _generateMatrix,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_hasilMatrix.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Klasifikasi')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Level')),
                      DataColumn(label: Text('Penjelasan')),
                      DataColumn(label: Text('Saran')),
                      DataColumn(label: Text('Cara')),
                    ],
                    rows: _hasilMatrix.map((data) {
                      return DataRow(cells: [
                        DataCell(SizedBox(width: 120, child: Text(data.klasifikasi))),
                        DataCell(Text(data.nama)),
                        DataCell(Text(data.level)),
                        DataCell(SizedBox(width: 200, child: Text(data.penjelasan))),
                        DataCell(SizedBox(width: 200, child: Text(data.saran))),
                        DataCell(SizedBox(width: 250, child: Text(data.cara))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ========== FITUR 2: FILTER 3 OPSI -> TABEL GERAKAN ==========
class LatihanFilterPage extends StatefulWidget {
  const LatihanFilterPage({super.key});
  @override
  State<LatihanFilterPage> createState() => _LatihanFilterPageState();
}

class _LatihanFilterPageState extends State<LatihanFilterPage> {
  String? _klasifikasi;
  String? _tipeBeban;
  String? _bagianTubuh;
  List<GerakanData> _hasilFilter = [];

  final List<String> _listKlasifikasi = [
    '1. Kekuatan Dasar', '2. Stabilisasi Bahu', '3. Kekuatan Inti',
    '4. Koordinasi', '5. Daya Tahan Otot', '6. Power', '7. Keseimbangan Unilateral',
    '8. Core Anterior', '9. Core Posterior', '10. Pelvic Floor', '11. Mobilitas Pergelangan',
    '12. Kekuatan Cengkeram', '13. Kontrol Eksentrik', '14. Stabilitas Rotasi',
    '15. Plyometric', '16. Ketahanan Tendon', '17. Unilateral Maksimal'
  ];

  final List<GerakanData> _databaseGerakan = [
    // Contoh data: Klasifikasi, Tipe, Bagian, Nama, Penjelasan, Saran, Cara
    GerakanData('5. Daya Tahan Otot', 'Repetisi', 'Tangan', 'Diamond Push Up', 
      'Push up dengan tangan bentuk diamond', 'Target triceps & dada dalam', 
      '1. Telunjuk & jempol ketemu bentuk diamond\n2. Siku mepet badan\n3. Turun-naik kontrol'),
    GerakanData('10. Pelvic Floor', 'Waktu', 'Core', 'Dead Bug Hold', 
      'Latih pelvic floor + core anterior', 'Jaga lower back nempel lantai', 
      '1. Tidur telentang\n2. Angkat tangan & kaki 90°\n3. Turunkan tangan-kaki berlawanan 30dtk'),
    GerakanData('8. Core Anterior', 'Repetisi', 'Core', 'Hollow Rock', 
      'Roll depan-belakang posisi hollow', 'Jangan pake momentum', 
      '1. Posisi hollow body\n2. Ayun pelan depan-belakang\n3. 12-15 reps'),
    GerakanData('9. Core Posterior', 'Waktu', 'Core', 'Reverse Plank', 
      'Plank telentang tumpu tumit-tangan', 'Squeeze glute aktifkan posterior', 
      '1. Duduk kaki lurus\n2. Tangan di belakang\n3. Angkat pinggul tahan 30-45dtk'),
    GerakanData('17. Unilateral Maksimal', 'Repetisi', 'Kaki', 'Pistol Squat', 
      'Squat satu kaki', 'Mulai dengan bantuan TRX/kursi', 
      '1. Satu kaki lurus depan\n2. Turun 1 kaki sampai paha sejajar\n3. Dorong naik'),
  ];

  void _filterData() {
    if (_klasifikasi == null || _tipeBeban == null || _bagianTubuh == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih semua opsi dulu')),
      );
      return;
    }
    setState(() {
      _hasilFilter = _databaseGerakan.where((g) =>
        g.klasifikasi == _klasifikasi &&
        g.tipeBeban == _tipeBeban &&
        g.bagianTubuh == _bagianTubuh
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Latihan 3 Opsi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '1. Pilih Klasifikasi Kemampuan'),
              value: _klasifikasi,
              items: _listKlasifikasi.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _klasifikasi = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '2. Pilih Repetisi / Waktu'),
              value: _tipeBeban,
              items: ['Repetisi', 'Waktu'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _tipeBeban = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '3. Pilih Tangan / Kaki / Core'),
              value: _bagianTubuh,
              items: ['Tangan', 'Kaki', 'Core'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _bagianTubuh = val),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _filterData, child: const Text('Tampilkan Tabel Rangkuman')),
            const SizedBox(height: 16),
            if (_hasilFilter.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nama Gerakan')),
                      DataColumn(label: Text('Penjelasan')),
                      DataColumn(label: Text('Saran')),
                      DataColumn(label: Text('Cara Melakukan')),
                    ],
                    rows: _hasilFilter.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data.nama)),
                        DataCell(SizedBox(width: 200, child: Text(data.penjelasan))),
                        DataCell(SizedBox(width: 200, child: Text(data.saran))),
                        DataCell(SizedBox(width: 250, child: Text(data.cara))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            if (_hasilFilter.isEmpty && _klasifikasi != null) 
              const Text('Tidak ada gerakan yang cocok dengan 3 filter tersebut'),
          ],
        ),
      ),
    );
  }
}

// ========== MODEL DATA ==========
class PushUpData {
  final String klasifikasi, nama, level, penjelasan, saran, cara;
  PushUpData(this.klasifikasi, this.nama, this.level, this.penjelasan, this.saran, this.cara);
}

class GerakanData {
  final String klasifikasi, tipeBeban, bagianTubuh, nama, penjelasan, saran, cara;
  GerakanData(this.klasifikasi, this.tipeBeban, this.bagianTubuh, this.nama, this.penjelasan, this.saran, this.cara);
}