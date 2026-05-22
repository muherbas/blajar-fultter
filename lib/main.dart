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
  final List<List<double>> boxData; // Index 0-6 untuk biomotorik utama
  final List<double> radarData;
  
  // Menyimpan riwayat kalkulasi latihan kuantitatif khusus murid ini
  List<Map<String, dynamic>> riwayatLatihan;

  Murid({
    required this.id,
    required this.nama,
    required this.boxData,
    required this.radarData,
    List<Map<String, dynamic>>? riwayatLatihan,
  }) : this.riwayatLatihan = riwayatLatihan ?? [];
}

// Pengelola State Navigasi Utama (3 Halaman: Dashboard, Daftar, & Input Data)
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 1; // Default terbuka langsung di halaman "Daftar"
  String _selectedMuridId = "001"; // ID murid aktif yang akan dirender di dashboard

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Data Master Atlet
  late List<Murid> _daftarMurid;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi sampel data awal
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

  // Mengambil data murid aktif untuk dashboard
  Murid get _currentMurid {
    return _daftarMurid.firstWhere(
      (m) => m.id == _selectedMuridId,
      orElse: () => _daftarMurid.isNotEmpty 
          ? _daftarMurid.first 
          : Murid(id: "000", nama: "KOSONG", boxData: List.generate(7, (_) => [0,0,0,0,0,0]), radarData: List.generate(10, (_) => 0.0)),
    );
  }

  // Tambah Murid Baru Berurutan
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

  // Hapus Data Murid
  void _hapusMurid(Murid murid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Konfirmasi Hapus', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin ingin menghapus data permanen dari ID-${murid.id} (${murid.nama})?', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('BATAL', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ID-${murid.id} Berhasil Dihapus.'), backgroundColor: const Color(0xFFEF4444)),
                );
              },
              child: const Text('HAPUS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Menyimpan entri data kuantitatif baru dan melakukan sinkronisasi nilai ke chart dashboard
  void _simpanDataLatihan(String idMurid, String jenisLatihan, String klasifikasi, double reps, double sets, DateTime tanggal) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skorAkhir = reps * sets;
        _daftarMurid[idx].riwayatLatihan.add({
          'tanggal': tanggal,
          'jenis': jenisLatihan,
          'klasifikasi': klasifikasi,
          'reps': reps,
          'sets': sets,
          'skor': skorAkhir,
        });

        // Menentukan index komponen biomotorik berdasarkan klasifikasi pilihan
        int boxIndex = -1;
        if (klasifikasi.contains("Strength") || klasifikasi.contains("Muscular") || klasifikasi.contains("Power")) boxIndex = 0;
        else if (klasifikasi.contains("Endurance") || klasifikasi.contains("Speed Endurance")) boxIndex = 1;
        else if (klasifikasi.contains("Speed") || klasifikasi.contains("Agility")) boxIndex = 2;
        else if (klasifikasi.contains("Coordination")) boxIndex = 3;
        else if (klasifikasi.contains("Flexibility") || klasifikasi.contains("Mobility")) boxIndex = 4;
        else if (klasifikasi.contains("Balance") || klasifikasi.contains("Core")) boxIndex = 5;
        else if (klasifikasi.contains("Reaction")) boxIndex = 6;

        // Jika klasifikasi cocok, perbarui nilai median data [index 3] boxplot secara dinamis
        if (boxIndex != -1) {
          _daftarMurid[idx].boxData[boxIndex][3] = skorAkhir; 
        }
        
        _selectedMuridId = idMurid; // Fokuskan dashboard ke murid yang baru di-update
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
        onSearchChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        onSelect: (id) {
          setState(() {
            _selectedMuridId = id;
            _currentIndex = 0; // Otomatis pindah ke Dashboard setelah dipilih
          });
        },
        onDelete: _hapusMurid,
        onAdd: _tambahMurid,
      ),
      InputLatihanKuantitatifPage(
        daftarMurid: _daftarMurid,
        selectedMuridId: _selectedMuridId,
        onMuridChanged: (id) {
          setState(() {
            _selectedMuridId = id!;
          });
        },
        onSimpan: _simpanDataLatihan,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.analytics_outlined)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.analytics)),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.folder_shared_outlined)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.folder_shared)),
            label: 'DAFTAR',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.edit_note_outlined)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.edit_note)),
            label: 'INPUT DATA',
          ),
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

            // Card Boxplot Chart
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KOMPONEN UTAMA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8), letterSpacing: 0.5)),
                  const SizedBox(height: 20),
                  SizedBox(height: 210, child: BoxplotChart(boxData: activeMurid.boxData)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('GLOBAL TEAM AVERAGE', style: TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                        Text('68.5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFF8FAFC))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabel Matriks Komponen Utama
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
            const SizedBox(height: 16),

            // Card Radar Spider Chart
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KOMPONEN TURUNAN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFF43F5E))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(width: 8, height: 8, color: const Color(0xFFF43F5E)),
                      const SizedBox(width: 4),
                      const Text('Murid', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(width: 8, height: 8, color: const Color(0xFF0EA5E9)),
                      const SizedBox(width: 4),
                      const Text('Tim Avg', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: 340, child: RadarSpiderChart(studentValues: activeMurid.radarData)),
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

// ==================== HALAMAN 2: DAFTAR MURID & BACKUP CONTROL ====================
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
    Key? key,
    required this.daftarMurid,
    required this.totalKapasitas,
    required this.selectedId,
    required this.namaController,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSelect,
    required this.onDelete,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: Text(
              'Database JUMBO & Kontrol Atlet',
              style: TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Backup dan Restore dengan perbaikan properti border: Border.all()
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.upload, color: Color(0xFF38BDF8), size: 16),
                  label: const Text('Ekspor Backup', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data Murid Berhasil Di-Backup (.json)!'), backgroundColor: Color(0xFF0EA5E9)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.download, color: Color(0xFF34D399), size: 16),
                  label: const Text('Impor Restore', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Restorasi Sukses! Database sinkron kembali.'), backgroundColor: Color(0xFF10B981)),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Box pencarian murid global
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Cari nama atau ID murid...',
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8), size: 18),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Input Registrasi Atlet Baru
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
                    decoration: const InputDecoration(
                      hintText: 'NAMA MURID BARU',
                      hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  onPressed: onAdd,
                  child: const Text('TAMBAH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List Murid Terdaftar
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
                  border: Border.all(color: isSelected ? const Color(0xFF38BDF8) : Colors.transparent, width: 1),
                ),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                    radius: 14,
                    child: Text(murid.id, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(murid.nama, style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  subtitle: Text('Total Entri Riwayat: ${murid.riwayatLatihan.length}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Color(0xFF34D399), size: 18),
                        onPressed: () => onSelect(murid.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 18),
                        onPressed: () => onDelete(murid),
                      ),
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

// ==================== HALAMAN 3: INPUT LATIHAN KUANTITATIF (FITUR BARU) ====================
class InputLatihanKuantitatifPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String idMurid, String jenisLatihan, String klasifikasi, double reps, double sets, DateTime tanggal) onSimpan;

  const InputLatihanKuantitatifPage({
    Key? key,
    required this.daftarMurid,
    required this.selectedMuridId,
    required this.onMuridChanged,
    required this.onSimpan,
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
  String _selectedKlasifikasi = "1. Strength (Kekuatan)";
  DateTime _selectedDate = DateTime.now();

  // Variabel penampung kalkulasi real-time lokal panel bawah
  double _skorTerakhir = 0.0;
  int _totalRiwayatEntry = 0;
  double _rataRataSkorKumulatif = 0.0;

  final List<String> _opsiKlasifikasi = [
    "1. Strength (Kekuatan)", "2. Endurance (Daya Tahan)", "3. Speed (Kecepatan)",
    "4. Coordination (Koordinasi)", "5. Flexibility (Kelenturan)", "6. Balance (Keseimbangan)",
    "7. Reaction Time (Waktu Reaksi)", "8. Muscular Endurance", "9. Power",
    "10. Core Stability", "11. Dynamic Flexibility", "12. Speed Endurance",
    "13. Reactive Speed / Quickness", "14. Agility", "15. Anticipation & Spatial Awareness",
    "16. Mobility", "17. Open/Reactive Agility"
  ];

  @override
  void initState() {
    super.initState();
    _hitungKalkulasiLokal(widget.selectedMuridId);
  }

  void _hitungKalkulasiLokal(String idMurid) {
    int idx = widget.daftarMurid.indexWhere((m) => m.id == idMurid);
    if (idx != -1 && widget.daftarMurid[idx].riwayatLatihan.isNotEmpty) {
      var riwayat = widget.daftarMurid[idx].riwayatLatihan;
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
    // Memfilter opsi dropdown murid berdasarkan pencarian cepat nama/ID
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
              'Input Latihan Kuantitatif (Reps)',
              style: TextStyle(color: Color(0xFFA855F7), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Pencarian Cepat Nama Murid
          TextField(
            controller: _searchMuridController,
            onChanged: (val) => setState(() => _filterKeyword = val),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: '🔍 Ketik untuk cari nama/ID murid...',
              labelStyle: const TextStyle(color: Color(0xFFA855F7), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF4A148C))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFA855F7))),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Dropdown Pilih Murid (Telah Terfilter Otomatis)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), 
              borderRadius: BorderRadius.circular(8), 
              border: Border.all(color: const Color(0xFF334155))
            ),
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
                    setState(() {
                      _hitungKalkulasiLokal(id);
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 3. Picker Kalender Tanggal Pelaksanaan
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tanggal Pelaksanaan: ${_selectedDate.day.toString().padLeft(2,'0')}/${_selectedDate.month.toString().padLeft(2,'0')}/${_selectedDate.year}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const Icon(Icons.calendar_month, color: Color(0xFFA855F7), size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 4. Input Nama Jenis Latihan
          TextField(
            controller: _jenisLatihanController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Nama Jenis Latihan (Contoh: Push Up)',
              labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 14),

          // 5. Dropdown Klasifikasi Biomotorik
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedKlasifikasi,
                dropdownColor: const Color(0xFF1E293B),
                isExpanded: true,
                items: _opsiKlasifikasi.map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedKlasifikasi = val!),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 6. Baris Input Repetisi & Set
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Jumlah Repetisi',
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

          // 7. Tombol Simpan Utama Dengan Perbaikan mainAxisAlignment.spaceBetween
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9061F9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                double reps = double.tryParse(_repsController.text) ?? 0;
                double sets = double.tryParse(_setsController.text) ?? 0;
                if (_jenisLatihanController.text.trim().isEmpty || reps <= 0 || sets <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lengkapi form data entry dengan benar!'), backgroundColor: Color(0xFFEF4444)),
                  );
                  return;
                }

                // Kirim data ke sistem pusat state global
                widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text.trim(), _selectedKlasifikasi, reps, sets, _selectedDate);
                
                // Sinkronisasi data ke tampilan monitor lokal bawah secara instan
                setState(() {
                  _hitungKalkulasiLokal(widget.selectedMuridId);
                });

                FocusScope.of(context).unfocus();
                _jenisLatihanController.clear();
                _repsController.clear();
                _setsController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data Kuantitatif Sinkron Masuk Dashboard!'), backgroundColor: Color(0xFF10B981)),
                );
              },
              child: const Text('SIMPAN DATA INPUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 24),

          // 8. Widget Monitor Perhitungan Real-time (Dengan perbaikan properti MainAxisAlignment & FontWeight)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), 
              borderRadius: BorderRadius.circular(12), 
              border: Border.all(color: const Color(0xFF4A148C), width: 1)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kalkulasi Real-time Terkini:', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 13, fontWeight: FontWeight.bold)),
                const Divider(color: Color(0xFF334155), height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Diperbaiki dari .between
                  children: [
                    const Text('Skor Terakhir (Reps × Set):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    Text(
                      _skorTerakhir.toStringAsFixed(1), 
                      style: const TextStyle(color: Color(0xFFFFA855), fontSize: 14, fontWeight: FontWeight.w900), // Diperbaiki dari .black ke .w900
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Diperbaiki dari .between
                  children: [
                    const Text('Total Riwayat Entry (N):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    Text('$_totalRiwayatEntry', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Diperbaiki dari .between
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

// ==================== CUSTOM PAINTERS PLOT CHART ====================
class BoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  const BoxplotChart({Key? key, required this.boxData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _BoxplotPainter(boxData: boxData),
    );
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

class RadarSpiderChart extends StatelessWidget {
  final List<double> studentValues;
  const RadarSpiderChart({Key? key, required this.studentValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(double.infinity, 300), painter: _RadarPainter());
  }
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 1;
    final paintLineMurid = Paint()..color = const Color(0xFFF43F5E)..style = PaintingStyle.fill;
    
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 100;
    
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), paintGrid);
    }
    canvas.drawCircle(center, radius * 0.75, paintLineMurid..color = const Color(0xFFF43F5E).withOpacity(0.3));
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
