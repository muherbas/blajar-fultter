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
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationHolder(),
    );
  }
}

// Model Struktur Data Murid
class Murid {
  final String id;
  final String nama;
  final List<List<double>> boxData; // Index 0-6 untuk komponen biomotorik utama di Boxplot
  final List<double> radarData;
  
  // Riwayat latihan kuantitatif (Halaman 3)
  List<Map<String, dynamic>> riwayatLatihanKuantitatif;
  // Riwayat latihan durasi/waktu (Halaman 4)
  List<Map<String, dynamic>> riwayatLatihanDurasi;

  Murid({
    required this.id,
    required this.nama,
    required this.boxData,
    required this.radarData,
    List<Map<String, dynamic>>? riwayatLatihanKuantitatif,
    List<Map<String, dynamic>>? riwayatLatihanDurasi,
  })  : this.riwayatLatihanKuantitatif = riwayatLatihanKuantitatif ?? [],
        this.riwayatLatihanDurasi = riwayatLatihanDurasi ?? [];
}

// Pengelola State Navigasi Utama (4 Halaman)
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 1; // Default terbuka langsung di halaman "DAFTAR"
  String _selectedMuridId = "001"; // ID murid aktif yang dirender di dashboard

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Data Master Atlet
  late List<Murid> _daftarMurid;

  @override
  void initState() {
    super.initState();
    _daftarMurid = [
      Murid(
        id: "001",
        nama: "BUDI SANTOSO",
        boxData: [
          [82.0, 20.0, 35.0, 48.0, 60.0, 80.0], // STRENGTH
          [88.0, 25.0, 40.0, 52.0, 65.0, 82.0], // ENDURANCE
          [0.0,  30.0, 45.0, 55.0, 70.0, 88.0], // SPEED
          [0.0,  18.0, 32.0, 45.0, 58.0, 76.0], // COORD
          [0.0,  22.0, 38.0, 50.0, 62.0, 78.0], // FLEX
          [0.0,  12.0, 28.0, 40.0, 55.0, 72.0], // BALANCE
          [90.0, 28.0, 42.0, 56.0, 68.0, 84.0], // REACTION
        ],
        radarData: [0.80, 0.65, 0.85, 0.50, 0.70, 0.90, 0.75, 0.60, 0.80, 0.55],
      ),
      Murid(
        id: "100",
        nama: "RURI",
        boxData: [
          [0.0,  30.0, 45.0, 60.0, 75.0, 90.0],
          [92.0, 20.0, 38.0, 50.0, 68.0, 85.0],
          [0.0,  25.0, 40.0, 58.0, 72.0, 86.0],
          [80.0, 22.0, 35.0, 48.0, 60.0, 78.0],
          [0.0,  15.0, 30.0, 45.0, 58.0, 70.0],
          [0.0,  20.0, 42.0, 55.0, 65.0, 80.0],
          [0.0,  35.0, 50.0, 62.0, 75.0, 92.0],
        ],
        radarData: [0.60, 0.85, 0.70, 0.75, 0.90, 0.65, 0.80, 0.70, 0.55, 0.80],
      ),
    ];
  }

  Murid get _currentMurid {
    return _daftarMurid.firstWhere(
      (m) => m.id == _selectedMuridId,
      orElse: () => _daftarMurid.isNotEmpty 
          ? _daftarMurid.first 
          : Murid(id: "000", nama: "KOSONG", boxData: List.generate(7, (_) => [0,0,0,0,0,0]), radarData: List.generate(10, (_) => 0.0)),
    );
  }

  void _tambahMurid() {
    if (_namaController.text.trim().isEmpty) return;
    setState(() {
      int maxId = 0;
      for (var m in _daftarMurid) {
        int? currentId = int.tryParse(m.id);
        if (currentId != null && currentId > maxId) {
          maxId = currentId;
        }
      }
      String nextId = (maxId + 1).toString().padLeft(3, '0');

      _daftarMurid.add(Murid(
        id: nextId,
        nama: _namaController.text.trim().toUpperCase(),
        boxData: List.generate(7, (_) => [0.0, 20.0, 40.0, 50.0, 65.0, 85.0]),
        radarData: [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6],
      ));
      _namaController.clear();
      FocusScope.of(context).unfocus();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Murid Baru Berhasil Didaftarkan!'), backgroundColor: Color(0xFF10B981)),
    );
  }

  void _hapusMurid(Murid murid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Konfirmasi Hapus', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin menghapus permanent ID-${murid.id} (${murid.nama})?', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('BATAL', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
              onPressed: () {
                setState(() {
                  _daftarMurid.removeWhere((m) => m.id == murid.id);
                  if (_selectedMuridId == murid.id && _daftarMurid.isNotEmpty) {
                    _selectedMuridId = _daftarMurid.first.id;
                  }
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('HAPUS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi Pemetaan indeks Biomotorik Boxplot
  int _dapatkanBoxIndex(String klasifikasi) {
    String upper = klasifikasi.toUpperCase();
    if (upper.contains("STRENGTH") || upper.contains("MUSCULAR") || upper.contains("POWER")) return 0;
    if (upper.contains("ENDURANCE") || upper.contains("SPEED ENDURANCE")) return 1;
    if (upper.contains("SPEED") || upper.contains("AGILITY") || upper.contains("QUICKNESS")) return 2;
    if (upper.contains("COORDINATION") || upper.contains("ANTICIPATION")) return 3;
    if (upper.contains("FLEXIBILITY") || upper.contains("MOBILITY")) return 4;
    if (upper.contains("BALANCE") || upper.contains("CORE")) return 5;
    if (upper.contains("REACTION")) return 6;
    return -1;
  }

  // Sinkronisasi data Halaman 3 (Kuantitatif - Reps)
  void _simpanDataKuantitatif(String idMurid, String jenis, String klasifikasi, double reps, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skor = reps * sets;
        _daftarMurid[idx].riwayatLatihanKuantitatif.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klasifikasi, 'reps': reps, 'sets': sets, 'skor': skor
        });
        int boxIdx = _dapatkanBoxIndex(klasifikasi);
        if (boxIdx != -1) _daftarMurid[idx].boxData[boxIdx][3] = skor;
        _selectedMuridId = idMurid;
      }
    });
  }

  // Sinkronisasi data Halaman 4 (Kualitatif - Durasi/Waktu)
  void _simpanDataDurasi(String idMurid, String jenis, String klasifikasi, double waktu, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skor = waktu * sets; 
        _daftarMurid[idx].riwayatLatihanDurasi.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klasifikasi, 'waktu': waktu, 'sets': sets, 'skor': skor
        });
        int boxIdx = _dapatkanBoxIndex(klasifikasi);
        if (boxIdx != -1) _daftarMurid[idx].boxData[boxIdx][3] = skor; 
        _selectedMuridId = idMurid;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Murid> filteredList = _daftarMurid.where((m) {
      return m.nama.toLowerCase().contains(_searchQuery.toLowerCase()) || m.id.contains(_searchQuery);
    }).toList();

    final List<Widget> pages = [
      DashboardAtletPage(activeMurid: _currentMurid),
      DaftarMuridPage(
        daftarMurid: filteredList,
        totalKapasitas: _daftarMurid.length,
        selectedId: _selectedMuridId,
        namaController: _namaController,
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val),
        onSelect: (id) => setState(() { _selectedMuridId = id; _currentIndex = 0; }),
        onDelete: _hapusMurid,
        onAdd: _tambahMurid,
      ),
      InputLatihanKuantitatifPage(
        daftarMurid: _daftarMurid,
        selectedMuridId: _selectedMuridId,
        onMuridChanged: (id) => setState(() => _selectedMuridId = id!),
        onSimpan: _simpanDataKuantitatif,
      ),
      InputLatihanDurasiPage(
        daftarMurid: _daftarMurid,
        selectedMuridId: _selectedMuridId,
        onMuridChanged: (id) => setState(() => _selectedMuridId = id!),
        onSimpan: _simpanDataDurasi,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.3),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.3),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'DASHBOARD'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_shared_outlined), activeIcon: Icon(Icons.folder_shared), label: 'DAFTAR'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note_outlined), activeIcon: Icon(Icons.edit_note), label: 'INPUT REPS'),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_top_outlined), activeIcon: Icon(Icons.hourglass_full), label: 'INPUT WAKTU'),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 1: DASHBOARD PERFORMANCE ====================
class DashboardAtletPage extends StatelessWidget {
  final Murid activeMurid;
  const DashboardAtletPage({Key? key, required this.activeMurid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
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
                style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            
            // Card Boxplot
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KOMPONEN UTAMA (BOXPLOT REAL-TIME)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8))),
                  const SizedBox(height: 20),
                  SizedBox(height: 210, child: BoxplotChart(boxData: activeMurid.boxData)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabel Real-time Evaluasi Matriks
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MATRIKS EVALUASI REAL-TIME BOXPLOT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 650,
                      child: Table(
                        border: TableBorder.all(color: const Color(0xFF334155), width: 1),
                        columnWidths: const {
                          0: FlexColumnWidth(1.2),
                          1: FlexColumnWidth(1.3),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(2.0),
                        },
                        children: [
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
                          _buildTableRow('STRENGTH / PWR', 'Score: ${activeMurid.boxData[0][3].toStringAsFixed(1)}', 'Standar baseline angkatan motorik rendah.', 'Satu atlet menembus outlier batas atas.', 'Fokus ke volume hypertrophy & dynamic power.'),
                          _buildTableRow('ENDURANCE / VO2', 'Score: ${activeMurid.boxData[1][3].toStringAsFixed(1)}', 'Recovery rate tim tidak merata.', 'Kapasitas VO2 Max beberapa atlet superior.', 'Tambahkan zona 2 aerobic low intensity interval.'),
                          _buildTableRow('SPEED / AGILITY', 'Score: ${activeMurid.boxData[2][3].toStringAsFixed(1)}', 'Rentang variabilitas kotak melebar.', 'Akselerasi awal fase eksplosif matang.', 'Kelompokkan latihan lari berdasarkan klaster kecepatan.'),
                          _buildTableRow('COORD / SPATIAL', 'Score: ${activeMurid.boxData[3][3].toStringAsFixed(1)}', 'Distribusi mampat di angka menengah.', 'Gerakan seragam dan kompak.', 'Berikan stimulus pola motorik kompleks baru.'),
                          _buildTableRow('FLEX / MOBILITY', 'Score: ${activeMurid.boxData[4][3].toStringAsFixed(1)}', 'Otot panggul dominan kaku.', 'Kelenturan ligamen sendi optimal.', 'Sesi khusus dynamic stretching sebelum latihan.'),
                          _buildTableRow('BALANCE / CORE', 'Score: ${activeMurid.boxData[5][3].toStringAsFixed(1)}', 'Stabilitas core melemah saat lelah.', 'Tumpuan satu kaki kokoh.', 'Integrasikan latihan bosu ball & plank.'),
                          _buildTableRow('REACTION TIME', 'Score: ${activeMurid.boxData[6][3].toStringAsFixed(1)}', 'Whisker bawah menjulur panjang.', 'Respon visual-motorik kilat.', 'Ambil data reaksi saat kondisi CNS segar.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(padding: const EdgeInsets.all(6.0), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 8, fontWeight: FontWeight.w900)));
  }

  TableRow _buildTableRow(String comp, String stat, String minus, String plus, String advice) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(6.0), child: Text(comp, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(stat, style: const TextStyle(color: Color(0xFF34D399), fontSize: 8, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(minus, style: const TextStyle(color: Color(0xFFF43F5E), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(plus, style: const TextStyle(color: Color(0xFF34D399), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(advice, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 8))),
      ],
    );
  }
}

// ==================== HALAMAN 2: DAFTAR MURID ====================
class DaftarMuridPage extends StatelessWidget {
  final List<Murid> daftarMurid;
  final int totalKapasitas;
  final String selectedId;
  final TextEditingController namaController;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final Function(String) onSelect;
  final Function(Murid) onDelete;
  final VoidCallback onAdd;

  const DaftarMuridPage({
    Key? key, required this.daftarMurid, required this.totalKapasitas, required this.selectedId,
    required this.namaController, required this.searchController, required this.onSearchChanged,
    required this.onSelect, required this.onDelete, required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(child: Text('Database Kontrol Atlet', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Cari nama atau ID murid...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8), size: 18),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: namaController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(hintText: 'NAMA MURID BARU', border: InputBorder.none),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  onPressed: onAdd,
                  child: const Text('TAMBAH'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daftarMurid.length,
            itemBuilder: (context, index) {
              final murid = daftarMurid[index];
              final isSelected = murid.id == selectedId;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0EA5E9).withOpacity(0.15) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? const Color(0xFF38BDF8) : Colors.transparent),
                ),
                child: ListTile(
                  leading: CircleAvatar(child: Text(murid.id, style: const TextStyle(fontSize: 10))),
                  title: Text(murid.nama, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.play_arrow, color: Color(0xFF34D399)), onPressed: () => onSelect(murid.id)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)), onPressed: () => onDelete(murid)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 3: INPUT LATIHAN KUANTITATIF (REPS) ====================
class InputLatihanKuantitatifPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String id, String jenis, String klasifikasi, double reps, double sets, DateTime tgl) onSimpan;

  const InputLatihanKuantitatifPage({
    Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan,
  }) : super(key: key);

  @override
  State<InputLatihanKuantitatifPage> createState() => _InputLatihanKuantitatifPageState();
}

class _InputLatihanKuantitatifPageState extends State<InputLatihanKuantitatifPage> {
  final TextEditingController _searchMuridController = TextEditingController();
  final TextEditingController _jenisLatihanController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  
  String _filterKeyword = "";
  String _selectedKlasifikasi = "STRENGTH";
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<Murid> opsiTerfilter = widget.daftarMurid.where((m) => m.nama.toLowerCase().contains(_filterKeyword.toLowerCase()) || m.id.contains(_filterKeyword)).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(child: Text('Input Latihan Kuantitatif (Reps)', style: TextStyle(color: Color(0xFFA855F7), fontSize: 15, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          TextField(
            controller: _searchMuridController,
            onChanged: (val) => setState(() => _filterKeyword = val),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(labelText: '🔍 Cari nama/ID murid...', filled: true, fillColor: const Color(0xFF1E293B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFF1E293B),
            value: widget.daftarMurid.any((m) => m.id == widget.selectedMuridId) ? widget.selectedMuridId : null,
            items: opsiTerfilter.map((m) => DropdownMenuItem(value: m.id, child: Text('${m.nama} (ID-${m.id})', style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: widget.onMuridChanged,
            decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _jenisLatihanController,
            decoration: const InputDecoration(labelText: 'Nama Jenis Latihan (Manual)', filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: TextField(controller: _repsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Reps', filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Set', filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()))),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9061F9)),
            onPressed: () {
              double r = double.tryParse(_repsController.text) ?? 0;
              double s = double.tryParse(_setsController.text) ?? 0;
              widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text, _selectedKlasifikasi, r, s, _selectedDate);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Kuantitatif Masuk Dashboard!')));
            },
            child: const Text('SIMPAN DATA REPS'),
          )
        ],
      ),
    );
  }
}

// ==================== HALAMAN 4: INPUT LATIHAN DURASI (WAKTU) ====================
class InputLatihanDurasiPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String id, String jenis, String klasifikasi, double waktu, double sets, DateTime tgl) onSimpan;

  const InputLatihanDurasiPage({
    Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan,
  }) : super(key: key);

  @override
  State<InputLatihanDurasiPage> createState() => _InputLatihanDurasiPageState();
}

class _InputLatihanDurasiPageState extends State<InputLatihanDurasiPage> {
  final TextEditingController _searchMuridController = TextEditingController();
  final TextEditingController _jenisLatihanController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  
  String _filterKeyword = "";
  String _selectedKlasifikasi = "STRENGTH";
  DateTime _selectedDate = DateTime.now();

  double _skorTerakhir = 0.0;
  int _totalRiwayatEntry = 0;
  double _rataRataSkorKumulatif = 0.0;

  final List<String> _opsiKlasifikasi = [
    "STRENGTH", "ENDURANCE", "SPEED", "COORDINATION", "FLEXIBILITY", "BALANCE",
    "REACTION TIME", "MUSCULAR ENDURANCE", "POWER", "CORE STABILITY",
    "DYNAMIC FLEXIBILITY", "SPEED ENDURANCE", "REACTIVE SPEED / QUICKNESS",
    "AGILITY", "ANTICIPATION & SPATIAL AWARENESS", "MOBILITY", "OPEN/REACTIVE AGILITY"
  ];

  @override
  void initState() {
    super.initState();
    _hitungKalkulasiLokal(widget.selectedMuridId);
  }

  void _hitungKalkulasiLokal(String idMurid) {
    int idx = widget.daftarMurid.indexWhere((m) => m.id == idMurid);
    if (idx != -1 && widget.daftarMurid[idx].riwayatLatihanDurasi.isNotEmpty) {
      var riwayat = widget.daftarMurid[idx].riwayatLatihanDurasi;
      _totalRiwayatEntry = riwayat.length;
      _skorTerakhir = riwayat.last['skor'] ?? 0.0;
      double totalSkor = riwayat.fold(0.0, (sum, item) => sum + (item['skor'] ?? 0.0));
      _rataRataSkorKumulatif = totalSkor / _totalRiwayatEntry;
    } else {
      _skorTerakhir = 0.0;
      _totalRiwayatEntry = 0;
      _rataRataSkorKumulatif = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Murid> opsiDropdownTerfilter = widget.daftarMurid.where((m) {
      return m.nama.toLowerCase().contains(_filterKeyword.toLowerCase()) || m.id.contains(_filterKeyword);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: Text(
              'Input Latihan Durasi (Waktu)',
              style: TextStyle(color: Color(0xFF06B6D4), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Search Field Murid
          TextField(
            controller: _searchMuridController,
            onChanged: (val) => setState(() => _filterKeyword = val),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: '🔍 Ketik nama / ID murid...',
              labelStyle: const TextStyle(color: Color(0xFF06B6D4), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0891B2))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF06B6D4))),
            ),
          ),
          const SizedBox(height: 14),

          // Dropdown Pilih Murid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.daftarMurid.any((m) => m.id == widget.selectedMuridId) ? widget.selectedMuridId : null,
                dropdownColor: const Color(0xFF1E293B),
                isExpanded: true,
                hint: const Text("Pilih Murid", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                items: opsiDropdownTerfilter.map((m) {
                  return DropdownMenuItem<String>(
                    value: m.id,
                    child: Text('${m.nama} (ID-${m.id})', style: const TextStyle(color: Colors.white, fontSize: 13)),
                  );
                }).toList(),
                onChanged: (id) {
                  if (id != null) {
                    widget.onMuridChanged(id);
                    setState(() { _hitungKalkulasiLokal(id); });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Timeline Picker Tanggal Pelaksanaan (BUG FIXED: Backslash dihapus)
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Timeline Pelaksanaan: ${ _selectedDate.day.toString().padLeft(2, '0') }/${ _selectedDate.month.toString().padLeft(2, '0') }/${_selectedDate.year}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const Icon(Icons.timeline, color: Color(0xFF06B6D4), size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Nama Jenis Latihan
          TextField(
            controller: _jenisLatihanController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Nama Jenis Latihan (Contoh: Plank)',
              labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 14),

          // Dropdown Klasifikasi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedKlasifikasi,
                dropdownColor: const Color(0xFF1E293B),
                isExpanded: true,
                items: _opsiKlasifikasi.map((String val) {
                  return DropdownMenuItem<String>(value: val, child: Text(val, style: const TextStyle(color: Colors.white, fontSize: 13)));
                }).toList(),
                onChanged: (val) => setState(() => _selectedKlasifikasi = val!),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Input Waktu dan Set
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _waktuController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Lama Waktu (Detik/Menit)',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _setsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Jumlah Set',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Simpan Data Waktu
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                double waktu = double.tryParse(_waktuController.text) ?? 0;
                double sets = double.tryParse(_setsController.text) ?? 0;
                if (_jenisLatihanController.text.trim().isEmpty || waktu <= 0 || sets <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi form durasi dengan benar!'), backgroundColor: Color(0xFFEF4444)));
                  return;
                }

                widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text.trim(), _selectedKlasifikasi, waktu, sets, _selectedDate);
                
                setState(() { _hitungKalkulasiLokal(widget.selectedMuridId); });

                FocusScope.of(context).unfocus();
                _jenisLatihanController.clear();
                _waktuController.clear();
                _setsController.clear();

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Waktu Berhasil Masuk Dashboard Real-time!'), backgroundColor: Color(0xFF10B981)));
              },
              child: const Text('SIMPAN DATA WAKTU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 24),

          // Widget Panel Kalkulasi Real-time Terkini (Bawah)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF0891B2), width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kalkulasi Real-time Terkini (Durasi):', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 13, fontWeight: FontWeight.bold)),
                const Divider(color: Color(0xFF334155), height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Skor Terakhir (Waktu × Set):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    Text(_skorTerakhir.toStringAsFixed(1), style: const TextStyle(color: Color(0xFF06B6D4), fontSize: 14, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Riwayat Entry (N):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    Text('$_totalRiwayatEntry', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rata-rata Skor Kumulatif:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    Text(_rataRataSkorKumulatif.toStringAsFixed(1), style: const TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== CUSTOM PAINTER PLOT CHART ====================
class BoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  const BoxplotChart({Key? key, required this.boxData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(double.infinity, 200), painter: _BoxplotPainter(boxData: boxData));
  }
}

class _BoxplotPainter extends CustomPainter {
  final List<List<double>> boxData;
  _BoxplotPainter({required this.boxData});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()..color = const Color(0xFF475569)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final paintBox = Paint()..color = const Color(0xFF38BDF8).withOpacity(0.4)..style = PaintingStyle.fill;
    final paintMedian = Paint()..color = const Color(0xFF10B981)..strokeWidth = 3;

    double barWidth = size.width / 8;
    for (int i = 0; i < math.min(7, boxData.length); i++) {
      double x = (i + 1) * barWidth;
      double medianVal = boxData[i][3];
      double boxTop = 150 - (medianVal * 1.2);
      double boxBottom = boxTop + 40;

      canvas.drawLine(Offset(x, boxTop - 20), Offset(x, boxBottom + 20), paintLine);
      canvas.drawRect(Rect.fromLTRB(x - 10, boxTop, x + 10, boxBottom), paintBox);
      canvas.drawLine(Offset(x - 10, boxTop + 20), Offset(x + 10, boxTop + 20), paintMedian);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
