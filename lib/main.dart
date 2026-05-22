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
  final List<List<double>> boxData; // Index 0-6: [Min, Q1, Q2/Median, CurrentScore/Mean, Q3, Max]
  final List<double> radarData; // 10 Dimensi Nilai Atlet (0.0 - 1.0)
  
  List<Map<String, dynamic>> riwayatLatihanKuantitatif;
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

// Pengelola State Navigasi Utama
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 1; // Default halaman DAFTAR
  String _selectedMuridId = "001"; 

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  late List<Murid> _daftarMurid;

  @override
  void initState() {
    super.initState();
    _daftarMurid = [
      Murid(
        id: "001",
        nama: "BUDI SANTOSO",
        boxData: [
          [20.0, 35.0, 48.0, 75.0, 60.0, 85.0], // STRENGTH
          [25.0, 40.0, 52.0, 68.0, 65.0, 88.0], // ENDURANCE
          [30.0, 45.0, 55.0, 82.0, 70.0, 90.0], // SPEED
          [18.0, 32.0, 45.0, 50.0, 58.0, 76.0], // COORD
          [22.0, 38.0, 50.0, 40.0, 62.0, 78.0], // FLEX
          [12.0, 28.0, 40.0, 65.0, 55.0, 72.0], // BALANCE
          [28.0, 42.0, 56.0, 80.0, 68.0, 92.0], // REACTION
        ],
        radarData: [0.85, 0.68, 0.82, 0.50, 0.40, 0.65, 0.80, 0.70, 0.75, 0.60],
      ),
      Murid(
        id: "100",
        nama: "RURI",
        boxData: [
          [20.0, 35.0, 50.0, 45.0, 65.0, 85.0],
          [25.0, 40.0, 55.0, 72.0, 70.0, 90.0],
          [22.0, 38.0, 48.0, 60.0, 62.0, 86.0],
          [15.0, 30.0, 42.0, 55.0, 58.0, 75.0],
          [20.0, 35.0, 50.0, 78.0, 65.0, 88.0],
          [18.0, 32.0, 46.0, 50.0, 60.0, 78.0],
          [25.0, 40.0, 52.0, 58.0, 66.0, 90.0],
        ],
        radarData: [0.45, 0.72, 0.60, 0.55, 0.78, 0.50, 0.58, 0.65, 0.52, 0.70],
      ),
    ];
  }

  Murid get _currentMurid {
    return _daftarMurid.firstWhere(
      (m) => m.id == _selectedMuridId,
      orElse: () => _daftarMurid.first,
    );
  }

  // Menghitung Rata-rata Kumulatif Seluruh Tim (All ID) untuk parameter pembanding (Merah)
  List<double> get _teamAverageBoxScores {
    List<double> averages = List.generate(7, (_) => 0.0);
    if (_daftarMurid.isEmpty) return averages;
    for (int i = 0; i < 7; i++) {
      double sum = 0;
      for (var murid in _daftarMurid) {
        sum += murid.boxData[i][3]; // Ambil indeks score aktif
      }
      averages[i] = sum / _daftarMurid.length;
    }
    return averages;
  }

  List<double> get _teamAverageRadar {
    List<double> averages = List.generate(10, (_) => 0.0);
    if (_daftarMurid.isEmpty) return averages;
    for (int i = 0; i < 10; i++) {
      double sum = 0;
      for (var murid in _daftarMurid) {
        sum += murid.radarData[i];
      }
      averages[i] = sum / _daftarMurid.length;
    }
    return averages;
  }

  void _tambahMurid() {
    if (_namaController.text.trim().isEmpty) return;
    setState(() {
      int maxId = 0;
      for (var m in _daftarMurid) {
        int? cId = int.tryParse(m.id);
        if (cId != null && cId > maxId) maxId = cId;
      }
      String nextId = (maxId + 1).toString().padLeft(3, '0');

      _daftarMurid.add(Murid(
        id: nextId,
        nama: _namaController.text.trim().toUpperCase(),
        boxData: List.generate(7, (_) => [20.0, 35.0, 50.0, 50.0, 65.0, 85.0]),
        radarData: [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5],
      ));
      _namaController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  void _hapusMurid(Murid murid) {
    setState(() {
      _daftarMurid.removeWhere((m) => m.id == murid.id);
      if (_selectedMuridId == murid.id && _daftarMurid.isNotEmpty) {
        _selectedMuridId = _daftarMurid.first.id;
      }
    });
  }

  int _dapatkanBoxIndex(String klasifikasi) {
    String upper = klasifikasi.toUpperCase();
    if (upper.contains("STRENGTH") || upper.contains("POWER")) return 0;
    if (upper.contains("ENDURANCE")) return 1;
    if (upper.contains("SPEED") || upper.contains("AGILITY")) return 2;
    if (upper.contains("COORD")) return 3;
    if (upper.contains("FLEX")) return 4;
    if (upper.contains("BALANCE")) return 5;
    if (upper.contains("REACTION")) return 6;
    return -1;
  }

  void _simpanDataKuantitatif(String idMurid, String jenis, String klasifikasi, double reps, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skor = reps * sets;
        _daftarMurid[idx].riwayatLatihanKuantitatif.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klasifikasi, 'skor': skor
        });
        int boxIdx = _dapatkanBoxIndex(klasifikasi);
        if (boxIdx != -1) _daftarMurid[idx].boxData[boxIdx][3] = skor;
        _selectedMuridId = idMurid;
      }
    });
  }

  void _simpanDataDurasi(String idMurid, String jenis, String klasifikasi, double waktu, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skor = waktu * sets;
        _daftarMurid[idx].riwayatLatihanDurasi.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klasifikasi, 'skor': skor
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
      DashboardAtletPage(
        activeMurid: _currentMurid,
        teamBoxAverages: _teamAverageBoxScores,
        teamRadarAverages: _teamAverageRadar,
      ),
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'DASHBOARD'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_shared), label: 'DAFTAR'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'INPUT REPS'),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_full), label: 'INPUT WAKTU'),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 1: DASHBOARD PERFORMANCE ====================
class DashboardAtletPage extends StatelessWidget {
  final Murid activeMurid;
  final List<double> teamBoxAverages;
  final List<double> teamRadarAverages;

  const DashboardAtletPage({
    Key? key, 
    required this.activeMurid, 
    required this.teamBoxAverages,
    required this.teamRadarAverages,
  }) : super(key: key);

  // LOGIK GENERATOR EVALUASI KELAYAKAN DINAMIS AI
  String _generateAiInsight() {
    double strength = activeMurid.boxData[0][3];
    double endurance = activeMurid.boxData[1][3];
    double speed = activeMurid.boxData[2][3];
    double flexibility = activeMurid.boxData[4][3];

    String hasilAnalisis = "ANALISIS PERFORMA GABUNGAN (AI SYSTEM):\n";
    hasilAnalisis += "Atlet ${activeMurid.nama} (ID: ${activeMurid.id}) menunjukkan profil motorik dominan pada ";

    if (strength > speed && strength > endurance) {
      hasilAnalisis += "Kekuatan Otot (Power/Strength). Eksplosif teknik serangan sangat kuat, ";
    } else if (speed > strength && speed > endurance) {
      hasilAnalisis += "Kecepatan Gerak (Speed/Agility). Akselerasi serangan dan counter sangat kilat, ";
    } else {
      hasilAnalisis += "Daya Tahan Kardio (Endurance). Stabil mempertahankan ritme bertarung intensitas tinggi, ";
    }

    if (flexibility < 50.0) {
      hasilAnalisis += "namun area Fleksibilitas/Mobilitas sendi terpantau berada di bawah batas kritis (Skor: ${flexibility.toStringAsFixed(1)}), berisiko membatasi jangkauan tendangan tinggi dan rawan cedera.\n\n";
    } else {
      hasilAnalisis += "dan didukung tingkat fleksibilitas yang cukup elastis.\n\n";
    }

    // Komparasi dengan Tim
    double avgTimStrength = teamBoxAverages[0];
    if (strength >= avgTimStrength) {
      hasilAnalisis += "💡 REKOMENDASI ADAPTIF:\nSecara umum performa berada DI ATAS rata-rata tim. Pertahankan volume beban terprogram dan tambahkan sesi latihan pemulihan (CNS recovery) taktis.";
    } else {
      hasilAnalisis += "💡 REKOMENDASI ADAPTIF:\nPerforma atlet terpantau DI BAWAH rata-rata baseline tim. Diperlukan penambahan porsi sirkuit fungsional kardio khusus serta conditioning harian.";
    }

    return hasilAnalisis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header Identitas Atlet
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text(
                    'COMPREHENSIVE PERFORMANCE DASHBOARD',
                    style: TextStyle(color: Colors.blueGrey[300], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activeMurid.id} - ${activeMurid.nama}',
                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 12, height: 12, color: const Color(0xFF00E5FF)),
                      const SizedBox(width: 4),
                      const Text('Atlet Aktif', style: TextStyle(fontSize: 10, color: Colors.white70)),
                      const SizedBox(width: 16),
                      Container(width: 12, height: 12, color: const Color(0xFFFF1744)),
                      const SizedBox(width: 4),
                      const Text('Rata-Rata Tim', style: TextStyle(fontSize: 10, color: Colors.white70)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // 1. GRAFIK BOXPLOT VERSI META (LENGKAP ANGKA STATISTIK)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DISTRIBUSI MOTORIK TIM VS INDIVIDU (BOXPLOT)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8))),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240, 
                    child: MetaBoxplotChart(
                      boxData: activeMurid.boxData, 
                      teamAverages: teamBoxAverages
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. GRAFIK RADAR DENGAN INDIKATOR ANGKA
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PROFIL BIOMOTORIK METRIKS RADAR (10 DIMENSI)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFA855F7))),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 240,
                    child: CustomPaint(
                      size: const Size(double.infinity, 240),
                      painter: MetaRadarChartPainter(
                        activeRadar: activeMurid.radarData, 
                        teamRadar: teamRadarAverages
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. FITUR BARU: KOLOM PENILAIAN DINAMIS AI
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA855F7).withOpacity(0.5), width: 1.5)
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.psychology, color: Color(0xFFA855F7), size: 20),
                      SizedBox(width: 8),
                      Text('DECISION SUPPORT SYSTEM (AI EVALUATION)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFA855F7))),
                    ],
                  ),
                  const Divider(color: Color(0xFF334155), height: 16),
                  Text(
                    _generateAiInsight(),
                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 11, height: 1.5, letterSpacing: 0.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 4. TABEL MATRIKS EVALUASI
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 580,
                  child: Table(
                    border: TableBorder.all(color: const Color(0xFF334155), width: 1),
                    columnWidths: const {
                      0: FlexColumnWidth(1.2),
                      1: FlexColumnWidth(1.0),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(2.0),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                        children: [
                          _buildHeaderCell('KOMPONEN'),
                          _buildHeaderCell('SKOR ATLET'),
                          _buildHeaderCell('RATA TIM'),
                          _buildHeaderCell('REKOMENDASI MOTORIK'),
                        ],
                      ),
                      _buildTableRow('STRENGTH', activeMurid.boxData[0][3], teamBoxAverages[0], 'Hypertrophy fungsional.'),
                      _buildTableRow('ENDURANCE', activeMurid.boxData[1][3], teamBoxAverages[1], 'Interval treshold zona 3.'),
                      _buildTableRow('SPEED', activeMurid.boxData[2][3], teamBoxAverages[2], 'Akselerasi plyometrik kaki.'),
                      _buildTableRow('COORD', activeMurid.boxData[3][3], teamBoxAverages[3], 'Kompleksitas drills sirkuit.'),
                      _buildTableRow('FLEXIBILITY', activeMurid.boxData[4][3], teamBoxAverages[4], 'PNF stretching intensif.'),
                      _buildTableRow('BALANCE', activeMurid.boxData[5][3], teamBoxAverages[5], 'Proprioception stabil tumpuan.'),
                      _buildTableRow('REACTION', activeMurid.boxData[6][3], teamBoxAverages[6], 'Stimulus visual target cepat.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(padding: const EdgeInsets.all(6.0), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 9, fontWeight: FontWeight.bold)));
  }

  TableRow _buildTableRow(String comp, double personal, double team, String advice) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(6.0), child: Text(comp, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(personal.toStringAsFixed(1), style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 9, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(team.toStringAsFixed(1), style: const TextStyle(color: Color(0xFFFF1744), fontSize: 9))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(advice, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9))),
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
          const SizedBox(height: 14),
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: namaController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(hintText: 'NAMA ATLET BARU', border: InputBorder.none),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  onPressed: onAdd,
                  child: const Text('REGISTRASI'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
                  leading: CircleAvatar(backgroundColor: Colors.blueGrey[800], child: Text(murid.id, style: const TextStyle(fontSize: 10, color: Colors.white))),
                  title: Text(murid.nama, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.analytics, color: Color(0xFF34D399)), onPressed: () => onSelect(murid.id)),
                      IconButton(icon: const Icon(Icons.delete, color: Color(0xFFEF4444)), onPressed: () => onDelete(murid)),
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

// ==================== HALAMAN 3 & 4 (INPUT FORM CODE STABLE) ====================
class InputLatihanKuantitatifPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String id, String jenis, String klasifikasi, double reps, double sets, DateTime tgl) onSimpan;

  const InputLatihanKuantitatifPage({Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan}) : super(key: key);
  @override State<InputLatihanKuantitatifPage> createState() => _InputLatihanKuantitatifPageState();
}
class _InputLatihanKuantitatifPageState extends State<InputLatihanKuantitatifPage> {
  final TextEditingController _jenisLatihanController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  String _selectedKlasifikasi = "STRENGTH";

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Input Capaian Kuantitatif (Reps/Set)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFA855F7))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E293B),
              value: widget.selectedMuridId,
              items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text(m.nama))).toList(),
              onChanged: widget.onMuridChanged,
              decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: _jenisLatihanController, decoration: const InputDecoration(labelText: 'Nama Latihan (Push Up, etc)', filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _repsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Reps', filled: true, fillColor: Color(0xFF1E293B)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sets', filled: true, fillColor: Color(0xFF1E293B)))),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA855F7), width: double.infinity),
              onPressed: () {
                double r = double.tryParse(_repsController.text) ?? 0;
                double s = double.tryParse(_setsController.text) ?? 0;
                widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text, _selectedKlasifikasi, r, s, DateTime.now());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil Ditambahkan ke Boxplot!')));
              },
              child: const Text('SUBMIT REPS ATLET'),
            )
          ],
        ),
      ),
    );
  }
}

class InputLatihanDurasiPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String id, String jenis, String klasifikasi, double waktu, double sets, DateTime tgl) onSimpan;

  const InputLatihanDurasiPage({Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan}) : super(key: key);
  @override State<InputLatihanDurasiPage> createState() => _InputLatihanDurasiPageState();
}
class _InputLatihanDurasiPageState extends State<InputLatihanDurasiPage> {
  final TextEditingController _jenisLatihanController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  String _selectedKlasifikasi = "ENDURANCE";

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Input Capaian Durasi Pelaksanaan (Waktu)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E293B),
              value: widget.selectedMuridId,
              items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text(m.nama))).toList(),
              onChanged: widget.onMuridChanged,
              decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: _jenisLatihanController, decoration: const InputDecoration(labelText: 'Jenis Drill Waktu (Plank, Kuda-kuda)', filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _waktuController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Waktu (detik)', filled: true, fillColor: Color(0xFF1E293B)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sets', filled: true, fillColor: Color(0xFF1E293B)))),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), width: double.infinity),
              onPressed: () {
                double w = double.tryParse(_waktuController.text) ?? 0;
                double s = double.tryParse(_setsController.text) ?? 0;
                widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text, _selectedKlasifikasi, w, s, DateTime.now());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Durasi Terintegrasi Dashboard!')));
              },
              child: const Text('SUBMIT WAKTU ATLET'),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== RE-DESIGNED BOXPLOT PAINTER (VERSI META GRAPH) ====================
class MetaBoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  final List<double> teamAverages;

  const MetaBoxplotChart({Key? key, required this.boxData, required this.teamAverages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 240),
      painter: _MetaBoxplotPainter(boxData: boxData, teamAverages: teamAverages),
    );
  }
}

class _MetaBoxplotPainter extends CustomPainter {
  final List<List<double>> boxData;
  final List<double> teamAverages;

  _MetaBoxplotPainter({required this.boxData, required this.teamAverages});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..color = const Color(0xFF64748B)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final boxPaint = Paint()..color = const Color(0xFF334155)..style = PaintingStyle.fill;
    final borderBoxPaint = Paint()..color = const Color(0xFF94A3B8)..strokeWidth = 1..style = PaintingStyle.stroke;
    
    // Warna Penanda Sesuai Permintaan (Biru = Atlet, Merah = Tim)
    final personalScorePaint = Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill;
    final teamMeanPaint = Paint()..color = const Color(0xFFFF1744)..style = PaintingStyle.fill;
    final medianPaint = Paint()..color = const Color(0xFF10B981)..strokeWidth = 2;

    final List<String> shortLabels = ['STR', 'END', 'SPD', 'CRD', 'FLX', 'BAL', 'REA'];
    double colWidth = size.width / 8;
    double chartHeight = size.height - 40;

    // Mapping Skala Skor Maksimal 100 ke Koordinat Pixel Y
    double getY(double val) {
      double clamped = val.clamp(0, 100);
      return (chartHeight - (clamped * (chartHeight / 100))) + 15;
    }

    // Gambar Garis Kisi Grid Horizontal Belakang
    for (int grid = 0; grid <= 100; grid += 25) {
      double gy = getY(grid.toDouble());
      canvas.drawLine(Offset(colWidth - 10, gy), Offset(size.width - 10, gy), Paint()..color = const Color(0xFF1E293B)..strokeWidth = 1);
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 7; i++) {
      double x = (i + 1) * colWidth + 10;
      
      double minVal = boxData[i][0];
      double q1Val  = boxData[i][1];
      double q2Val  = boxData[i][2]; // Median
      double personalScore = boxData[i][3]; // Skor Atlet Aktif
      double q3Val  = boxData[i][4];
      double maxVal = boxData[i][5];
      double meanTim = i < teamAverages.length ? teamAverages[i] : 50.0;

      // 1. Gambar Garis Whisker (Kumis Atas dan Bawah)
      canvas.drawLine(Offset(x, getY(minVal)), Offset(x, getY(maxVal)), linePaint);
      canvas.drawLine(Offset(x - 6, getY(minVal)), Offset(x + 6, getY(minVal)), linePaint); // Cap bawah
      canvas.drawLine(Offset(x - 6, getY(maxVal)), Offset(x + 6, getY(maxVal)), linePaint); // Cap atas

      // 2. Gambar Kotak Kuartil (Q1 ke Q3)
      canvas.drawRect(Rect.fromLTRB(x - 14, getY(q3Val), x + 14, getY(q1Val)), boxPaint);
      canvas.drawRect(Rect.fromLTRB(x - 14, getY(q3Val), x + 14, getY(q1Val)), borderBoxPaint);

      // 3. Gambar Garis Hijau (Median / Q2) Tengah Kotak
      canvas.drawLine(Offset(x - 14, getY(q2Val)), Offset(x + 14, getY(q2Val)), medianPaint);

      // 4. Plot Titik Segitiga Biru (Skor Individu Atlet Aktif)
      canvas.drawCircle(Offset(x, getY(personalScore)), 4.5, personalScorePaint);

      // 5. Plot Titik Silang Merah (Mean/Rata-Rata Anggota Tim)
      canvas.drawRect(Rect.fromCenter(center: Offset(x, getY(meanTim)), width: 7, height: 7), teamMeanPaint);

      // 6. Cetak Angka Statistik Esensial di Sisi Grafik (Kecil)
      _drawSmallText(canvas, "${personalScore.toStringAsFixed(0)}", x - 22, getY(personalScore) - 4, const Color(0xFF00E5FF));
      _drawSmallText(canvas, "${meanTim.toStringAsFixed(0)}", x + 16, getY(meanTim) - 4, const Color(0xFFFF1744));

      // Cetak Label Komponen Utama di sumbu X
      textPainter.text = TextSpan(text: shortLabels[i], style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold));
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - (textPainter.width / 2), chartHeight + 20));
    }
  }

  void _drawSmallText(Canvas canvas, String text, double x, double y, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(x, y));
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==================== REDESIGNED RADAR CHART PAINTER DENGAN ANGKA ====================
class MetaRadarChartPainter extends CustomPainter {
  final List<double> activeRadar;
  final List<double> teamRadar;

  MetaRadarChartPainter({required this.activeRadar, required this.teamRadar});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY) * 0.75;

    final baseGridPaint = Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 0.8;
    
    // Definisi Warna Kontras Komparasi
    final personalRadarPaint = Paint()..color = const Color(0xFF00E5FF).withOpacity(0.25)..style = PaintingStyle.fill;
    final personalBorderPaint = Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.stroke..strokeWidth = 2.0;

    final teamRadarPaint = Paint()..color = const Color(0xFFFF1744).withOpacity(0.15)..style = PaintingStyle.fill;
    final teamBorderPaint = Paint()..color = const Color(0xFFFF1744)..style = PaintingStyle.stroke..strokeWidth = 1.2;

    final List<String> labels = ['STR', 'END', 'SPD', 'CRD', 'FLX', 'BAL', 'REA', 'PWR', 'AGI', 'MOB'];
    final int totalPoints = labels.length;

    // Gambar Jaring-Jaring Grid Konsentris Lingkaran Dalam
    for (int g = 1; g <= 4; g++) {
      canvas.drawCircle(Offset(centerX, centerY), radius * (g / 4), baseGridPaint);
    }

    // Menggambar Jalur Poligon 1: Team Average (Merah)
    final teamPath = Path();
    for (int i = 0; i < totalPoints; i++) {
      final angle = (i * 2 * math.pi / totalPoints) - (math.pi / 2);
      double val = i < teamRadar.length ? teamRadar[i] : 0.5;
      double tx = centerX + radius * val * math.cos(angle);
      double ty = centerY + radius * val * math.sin(angle);
      if (i == 0) teamPath.moveTo(tx, ty); else teamPath.lineTo(tx, ty);
    }
    teamPath.close();
    canvas.drawPath(teamPath, teamRadarPaint);
    canvas.drawPath(teamPath, teamBorderPaint);

    // Menggambar Jalur Poligon 2: Atlet Utama Aktif (Biru)
    final personalPath = Path();
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < totalPoints; i++) {
      final angle = (i * 2 * math.pi / totalPoints) - (math.pi / 2);
      double val = i < activeRadar.length ? activeRadar[i] : 0.6;
      double px = centerX + radius * val * math.cos(angle);
      double py = centerY + radius * val * math.sin(angle);
      
      if (i == 0) personalPath.moveTo(px, py); else personalPath.lineTo(px, py);

      // Gambar Ruji Garis Penghubung Sumbu Utama
      double rx = centerX + radius * math.cos(angle);
      double ry = centerY + radius * math.sin(angle);
      canvas.drawLine(Offset(centerX, centerY), Offset(rx, ry), baseGridPaint);

      // Cetak Label Singkatan di Ujung Axis luar
      textPainter.text = TextSpan(text: labels[i], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold));
      textPainter.layout();
      double lx = centerX + (radius + 14) * math.cos(angle) - (textPainter.width / 2);
      double ly = centerY + (radius + 14) * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(lx, ly));

      // MENAMPILKAN ANGKA DESIMAL NILAI PERSIS DI TIAP SIMPUL GRAFIK RADAR
      final labelScorePainter = TextPainter(
        text: TextSpan(text: val.toStringAsFixed(2), style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 8, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr
      )..layout();
      labelScorePainter.paint(canvas, Offset(px + 4, py - 4));
    }
    personalPath.close();
    canvas.drawPath(personalPath, personalRadarPaint);
    canvas.drawPath(personalPath, personalBorderPaint);
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
