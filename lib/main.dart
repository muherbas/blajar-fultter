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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: Colors.cyan,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationHolder(),
    );
  }
}

// ========================================================
// MODEL DATA & DATABASE LOKAL (KOSONG DI AWAL)
// ========================================================
class Murid {
  final String id;
  final String nama;
  final List<double> radarData; 
  final List<Map<String, dynamic>> riwayatReps;
  final List<Map<String, dynamic>> riwayatWaktu;

  Murid({
    required this.id,
    required this.nama,
    required this.radarData,
    required this.riwayatReps,
    required this.riwayatWaktu,
  });
}

const List<String> kDaftarKlasifikasiLatihan = [
  "STRENGTH", "ENDURANCE", "SPEED", "COORDINATION", "FLEXIBILITY", "BALANCE", "REACTION TIME",
  "MUSCULAR ENDURANCE", "POWER", "CORE STABILITY", "DYNAMIC FLEXIBILITY", "SPEED ENDURANCE",
  "REACTIVE SPEED / QUICKNESS", "AGILITY", "ANTICIPATION & SPATIAL AWARENESS", "MOBILITY", "OPEN/REACTIVE AGILITY"
];

// DATA AWAL KOSONG (Tanpa Simulasi)
List<Murid> daftarMuridGlobal = [];
int indeksMuridTerpilih = 0;

// Fungsi Pengaman (Anti-Crash) jika data kosong
Murid get muridAktif {
  if (daftarMuridGlobal.isEmpty) {
    return Murid(
      id: "-", 
      nama: "BELUM ADA SISWA", 
      radarData: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
      riwayatReps: [], 
      riwayatWaktu: []
    );
  }
  if (indeksMuridTerpilih >= daftarMuridGlobal.length) {
    indeksMuridTerpilih = 0;
  }
  return daftarMuridGlobal[indeksMuridTerpilih];
}

// ========================================================
// HOLDER NAVIGASI UTAMA
// ========================================================
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);
  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;

  void perbaruiHalaman() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardPage(onRefresh: perbaruiHalaman),
      DaftarSiswaPage(onSelect: () {
        setState(() => _currentIndex = 0);
      }),
      InputRepsPage(onSaved: perbaruiHalaman),
      InputWaktuPage(onSaved: perbaruiHalaman),
      const AITrainingGeneratorPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex >= 4 ? 4 : _currentIndex,
        onTap: (index) {
          if (index == 4) {
            _showMoreBottomSheet();
          } else {
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Siswa'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Reps'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Waktu'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }

  void _showMoreBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.smart_toy, color: Colors.cyan),
              title: const Text("AI Training Generator", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text("Buat program latihan kustom otomatis", style: TextStyle(color: Colors.white38, fontSize: 12)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 4);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ========================================================
// HALAMAN 1: DASHBOARD UTAMA
// ========================================================
class DashboardPage extends StatelessWidget {
  final VoidCallback onRefresh;
  const DashboardPage({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Murid atlet = muridAktif;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium Athlete Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BorderRadius.circular(12).toBoxDecoration(const Color(0xFF1E293B)),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.cyan.withOpacity(0.2), radius: 24, child: Text(atlet.id == "-" ? "!" : atlet.id, style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 12))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(atlet.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(daftarMuridGlobal.isEmpty ? "Tambahkan siswa di menu 'Siswa'" : "Status Kondisi: Optimal / Siap Tanding", style: TextStyle(color: daftarMuridGlobal.isEmpty ? Colors.amber : Colors.greenAccent, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            const Text("Analisis Dimensi Fisik Atlet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 260,
                height: 260,
                padding: const EdgeInsets.all(10),
                child: CustomPaint(
                  painter: RadarChartCustomPainter(
                    activeRadar: atlet.radarData,
                    teamRadar: const [0.7, 0.7, 0.7, 0.7, 0.7, 0.7],
                  ),
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 12, height: 12, color: Colors.cyan),
                const SizedBox(width: 6),
                const Text("Fisik Atlet", style: TextStyle(fontSize: 12)),
                const SizedBox(width: 20),
                Container(width: 12, height: 12, color: Colors.amber),
                const SizedBox(width: 6),
                const Text("Rata-rata Tim", style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),

            const Text("Log Latihan Terakhir", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (atlet.riwayatReps.isEmpty && atlet.riwayatWaktu.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(16), child: Text("Belum ada log latihan.", style: TextStyle(color: Colors.white38))))
            else ...[
              ...atlet.riwayatReps.map((e) => ListTile(leading: const Icon(Icons.fitness_center, color: Colors.cyan), title: Text(e['latihan']), trailing: Text(e['skor'], style: const TextStyle(color: Colors.greenAccent)), subtitle: Text("Tanggal: ${e['tgl']}"))),
              ...atlet.riwayatWaktu.map((e) => ListTile(leading: const Icon(Icons.timer, color: Colors.amber), title: Text(e['latihan']), trailing: Text(e['skor'], style: const TextStyle(color: Colors.greenAccent)), subtitle: Text("Tanggal: ${e['tgl']}"))),
            ]
          ],
        ),
      ),
    );
  }
}

// PAINTER GRAFIK RADAR KUSTOM
class RadarChartCustomPainter extends CustomPainter {
  final List<double> activeRadar;
  final List<double> teamRadar;
  RadarChartCustomPainter({required this.activeRadar, required this.teamRadar});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2 * 0.85;
    const kDimensi = 6;
    const fitur = ["STR", "END", "SPD", "FLX", "BAL", "CRD"];

    final pGrid = Paint()..color = Colors.white10..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final pAxis = Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 1.0;

    for (int i = 1; i <= 4; i++) {
      double r = maxRadius * (i / 4);
      Path path = Path();
      for (int j = 0; j < kDimensi; j++) {
        double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
        Offset pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (j == 0) path.moveTo(pt.dx, pt.dy); else path.lineTo(pt.dx, pt.dy);
      }
      path.close();
      canvas.drawPath(path, pGrid);
    }

    for (int j = 0; j < kDimensi; j++) {
      double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
      Offset endPoint = Offset(center.dx + maxRadius * math.cos(angle), center.dy + maxRadius * math.sin(angle));
      canvas.drawLine(center, endPoint, pAxis);

      Offset labelPt = Offset(center.dx + (maxRadius + 14) * math.cos(angle) - 10, center.dy + (maxRadius + 14) * math.sin(angle) - 6);
      TextPainter(
        text: TextSpan(text: fitur[j], style: const TextStyle(color: Colors.white64, fontSize: 10, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout()..paint(canvas, labelPt);
    }

    final pAtletFill = Paint()..color = Colors.cyan.withOpacity(0.35)..style = PaintingStyle.fill;
    final pAtletStroke = Paint()..color = Colors.cyan..style = PaintingStyle.stroke..strokeWidth = 2.0;
    Path pathAtlet = Path();
    for (int j = 0; j < kDimensi; j++) {
      double val = j < activeRadar.length ? activeRadar[j] : 0.0;
      double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
      double r = maxRadius * val.clamp(0.0, 1.0);
      Offset pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (j == 0) pathAtlet.moveTo(pt.dx, pt.dy); else pathAtlet.lineTo(pt.dx, pt.dy);
    }
    pathAtlet.close();
    canvas.drawPath(pathAtlet, pAtletFill);
    canvas.drawPath(pathAtlet, pAtletStroke);

    final pTimStroke = Paint()..color = Colors.amber.withOpacity(0.7)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    Path pathTim = Path();
    for (int j = 0; j < kDimensi; j++) {
      double val = j < teamRadar.length ? teamRadar[j] : 0.0;
      double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
      double r = maxRadius * val.clamp(0.0, 1.0);
      Offset pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (j == 0) pathTim.moveTo(pt.dx, pt.dy); else pathTim.lineTo(pt.dx, pt.dy);
    }
    pathTim.close();
    canvas.drawPath(pathTim, pTimStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========================================================
// HALAMAN 2: DAFTAR SISWA (DENGAN TOMBOL TAMBAH)
// ========================================================
class DaftarSiswaPage extends StatefulWidget {
  final VoidCallback onSelect;
  const DaftarSiswaPage({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<DaftarSiswaPage> createState() => _DaftarSiswaPageState();
}

class _DaftarSiswaPageState extends State<DaftarSiswaPage> {
  final TextEditingController _namaController = TextEditingController();

  void _tambahSiswaBaru() {
    if (_namaController.text.trim().isEmpty) return;
    setState(() {
      String newId = "M-${(daftarMuridGlobal.length + 1).toString().padLeft(2, '0')}";
      daftarMuridGlobal.add(Murid(
        id: newId, 
        nama: _namaController.text.trim().toUpperCase(), 
        radarData: [0.3, 0.3, 0.3, 0.3, 0.3, 0.3], // Nilai dasar awal
        riwayatReps: [], 
        riwayatWaktu: []
      ));
      if (daftarMuridGlobal.length == 1) indeksMuridTerpilih = 0;
    });
    _namaController.clear();
    Navigator.pop(context);
  }

  void _tampilkanDialogTambah() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Daftar Siswa Baru", style: TextStyle(color: Colors.cyan)),
        content: TextField(
          controller: _namaController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: "Masukkan Nama Lengkap", hintStyle: TextStyle(color: Colors.white38)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.white54))),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan), onPressed: _tambahSiswaBaru, child: const Text("Simpan", style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Anggota / Siswa"), backgroundColor: const Color(0xFF1E293B)),
      body: daftarMuridGlobal.isEmpty 
          ? const Center(child: Text("Belum ada data siswa.\nTekan tombol + di bawah untuk menambah.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: daftarMuridGlobal.length,
              itemBuilder: (context, index) {
                Murid m = daftarMuridGlobal[index];
                bool isAktif = index == indeksMuridTerpilih;
                return Card(
                  color: isAktif ? const Color(0xFF0F2D3A) : const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isAktif ? Colors.cyan : Colors.transparent, width: 1)),
                  child: ListTile(
                    leading: Icon(Icons.person, color: isAktif ? Colors.cyan : Colors.white38),
                    title: Text(m.nama, style: TextStyle(fontWeight: FontWeight.bold, color: isAktif ? Colors.cyan : Colors.white)),
                    subtitle: Text("ID: ${m.id}"),
                    trailing: isAktif 
                      ? const Text("TERPILIH", style: TextStyle(color: Colors.cyan, fontSize: 11, fontWeight: FontWeight.bold))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF334155), padding: const EdgeInsets.symmetric(horizontal: 12)),
                          onPressed: () {
                            indeksMuridTerpilih = index;
                            widget.onSelect();
                          },
                          child: const Text("PILIH", style: TextStyle(fontSize: 11, color: Colors.white)),
                        ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: _tampilkanDialogTambah,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

// ========================================================
// HALAMAN 3: INPUT REPETISI (KUANTITATIF)
// ========================================================
class InputRepsPage extends StatefulWidget {
  final VoidCallback onSaved;
  const InputRepsPage({Key? key, required this.onSaved}) : super(key: key);
  @override
  State<InputRepsPage> createState() => _InputRepsPageState();
}

class _InputRepsPageState extends State<InputRepsPage> {
  final _inputController = TextEditingController();
  String _latihanDipilih = "Push Up";

  @override
  Widget build(BuildContext context) {
    Murid current = muridAktif;
    return Scaffold(
      appBar: AppBar(title: const Text("Input Data Kuantitatif"), backgroundColor: const Color(0xFF1E293B)),
      body: daftarMuridGlobal.isEmpty
        ? const Center(child: Text("Tambahkan siswa terlebih dahulu di menu 'Siswa'", style: TextStyle(color: Colors.white38)))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Atlet Aktif: ${current.nama}", style: const TextStyle(fontSize: 16, color: Colors.cyan, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _latihanDipilih,
                  items: ["Push Up", "Sit Up", "Back Up", "Squat Jump", "Hapkido Kick Reps"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _latihanDipilih = v!),
                  decoration: const InputDecoration(labelText: "Jenis Latihan Fisik", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Jumlah Repetisi (Reps)", hintText: "Contoh: 40", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    onPressed: () {
                      if (_inputController.text.isNotEmpty) {
                        setState(() {
                          current.riwayatReps.insert(0, {
                            "latihan": _latihanDipilih,
                            "skor": "${_inputController.text} reps",
                            "tgl": "HARI INI"
                          });
                        });
                        _inputController.clear();
                        widget.onSaved();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Repetisi Berhasil Ditambahkan!")));
                      }
                    },
                    child: const Text("SIMPAN DATA REPS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
    );
  }
}

// ========================================================
// HALAMAN 4: INPUT WAKTU (DURASI)
// ========================================================
class InputWaktuPage extends StatefulWidget {
  final VoidCallback onSaved;
  const InputWaktuPage({Key? key, required this.onSaved}) : super(key: key);
  @override
  State<InputWaktuPage> createState() => _InputWaktuPageState();
}

class _InputWaktuPageState extends State<InputWaktuPage> {
  final _menitController = TextEditingController();
  final _detikController = TextEditingController();
  String _latihanDipilih = "Plank";

  @override
  Widget build(BuildContext context) {
    Murid current = muridAktif;
    return Scaffold(
      appBar: AppBar(title: const Text("Input Data Durasi"), backgroundColor: const Color(0xFF1E293B)),
      body: daftarMuridGlobal.isEmpty
        ? const Center(child: Text("Tambahkan siswa terlebih dahulu di menu 'Siswa'", style: TextStyle(color: Colors.white38)))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Atlet Aktif: ${current.nama}", style: const TextStyle(fontSize: 16, color: Colors.amber, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _latihanDipilih,
                  items: ["Plank", "Horse Stance Hold", "Sparring Match", "Wall Sit", "Shadow Boxing"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _latihanDipilih = v!),
                  decoration: const InputDecoration(labelText: "Jenis Latihan Durasi", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _menitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Menit", hintText: "00", border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _detikController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Detik", hintText: "00", border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                      String m = _menitController.text.isEmpty ? "00" : _menitController.text.padLeft(2, '0');
                      String s = _detikController.text.isEmpty ? "00" : _detikController.text.padLeft(2, '0');
                      
                      if (m != "00" || s != "00") {
                        setState(() {
                          current.riwayatWaktu.insert(0, {
                            "latihan": _latihanDipilih,
                            "skor": "$m:$s",
                            "tgl": "HARI INI"
                          });
                        });
                        _menitController.clear();
                        _detikController.clear();
                        widget.onSaved();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Durasi Berhasil Ditambahkan!")));
                      }
                    },
                    child: const Text("SIMPAN DATA WAKTU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
    );
  }
}

// ========================================================
// HALAMAN 5 & 6: AI COACH GENERATOR PAGE
// ========================================================
class AITrainingGeneratorPage extends StatefulWidget {
  const AITrainingGeneratorPage({Key? key}) : super(key: key);
  @override
  State<AITrainingGeneratorPage> createState() => _AITrainingGeneratorPageState();
}

class _AITrainingGeneratorPageState extends State<AITrainingGeneratorPage> {
  String _selectedKlasifikasi = kDaftarKlasifikasiLatihan.first;
  String _selectedTipe = "Repetisi";
  String _selectedBagian = "Tangan";
  bool _sudahGenerate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Coach Generator"), backgroundColor: const Color(0xFF1E293B)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedKlasifikasi,
              items: kDaftarKlasifikasiLatihan.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (v) => setState(() => _selectedKlasifikasi = v!),
              decoration: const InputDecoration(labelText: "Klasifikasi Komponen", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTipe,
                    items: ["Repetisi", "Waktu"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _selectedTipe = v!),
                    decoration: const InputDecoration(labelText: "Tipe Target", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBagian,
                    items: ["Tangan", "Kaki", "Core (Anterior)", "Core (Posterior)", "Pelvic Floor"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _selectedBagian = v!),
                    decoration: const InputDecoration(labelText: "Fokus Anatomi", border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    _sudahGenerate = true;
                  });
                },
                child: const Text("GENERATE VIA AI COACH", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _sudahGenerate 
                ? ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Rekomendasi Program Latihan:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber)),
                            const Divider(color: Colors.white24),
                            Text("• Parameter Utama: $_selectedKlasifikasi", style: const TextStyle(fontSize: 12, height: 1.6)),
                            Text("• Zona Fokus Otot: $_selectedBagian via $_selectedTipe", style: const TextStyle(fontSize: 12, height: 1.6)),
                            const SizedBox(height: 12),
                            const Text("Daftar Menu Latihan Gerak:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.cyan)),
                            const SizedBox(height: 6),
                            Text(
                              _selectedBagian.contains("Core") || _selectedBagian == "Pelvic Floor"
                                  ? "1. Dynamic Plank Stability Shifts\n2. Bird-Dog Dynamic Holds\n3. Dead Bug Core Press\n4. Pelvic Bridge Iso-Hold"
                                  : _selectedBagian == "Tangan"
                                      ? "1. Plyo Diamond Push Drops\n2. Isometric Push-Hold Low Zone\n3. Hand Release Acceleration Explosions"
                                      : "1. Explosive Squat Jumps Matrix\n2. Lunge Matrix Rebound Shifts\n3. Calf Raise Rim Pulse Extensions",
                              style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : const Center(child: Text("Hasil tabel skema latihan otomatis akan muncul di sini setelah di-generate.", style: TextStyle(color: Colors.white38, fontSize: 12), textAlign: TextAlign.center)),
            ),
          ],
        ),
      ),
    );
  }
}

// EXTENSION DECORATION HELPER
extension BoxStyleExtension on BorderRadius {
  BoxDecoration toBoxDecoration(Color warna) {
    return BoxDecoration(color: warna, borderRadius: this);
  }
}
