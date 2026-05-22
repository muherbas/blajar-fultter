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
      title: 'Athlete Pro Dashboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        primaryColor: const Color(0xFF818CF8),
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
  final String kategori; // 1 dari 17 Klasifikasi Biomotorik
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

  // Pemetaan Volume latihan masuk ke 7 Komponen Utama Boxplot (Skala 0-100)
  List<List<double>> get calculatedBoxData {
    List<Map<String, String>> categories = [
      {'label': 'STRENGTH', 'key': 'STRENGTH'},
      {'label': 'ENDURANCE', 'key': 'ENDURANCE'},
      {'label': 'SPEED', 'key': 'SPEED'},
      {'label': 'COORD', 'key': 'COORDINATION'},
      {'label': 'FLEX', 'key': 'FLEXI'},
      {'label': 'BALANCE', 'key': 'BALANCE'},
      {'label': 'REACTION', 'key': 'REACTION'},
    ];

    return categories.map((cat) {
      var catLogs = logs.where((l) => 
        l.kategori.toUpperCase().contains(cat['key']!) || 
        (cat['label'] == 'STRENGTH' && l.kategori.toUpperCase().contains('POWER')) ||
        (cat['label'] == 'COORD' && (l.kategori.toUpperCase().contains('AGILITY') || l.kategori.toUpperCase().contains('ANTICIPATION') || l.kategori.toUpperCase().contains('MOBILITY')))
      ).toList();

      double avgVolume = catLogs.isEmpty 
          ? 25.0 
          : (catLogs.map((e) => e.volume).reduce((a, b) => a + b) / catLogs.length).clamp(15, 90).toDouble();
      
      // FIX: Semua kalkulasi angka wajib diakhiri .toDouble() secara eksplisit 
      // agar tidak dibaca sebagai tipe data 'num' oleh Compiler Dart
      return [
        (avgVolume > 80 ? avgVolume + 8.0 : 0.0).toDouble(), 
        (avgVolume - 15.0).clamp(5.0, 100.0).toDouble(), 
        (avgVolume - 6.0).clamp(10.0, 100.0).toDouble(), 
        avgVolume.toDouble(), 
        (avgVolume + 6.0).clamp(12.0, 95.0).toDouble(), 
        (avgVolume + 14.0).clamp(15.0, 100.0).toDouble()
      ];
    }).toList();
  }

  // Pemetaan rata-rata latihan masuk ke 10 Komponen Turunan Radar Spider (Skala 0.0 - 1.0)
  List<double> get calculatedRadarData {
    List<String> categories = [
      'MUSCULAR ENDURANCE', 'POWER', 'CORE STABILITY', 'DYNAMIC FLEXIBILITY', 'SPEED ENDURANCE',
      'REACTIVE SPEED / QUICKNESS', 'AGILITY', 'ANTICIPATION & SPATIAL AWARENESS', 'MOBILITY', 'OPEN/REACTIVE AGILITY'
    ];
    return categories.map((cat) {
      var catLogs = logs.where((l) => l.kategori.toUpperCase().contains(cat)).toList();
      if (catLogs.isEmpty) return 0.3; 
      double avgVolume = catLogs.map((e) => e.volume).reduce((a, b) => a + b) / catLogs.length;
      return (avgVolume / 50.0).clamp(0.2, 1.0).toDouble(); 
    }).toList();
  }
}

// ==================== MAIN STATE NAVIGATION HOLDER ====================

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 1; 
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

  Murid get _currentMurid {
    return _daftarMurid.firstWhere(
      (m) => m.id == _selectedMuridId, 
      orElse: () => _daftarMurid.first
    );
  }

  void _tambahLogLatihan(String idMurid, LogLatihan newLog) {
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
        onSave: _tambahLogLatihan,
        onSelectForDashboard: (id) {
          setState(() {
            _selectedMuridId = id;
          });
        },
      ),
      DaftarMuridPage(
        daftarMurid: _daftarMurid,
        selectedId: _selectedMuridId,
        onSelect: (id) => setState(() => _selectedMuridId = id),
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'DASHBOARD'),
          BottomNavigationBarItem(icon: Icon(Icons.note_add_outlined), activeIcon: Icon(Icons.note_add), label: 'INPUT LATIHAN'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'DAFTAR ATLET'),
        ],
      ),
    );
  }
}

// ==================== HALAMAN: INPUT LATIHAN ====================

class InputLatihanPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final Function(String, LogLatihan) onSave;
  final Function(String) onSelectForDashboard;

  const InputLatihanPage({
    Key? key, 
    required this.daftarMurid, 
    required this.onSave,
    required this.onSelectForDashboard,
  }) : super(key: key);

  @override
  State<InputLatihanPage> createState() => _InputLatihanPageState();
}

class _InputLatihanPageState extends State<InputLatihanPage> {
  String? _selectedId;
  DateTime _selectedDate = DateTime.now();
  String _kategoriBiomotor = "1. STRENGTH (KEKUATAN)";
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _latihanController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  
  String _searchQuery = "";

  final List<String> _kategoriList = [
    "1. STRENGTH (KEKUATAN)", 
    "2. ENDURANCE (DAYA TAHAN)", 
    "3. SPEED (KECEPATAN)", 
    "4. COORDINATION (KOORDINASI)", 
    "5. FLEXIBILITY (KELENTURAN)", 
    "6. BALANCE (KESEIMBANGAN)", 
    "7. REACTION TIME (WAKTU REAKSI)",
    "8. MUSCULAR ENDURANCE", 
    "9. POWER", 
    "10. CORE STABILITY", 
    "11. DYNAMIC FLEXIBILITY", 
    "12. SPEED ENDURANCE",
    "13. REACTIVE SPEED / QUICKNESS", 
    "14. AGILITY", 
    "15. ANTICIPATION & SPATIAL AWARENESS", 
    "16. MOBILITY", 
    "17. OPEN/REACTIVE AGILITY"
  ];

  String _formatTanggalAman(DateTime dt) {
    String day = dt.day.toString().padLeft(2, '0');
    String month = dt.month.toString().padLeft(2, '0');
    String year = dt.year.toString();
    return "$day/$month/$year";
  }

  int get currentVolume {
    int reps = int.tryParse(_repsController.text) ?? 0;
    int sets = int.tryParse(_setsController.text) ?? 0;
    return reps * sets;
  }

  @override
  Widget build(BuildContext context) {
    List<Murid> filteredMurid = widget.daftarMurid.where((m) {
      return m.nama.toLowerCase().contains(_searchQuery.toLowerCase()) || m.id.contains(_searchQuery);
    }).toList();

    Murid? activeMuridData = _selectedId != null 
        ? widget.daftarMurid.firstWhere((m) => m.id == _selectedId) 
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: Text(
              'Input Latihan Kuantitatif (Reps)',
              style: TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: '🔍 Ketik untuk cari nama murid...',
              hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF38BDF8)), borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _selectedId,
            hint: const Text("Pilih ID Murid", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            decoration: _buildInputDecoration("Pilih Murid"),
            dropdownColor: const Color(0xFF1E293B),
            items: filteredMurid.map((m) => DropdownMenuItem(
              value: m.id,
              child: Text("${m.nama} (ID-${m.id})", style: const TextStyle(fontSize: 13)),
            )).toList(),
            onChanged: (v) {
              setState(() {
                _selectedId = v;
              });
              if (v != null) widget.onSelectForDashboard(v); 
            },
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                builder: (context, child) {
                  return Theme(data: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF1E293B)), child: child!);
                }
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: InputDecorator(
              decoration: _buildInputDecoration("Tanggal Pelaksanaan Latihan"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTanggalAman(_selectedDate), style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const Icon(Icons.calendar_month, color: Color(0xFF38BDF8), size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _latihanController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration("Nama Jenis Latihan").copyWith(hintText: 'Contoh: Push Up / Kicks'),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _kategoriBiomotor,
            decoration: _buildInputDecoration("Opsi Klasifikasi Biomotorik"),
            dropdownColor: const Color(0xFF1E293B),
            items: _kategoriList.map((k) => DropdownMenuItem(
              value: k,
              child: Text(k, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            )).toList(),
            onChanged: (v) => setState(() => _kategoriBiomotor = v!),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _buildInputDecoration("Jumlah Repetisi (Reps)"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _setsController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _buildInputDecoration("Jumlah Set"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6), 
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (_selectedId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih murid terlebih dahulu!'), backgroundColor: Colors.redAccent));
                  return;
                }
                if (_latihanController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama jenis latihan wajib diisi!'), backgroundColor: Colors.redAccent));
                  return;
                }

                widget.onSave(
                  _selectedId!,
                  LogLatihan(
                    tanggal: _selectedDate,
                    namaLatihan: _latihanController.text.trim(),
                    kategori: _kategoriBiomotor,
                    reps: int.tryParse(_repsController.text) ?? 0,
                    sets: int.tryParse(_setsController.text) ?? 0,
                  ),
                );

                _latihanController.clear();
                _repsController.clear();
                _setsController.clear();
                FocusScope.of(context).unfocus();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data Masuk ke Dashboard secara Real-Time!'), backgroundColor: Color(0xFF10B981)),
                );
              },
              child: const Text('SIMPAN DATA INPUT', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              cross CrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kalkulasi Real-time Terkini:", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.white)),
                const SizedBox(height: 12),
                _buildCalcRow("Skor Volume Terakhir (Reps × Set):", "${currentVolume} vol"),
                _buildCalcRow("Total Riwayat Entry (N):", "${activeMuridData?.logs.length ?? 0} sesi"),
                _buildCalcRow(
                  "Rata-rata Skor Kumulatif:", 
                  activeMuridData == null || activeMuridData.logs.isEmpty 
                      ? "0.0" 
                      : "${(activeMuridData.logs.map((e) => e.volume).reduce((a, b) => a + b) / activeMuridData.logs.length).toStringAsFixed(1)} vol"
                ),
              ],
            ),
          ),
          
          if (activeMuridData != null && activeMuridData.logs.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text("TIMELINE RIWAYAT LATIHAN (${activeMuridData.nama})", style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeMuridData.logs.length,
              itemBuilder: (context, idx) {
                final log = activeMuridData.logs.reversed.toList()[idx];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF1E293B))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.namaLatihan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text("${log.kategori} • ${_formatTanggalAman(log.tanggal)}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                        ],
                      ),
                      Text("${log.reps} x ${log.sets} (${log.volume} Vol)", style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                );
              },
            )
          ]
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 12, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF8B5CF6)), borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildCalcRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          Text(val, style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

// ==================== HALAMAN: DASHBOARD PERFORMANCE ====================

class DashboardAtletPage extends StatelessWidget {
  final Murid activeMurid;
  const DashboardAtletPage({Key? key, required this.activeMurid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
              child: Text(
                'DASHBOARD PERFORMANCE [${activeMurid.id} - ${activeMurid.nama}]',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8),
              ),
            ),
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KOMPONEN UTAMA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8))),
                  const SizedBox(height: 16),
                  SizedBox(height: 200, child: BoxplotChart(boxData: activeMurid.calculatedBoxData)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KOMPONEN TURUNAN (REAL-TIME)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFF43F5E))),
                  const SizedBox(height: 16),
                  SizedBox(height: 280, child: RadarSpiderChart(studentValues: activeMurid.calculatedRadarData)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HALAMAN: DAFTAR ATLET SELEKSI ====================

class DaftarMuridPage extends StatelessWidget {
  final List<Murid> daftarMurid;
  final String selectedId;
  final Function(String) onSelect;

  const DaftarMuridPage({
    Key? key, 
    required this.daftarMurid, 
    required this.selectedId, 
    required this.onSelect
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("Pilih Target Atlet Monitor", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarMurid.length,
        itemBuilder: (context, i) {
          final m = daftarMurid[i];
          final bool isSelected = m.id == selectedId;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: isSelected ? const Color(0xFF10B981) : const Color(0xFF0F172A), child: const Icon(Icons.person, color: Colors.white)),
              title: Text(m.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text("ID: ${m.id} • ${m.logs.length} Log Data Latihan", style: const TextStyle(fontSize: 11)),
              trailing: Radio<String>(
                value: m.id, 
                groupValue: selectedId, 
                activeColor: const Color(0xFF10B981),
                onChanged: (v) => onSelect(v!)
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== CUSTOM PAINTER GRAPH COMPONENTS ====================

class BoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  const BoxplotChart({Key? key, required this.boxData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ['STRENGTH', 'ENDURANCE', 'SPEED', 'COORD', 'FLEX', 'BALANCE', 'REACTION'];
    return Column(
      children: [
        Expanded(child: CustomPaint(size: Size.infinite, painter: BoxplotPainter(boxData: boxData))),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels.map((label) => SizedBox(
            width: 44,
            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 7.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
          )).toList(),
        ),
      ],
    );
  }
}

class BoxplotPainter extends CustomPainter {
  final List<List<double>> boxData;
  BoxplotPainter({required this.boxData});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..color = const Color(0xFF
