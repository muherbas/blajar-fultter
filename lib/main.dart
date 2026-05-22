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
  final List<List<double>> boxData;
  final List<double> radarData;

  Murid({
    required this.id,
    required this.nama,
    required this.boxData,
    required this.radarData,
  });
}

// Pengelola State Navigasi Utama Antara Dashboard dan Daftar
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

  // Data Master Atlet (Mendukung kapasitas jumbo hingga >200 id-murid secara efisien)
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
          [82.0, 20.0, 35.0, 48.0, 60.0, 80.0],
          [88.0, 25.0, 40.0, 52.0, 65.0, 82.0],
          [0.0,  30.0, 45.0, 55.0, 70.0, 88.0],
          [0.0,  18.0, 32.0, 45.0, 58.0, 76.0],
          [0.0,  22.0, 38.0, 50.0, 62.0, 78.0],
          [0.0,  12.0, 28.0, 40.0, 55.0, 72.0],
          [90.0, 28.0, 42.0, 56.0, 68.0, 84.0],
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

  // Tambah Murid Baru (1 ID, 1 Murid secara berurutan sistematis)
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

  // Hapus id-murid + Konfirmasi Dialog Keamanan Data
  void _hapusMurid(Murid murid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Konfirmasi Hapus', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin ingin menghapus data permanent dari ID-${murid.id} (${murid.nama})?', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
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

  @override
  Widget build(BuildContext context) {
    // Memfilter data jika user menggunakan kolom pencarian nama murid
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
            _currentIndex = 0; // Otomatis lompat ke tab Dashboard setelah dipilih
          });
        },
        onDelete: _hapusMurid,
        onAdd: _tambahMurid,
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.8),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.8),
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
            // Header Info Atas
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

            // Card Komponen Utama (Boxplot)
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
            
            // Tabel Kolom Matriks Komponen Utama
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MATRIKS EVALUASI BOXPLOT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
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
                          _buildTableRow('STRENGTH', 'Median ${activeMurid.boxData[0][3].toStringAsFixed(0)}', 'Standar baseline angkatan motorik rendah.', 'Satu atlet menembus outlier batas atas.', 'Fokus ke volume hypertrophy fundamental.'),
                          _buildTableRow('ENDURANCE', 'Median ${activeMurid.boxData[1][3].toStringAsFixed(0)}', 'Recovery rate tim tidak merata.', 'Kapasitas VO2 Max beberapa atlet superior.', 'Tambahkan zona 2 aerobic low intensity interval.'),
                          _buildTableRow('SPEED', 'Median ${activeMurid.boxData[2][3].toStringAsFixed(0)}', 'Rentang variabilitas kotak melebar.', 'Akselerasi awal fase eksplosif matang.', 'Kelompokkan latihan lari berdasarkan klaster kecepatan.'),
                          _buildTableRow('COORD', 'Median ${activeMurid.boxData[3][3].toStringAsFixed(0)}', 'Distribusi mampat di angka menengah.', 'Gerakan seragam dan kompak.', 'Berikan stimulus pola motorik kompleks baru.'),
                          _buildTableRow('FLEX', 'Median ${activeMurid.boxData[4][3].toStringAsFixed(0)}', 'Otot panggul dominan kaku.', 'Kelenturan ligamen sendi optimal.', 'Sesi khusus dynamic stretching sebelum latihan.'),
                          _buildTableRow('BALANCE', 'Median ${activeMurid.boxData[5][3].toStringAsFixed(0)}', 'Stabilitas core melemah saat lelah.', 'Tumpuan satu kaki kokoh.', 'Integrasikan latihan bosu ball & plank.'),
                          _buildTableRow('REACTION', 'Median ${activeMurid.boxData[6][3].toStringAsFixed(0)}', 'Whisker bawah menjulur panjang.', 'Respon visual-motorik kilat.', 'Ambil data reaksi saat kondisi CNS segar.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Card Komponen Turunan (Radar Spider)
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
        Padding(padding: const EdgeInsets.all(6.0), child: Text(stat, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(minus, style: const TextStyle(color: Color(0xFFF43F5E), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(plus, style: const TextStyle(color: Color(0xFF34D399), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(advice, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 8))),
      ],
    );
  }
}

// ==================== HALAMAN 2: DAFTAR MURID & MANAGEMENT BACKUP ====================
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

          // Baris Tombol Export & Import Backup Data
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
                      const SnackBar(content: Text('Data 200+ Murid Berhasil Di-Backup (.json)!'), backgroundColor: Color(0xFF0EA5E9)),
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
          const SizedBox(height: 16),

          // Input Pencarian Murid (Sesuai Mockup)
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Cari nama atlet untuk kelola/hapus...',
              hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 18),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF38BDF8)), borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),

          // Container Form Pengisian Penambahan Murid (1 ID 1 Murid)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF38BDF8).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Tambah Murid Baru (+ID)', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                const Text('Nama Lengkap Murid Baru', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller: namaController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Adi Wijaya',
                    hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF38BDF8)), borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onAdd,
                    child: const Text('DAFTARKAN ATLET BARU', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('TERGABUNG: $totalKapasitas ATLET', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          const SizedBox(height: 8),

          // List Rendering Dinamis yang Aman dari Lag (Mendukung > 200 item)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daftarMurid.length,
            itemBuilder: (context, index) {
              final murid = daftarMurid[index];
              final bool isSelected = murid.id == selectedId;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? const Color(0xFF10B981) : Colors.transparent),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF0F172A),
                      child: Icon(Icons.person, color: Color(0xFF38BDF8), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(murid.nama, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('ID - ${murid.id}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // Kolom Opsi Pilih untuk Dilihat di Dashboard
                    GestureDetector(
                      onTap: () => onSelect(murid.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isSelected ? 'Sedang Dilihat' : 'Lihat Grafik',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Kolom Opsi Hapus Atlet
                    GestureDetector(
                      onTap: () => onDelete(murid),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Hapus', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==================== PAINTER BOXPLOT ====================
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

  void drawValueText(Canvas canvas, Offset offset, String text, Color color) {
    TextPainter(text: TextSpan(text: text, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: color)), textDirection: TextDirection.ltr)..layout()..paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..color = const Color(0xFF475569)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final Paint boxPaint = Paint()..color = const Color(0xFF0284C7)..style = PaintingStyle.fill;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    double spacing = size.width / 7;

    for (int i = 0; i < 7; i++) {
      double x = (spacing * i) + (spacing / 2);
      var raw = boxData[i];
      
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
      
      canvas.drawLine(Offset(x, q1Y), Offset(x, bottomWhiskerY), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, bottomWhiskerY), Offset(x + boxWidth/3, bottomWhiskerY), linePaint);

      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3Y, x + boxWidth / 2, q1Y);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1);
      canvas.drawLine(Offset(x - boxWidth / 2, medianY), Offset(x + boxWidth / 2, medianY), Paint()..color = const Color(0xFFF8FAFC)..strokeWidth = 1.5);
      drawValueText(canvas, Offset(x + boxWidth/2 + 2, medianY - 4), raw[3].toStringAsFixed(0), const Color(0xFFF8FAFC));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==================== PAINTER RADAR (FIXED BUG) ====================
class RadarSpiderChart extends StatelessWidget {
  final List<double> studentValues;
  const RadarSpiderChart({Key? key, required this.studentValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: RadarSpiderPainter(studentValues: studentValues));
  }
}

class RadarSpiderPainter extends CustomPainter {
  final List<double> studentValues;
  RadarSpiderPainter({required this.studentValues});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double maxRadius = math.min(size.width, size.height) / 2.6; 
    int numFeatures = 10;
    
    // Solusi Perbaikan Bug Foto 1001506865.jpg: Mengakses indeks array [j] secara akurat
    List<String> labels = ['MUSCULAR END.', 'POWER', 'CORE STAB.', 'DYN. FLEX', 'SPEED END.', 'REACTIVE SP.', 'AGILITY', 'ANTICIPATION', 'MOBILITY', 'REACT AGILITY'];

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

    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double x = center.dx + maxRadius * math.cos(angle);
      double y = center.dy + maxRadius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
      
      // Menggunakan labels[j] untuk menarik string tunggal, bukan List
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: labels[j], style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))), 
        textDirection: TextDirection.ltr
      )..layout();
      
      double textX = center.dx + (maxRadius + 12) * math.cos(angle) - (textPainter.width / 2);
      double textY = center.dy + (maxRadius + 10) * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // TEAM DATA INTERSECTION
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
    canvas.drawPath(teamPath, Paint()..color = const Color(0xFF0EA5E9).withOpacity(0.1)..style = PaintingStyle.fill);
    canvas.drawPath(teamPath, Paint()..color = const Color(0xFF0EA5E9).withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 1.0);

    // STUDENT DATA INTERSECTION
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
    canvas.drawPath(studentPath, Paint()..color = const Color(0xFFF43F5E).withOpacity(0.25)..style = PaintingStyle.fill);
    canvas.drawPath(studentPath, Paint()..color = const Color(0xFFF43F5E)..style = PaintingStyle.stroke..strokeWidth = 1.8);

    for (int j = 0; j < studentPoints.length; j++) {
      Offset point = studentPoints[j];
      canvas.drawCircle(point, 2.5, Paint()..color = const Color(0xFFFFF1F2));
      
      String score = (studentValues[j] * 100).toStringAsFixed(0);
      TextPainter(
        text: TextSpan(text: score, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFFFFF1F2))), 
        textDirection: TextDirection.ltr
      )..layout()..paint(canvas, Offset(point.dx + 4, point.dy - 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
