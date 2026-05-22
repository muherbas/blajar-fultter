import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Athlete Pro Dashboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        primaryColor: const Color(0xFF6366F1),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationHolder(),
    );
  }
}

// ==================== MODELS & DATA STRUCTURE ====================

class LogLatihan {
  final DateTime tanggal;
  final String namaLatihan;
  final String kategori; // Salah satu dari 17 kategori biomotorik
  final int reps;
  final int sets;

  LogLatihan({
    required this.tanggal,
    required this.namaLatihan,
    required this.kategori,
    required this.reps,
    required this.sets,
  });

  int get volume => reps * sets;
}

class Murid {
  final String id;
  final String nama;
  List<LogLatihan> logs;

  Murid({required this.id, required this.nama, required this.logs});

  // Kalkulasi data untuk Boxplot (7 Komponen Utama)
  // Mengambil rata-rata volume latihan per kategori (skala 0-100)
  List<List<double>> get calculatedBoxData {
    List<String> categories = ['Strength', 'Endurance', 'Speed', 'Coordination', 'Flexibility', 'Balance', 'Reaction Time'];
    return categories.map((cat) {
      var catLogs = logs.where((l) => l.kategori.contains(cat.toUpperCase())).toList();
      double avgVolume = catLogs.isEmpty ? 40.0 : (catLogs.map((e) => e.volume).reduce((a, b) => a + b) / catLogs.length).clamp(0, 100).toDouble();
      // Dummy sebaran boxplot berdasarkan volume rata-rata
      return [avgVolume + 15, avgVolume - 20, avgVolume - 10, avgVolume, avgVolume + 10, avgVolume + 20];
    }).toList();
  }

  // Kalkulasi data untuk Radar (10 Komponen Turunan)
  List<double> get calculatedRadarData {
    List<String> categories = [
      'MUSCULAR ENDURANCE', 'POWER', 'CORE STABILITY', 'DYNAMIC FLEXIBILITY', 'SPEED ENDURANCE',
      'REACTIVE SPEED', 'AGILITY', 'ANTICIPATION', 'MOBILITY', 'REACTIVE AGILITY'
    ];
    return categories.map((cat) {
      var catLogs = logs.where((l) => l.kategori == cat).toList();
      if (catLogs.isEmpty) return 0.5;
      double score = (catLogs.map((e) => e.volume).reduce((a, b) => a + b) / (catLogs.length * 50)).clamp(0.1, 1.0);
      return score;
    }).toList();
  }
}

// ==================== MAIN NAVIGATION HOLDER ====================

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;
  String _selectedMuridId = "001";
  
  late List<Murid> _daftarMurid;

  @override
  void initState() {
    super.initState();
    _daftarMurid = [
      Murid(id: "001", nama: "BUDI SANTOSO", logs: []),
      Murid(id: "100", nama: "RURI", logs: []),
    ];
  }

  Murid get _currentMurid => _daftarMurid.firstWhere((m) => m.id == _selectedMuridId, orElse: () => _daftarMurid.first);

  void _updateData(String idMurid, LogLatihan newLog) {
    setState(() {
      _daftarMurid.firstWhere((m) => m.id == idMurid).logs.add(newLog);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardAtletPage(activeMurid: _currentMurid),
      InputLatihanPage(
        daftarMurid: _daftarMurid,
        onSave: _updateData,
      ),
      DaftarMuridPage(
        daftarMurid: _daftarMurid,
        selectedId: _selectedMuridId,
        onSelect: (id) => setState(() => _selectedMuridId = id),
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF818CF8),
        unselectedItemColor: const Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Input'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Daftar'),
        ],
      ),
    );
  }
}

// ==================== PAGE 3: INPUT LATIHAN (NEW) ====================

class InputLatihanPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final Function(String, LogLatihan) onSave;

  const InputLatihanPage({Key? key, required this.daftarMurid, required this.onSave}) : super(key: key);

  @override
  State<InputLatihanPage> createState() => _InputLatihanPageState();
}

class _InputLatihanPageState extends State<InputLatihanPage> {
  String? selectedMuridId;
  DateTime selectedDate = DateTime.now();
  String kategoriBiomotor = "1. Strength (Kekuatan)";
  final TextEditingController _latihanController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  final List<String> _kategoriList = [
    "1. Strength (Kekuatan)", "2. Endurance (Daya Tahan)", "3. Speed (Kecepatan)",
    "4. Coordination (Koordinasi)", "5. Flexibility (Kelenturan)", "6. Balance (Keseimbangan)",
    "7. Reaction Time (Waktu Reaksi)", "MUSCULAR ENDURANCE", "POWER", "CORE STABILITY",
    "DYNAMIC FLEXIBILITY", "SPEED ENDURANCE", "REACTIVE SPEED", "AGILITY",
    "ANTICIPATION & SPATIAL AWARENESS", "MOBILITY", "OPEN/REACTIVE AGILITY"
  ];

  int get currentVolume {
    int r = int.tryParse(_repsController.text) ?? 0;
    int s = int.tryParse(_setsController.text) ?? 0;
    return r * s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Latihan Kuantitatif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Pilih Murid
            _buildDropdownMurid(),
            const SizedBox(height: 15),
            // Tanggal
            _buildDatePicker(),
            const SizedBox(height: 15),
            // Nama Latihan
            _buildTextField("Nama Jenis Latihan", _latihanController, "Contoh: Push Up"),
            const SizedBox(height: 15),
            // Klasifikasi
            _buildDropdownKategori(),
            const SizedBox(height: 15),
            // Reps & Sets
            Row(
              children: [
                Expanded(child: _buildTextField("Jumlah Repetisi", _repsController, "Contoh: 15", isNumber: true)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("Jumlah Set", _setsController, "Contoh: 3", isNumber: true)),
              ],
            ),
            const SizedBox(height: 30),
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (selectedMuridId == null || _latihanController.text.isEmpty) return;
                  widget.onSave(selectedMuridId!, LogLatihan(
                    tanggal: selectedDate,
                    namaLatihan: _latihanController.text,
                    kategori: kategoriBiomotor.toUpperCase(),
                    reps: int.tryParse(_repsController.text) ?? 0,
                    sets: int.tryParse(_setsController.text) ?? 0,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Berhasil Disimpan!'), backgroundColor: Colors.green));
                },
                child: const Text('SIMPAN DATA INPUT', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 25),
            // Kalkulasi Real-time
            _buildRealtimeCalc(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownMurid() {
    return DropdownButtonFormField<String>(
      decoration: _inputDeco("Pilih Murid"),
      dropdownColor: const Color(0xFF1E293B),
      items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text("${m.nama} (ID-${m.id})"))).toList(),
      onChanged: (v) => setState(() => selectedMuridId = v),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
        if (picked != null) setState(() => selectedDate = picked);
      },
      child: InputDecorator(decoration: _inputDeco("Tanggal Pelaksanaan"), child: Text(DateFormat('dd/MM/yyyy').format(selectedDate))),
    );
  }

  Widget _buildDropdownKategori() {
    return DropdownButtonFormField<String>(
      value: kategoriBiomotor,
      decoration: _inputDeco("Opsi Klasifikasi Biomotorik"),
      dropdownColor: const Color(0xFF1E293B),
      items: _kategoriList.map((k) => DropdownMenuItem(value: k, child: Text(k, style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: (v) => setState(() => kategoriBiomotor = v!),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, String hint, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: (_) => setState(() {}),
      decoration: _inputDeco(label).copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF818CF8), fontSize: 12),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF818CF8)), borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildRealtimeCalc() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Kalkulasi Real-time Terkini:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
          const Divider(color: Colors.white12),
          _rowCalc("Skor Terakhir (Reps × Set):", currentVolume.toString()),
          _rowCalc("Rata-rata Skor Kumulatif:", (currentVolume / 2).toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _rowCalc(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 12, color: Colors.white54)), Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))]),
    );
  }
}

// ==================== DASHBOARD & PAINTERS (CONNECTED) ====================

class DashboardAtletPage extends StatelessWidget {
  final Murid activeMurid;
  const DashboardAtletPage({Key? key, required this.activeMurid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DASHBOARD [${activeMurid.nama}]', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), centerTitle: true, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _cardWrapper("KOMPONEN UTAMA", BoxplotChart(boxData: activeMurid.calculatedBoxData), Color(0xFF38BDF8)),
            const SizedBox(height: 20),
            _cardWrapper("KOMPONEN TURUNAN", RadarSpiderChart(studentValues: activeMurid.calculatedRadarData), Color(0xFFF43F5E)),
          ],
        ),
      ),
    );
  }

  Widget _cardWrapper(String title, Widget chart, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accent)),
          const SizedBox(height: 20),
          SizedBox(height: 300, child: chart),
        ],
      ),
    );
  }
}

// ==================== DAFTAR MURID PAGE ====================

class DaftarMuridPage extends StatelessWidget {
  final List<Murid> daftarMurid;
  final String selectedId;
  final Function(String) onSelect;

  const DaftarMuridPage({Key? key, required this.daftarMurid, required this.selectedId, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Atlet")),
      body: ListView.builder(
        itemCount: daftarMurid.length,
        itemBuilder: (context, i) {
          final m = daftarMurid[i];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(m.nama),
            subtitle: Text("ID: ${m.id} | Log: ${m.logs.length}"),
            trailing: Radio<String>(value: m.id, groupValue: selectedId, onChanged: (v) => onSelect(v!)),
          );
        },
      ),
    );
  }
}

// ==================== PAINTERS ====================

class BoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  const BoxplotChart({Key? key, required this.boxData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: BoxplotPainter(boxData: boxData));
  }
}

class BoxplotPainter extends CustomPainter {
  final List<List<double>> boxData;
  BoxplotPainter({required this.boxData});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..color = Colors.white24..strokeWidth = 1;
    final Paint boxPaint = Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.fill;
    double spacing = size.width / 7;

    for (int i = 0; i < 7; i++) {
      double x = (spacing * i) + (spacing / 2);
      var d = boxData[i];
      double median = size.height - (d[3] * size.height / 100);
      double q1 = size.height - (d[2] * size.height / 100);
      double q3 = size.height - (d[4] * size.height / 100);
      
      canvas.drawRect(Rect.fromLTRB(x - 10, q3, x + 10, q1), boxPaint);
      canvas.drawLine(Offset(x - 10, median), Offset(x + 10, median), Paint()..color = Colors.white..strokeWidth = 2);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

class RadarSpiderChart extends StatelessWidget {
  final List<double> studentValues;
  const RadarSpiderChart({Key? key, required this.studentValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: RadarPainter(values: studentValues));
  }
}

class RadarPainter extends CustomPainter {
  final List<double> values;
  RadarPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 3;
    Paint p = Paint()..color = const Color(0xFFF43F5E)..style = PaintingStyle.stroke..strokeWidth = 2;
    
    Path path = Path();
    for (int i = 0; i < 10; i++) {
      double angle = (i * 2 * math.pi / 10) - (math.pi / 2);
      double val = values[i] * radius;
      double x = center.dx + val * math.cos(angle);
      double y = center.dy + val * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
    canvas.drawPath(path, Paint()..color = const Color(0xFFF43F5E).withOpacity(0.2)..style = PaintingStyle.fill);
  }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}
