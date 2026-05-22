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

// Master List 17 Klasifikasi Sesuai Target Input
const List<String> kDaftarKlasifikasiLatihan = [
  "STRENGTH",
  "ENDURANCE",
  "SPEED",
  "COORDINATION",
  "FLEXIBILITY",
  "BALANCE",
  "REACTION TIME",
  "MUSCULAR ENDURANCE",
  "POWER",
  "CORE STABILITY",
  "DYNAMIC FLEXIBILITY",
  "SPEED ENDURANCE",
  "REACTIVE SPEED / QUICKNESS",
  "AGILITY",
  "ANTICIPATION & SPATIAL AWARENESS",
  "MOBILITY",
  "OPEN/REACTIVE AGILITY"
];

// Model Struktur Data Murid
class Murid {
  final String id;
  final String nama;
  final List<List<double>> boxData; // Index 0-6: [Min, Q1, Q2/Median, CurrentScore, Q3, Max]
  final List<double> radarData; // 10 Dimensi Nilai Atlet (0.0 - 1.0)
  
  List<Map<String, dynamic>> riwayatLatihanKuantitatif;
  List<Map<String, dynamic>> riwayatLatihanDurasi;

  Murid({
    required this.id,
    required this.nama,
    required this.boxData,
    required this.radarData,
    List<Map<String, dynamic>>? riwayatLatihanKuatitatif,
    List<Map<String, dynamic>>? riwayatLatihanDurasi,
  })  : this.riwayatLatihanKuantitatif = riwayatLatihanKuatitatif ?? [],
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
          [18.0, 32.0, 45.0, 50.0, 58.0, 76.0], // COORDINATION
          [22.0, 38.0, 50.0, 40.0, 62.0, 78.0], // FLEXIBILITY
          [12.0, 28.0, 40.0, 65.0, 55.0, 72.0], // BALANCE
          [28.0, 42.0, 56.0, 80.0, 68.0, 92.0], // REACTION TIME
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

  List<double> get _teamAverageBoxScores {
    List<double> averages = List.generate(7, (_) => 0.0);
    if (_daftarMurid.isEmpty) return averages;
    for (int i = 0; i < 7; i++) {
      double sum = 0;
      for (var murid in _daftarMurid) {
        if (i < murid.boxData.length && murid.boxData[i].length > 3) {
          sum += murid.boxData[i][3];
        }
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
        if (i < murid.radarData.length) {
          sum += murid.radarData[i];
        }
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
        radarData: List.generate(10, (_) => 0.5),
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
    if (upper == "STRENGTH" || upper == "POWER" || upper == "CORE STABILITY") return 0;
    if (upper == "ENDURANCE" || upper == "MUSCULAR ENDURANCE") return 1;
    if (upper == "SPEED" || upper == "SPEED ENDURANCE") return 2;
    if (upper == "COORDINATION" || upper == "ANTICIPATION & SPATIAL AWARENESS") return 3;
    if (upper == "FLEXIBILITY" || upper == "DYNAMIC FLEXIBILITY") return 4;
    if (upper == "BALANCE") return 5;
    if (upper == "REACTION TIME" || upper == "REACTIVE SPEED / QUICKNESS") return 6;
    return -1;
  }

  void _simpanDataKuantitatif(String idMurid, String jenis, String klasifikasi, double reps, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skorKalkulasi = reps * sets;
        _daftarMurid[idx].riwayatLatihanKuantitatif.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klasifikasi, 'skor': skorKalkulasi
        });
        
        int boxIdx = _dapatkanBoxIndex(klasifikasi);
        if (boxIdx != -1) {
          _daftarMurid[idx].boxData[boxIdx][3] = skorKalkulasi;
          double normalisasi = (skorKalkulasi / 100).clamp(0.0, 1.0);
          if (boxIdx < _daftarMurid[idx].radarData.length) {
            _daftarMurid[idx].radarData[boxIdx] = normalisasi;
          }
        } else {
          double normalisasi = (skorKalkulasi / 100).clamp(0.0, 1.0);
          if (klasifikasi.contains("AGILITY") && !klasifikasi.contains("OPEN")) _daftarMurid[idx].radarData[8] = normalisasi;
          if (klasifikasi.contains("MOBILITY")) _daftarMurid[idx].radarData[9] = normalisasi;
          if (klasifikasi.contains("OPEN")) _daftarMurid[idx].radarData[2] = normalisasi;
        }
        _selectedMuridId = idMurid;
      }
    });
  }

  void _simpanDataDurasi(String idMurid, String jenis, String klasifikasi, double waktu, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == idMurid);
      if (idx != -1) {
        double skorKalkulasi = waktu * sets;
        _daftarMurid[idx].riwayatLatihanDurasi.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klasifikasi, 'skor': skorKalkulasi
        });
        
        int boxIdx = _dapatkanBoxIndex(klasifikasi);
        if (boxIdx != -1) {
          _daftarMurid[idx].boxData[boxIdx][3] = skorKalkulasi;
          double normalisasi = (skorKalkulasi / 100).clamp(0.0, 1.0);
          if (boxIdx < _daftarMurid[idx].radarData.length) {
            _daftarMurid[idx].radarData[boxIdx] = normalisasi;
          }
        } else {
          double normalisasi = (skorKalkulasi / 100).clamp(0.0, 1.0);
          if (klasifikasi.contains("AGILITY") && !klasifikasi.contains("OPEN")) _daftarMurid[idx].radarData[8] = normalisasi;
          if (klasifikasi.contains("MOBILITY")) _daftarMurid[idx].radarData[9] = normalisasi;
          if (klasifikasi.contains("OPEN")) _daftarMurid[idx].radarData[2] = normalisasi;
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Identitas Atlet
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text('COMPREHENSIVE PERFORMANCE DASHBOARD', style: TextStyle(color: Colors.blueGrey[300], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text('${activeMurid.id} - ${activeMurid.nama}', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Boxplot Panel
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DISTRIBUSI MOTORIK TIM VS INDIVIDU (BOXPLOT)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8))),
                  const SizedBox(height: 12),
                  SizedBox(height: 250, child: MetaBoxplotChart(boxData: activeMurid.boxData, teamAverages: teamBoxAverages)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Radar Panel
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
                      painter: MetaRadarChartPainter(activeRadar: activeMurid.radarData, teamRadar: teamRadarAverages),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ==================== RE-STRUCTURED FEATURE: MATRIKS KOLOM 6 SEKTOR INDUK ====================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MATRIKS KONTROL PERUBAHAN DATA ATLET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1050, 
                      child: Table(
                        border: TableBorder.all(color: const Color(0xFF334155), width: 1),
                        columnWidths: const {
                          0: FlexColumnWidth(1.8), 
                          1: FlexColumnWidth(1.4), 
                          2: FlexColumnWidth(2.0), 
                          3: FlexColumnWidth(2.0), 
                          4: FlexColumnWidth(2.0), 
                          5: FlexColumnWidth(2.8), 
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                            children: [
                              _buildHeaderCell('KOMPONEN'),
                              _buildHeaderCell('POLA BOXPLOT'),
                              _buildHeaderCell('SKOR'),
                              _buildHeaderCell('KELEBIHAN'),
                              _buildHeaderCell('KEKURANGAN'),
                              _buildHeaderCell('REKOMENDASI'),
                            ],
                          ),
                          
                          _buildEvaluasiRow('STRENGTH', 'STRENGTH', 'BOXPLOT', 0),
                          _buildEvaluasiRow('ENDURANCE', 'ENDURANCE', 'BOXPLOT', 1),
                          _buildEvaluasiRow('SPEED', 'SPEED', 'BOXPLOT', 2),
                          _buildEvaluasiRow('COORDINATION', 'COORDINATION', 'BOXPLOT', 3),
                          _buildEvaluasiRow('FLEXIBILITY', 'FLEXIBILITY', 'BOXPLOT', 4),
                          _buildEvaluasiRow('BALANCE', 'BALANCE', 'BOXPLOT', 5),
                          _buildEvaluasiRow('REACTION TIME', 'REACTION TIME', 'BOXPLOT', 6),
                          
                          _buildEvaluasiRow('MUSCULAR ENDURANCE', 'ENDURANCE', 'BOXPLOT', 1),
                          _buildEvaluasiRow('POWER', 'STRENGTH', 'BOXPLOT', 0),
                          _buildEvaluasiRow('CORE STABILITY', 'STRENGTH', 'BOXPLOT', 0),
                          _buildEvaluasiRow('DYNAMIC FLEXIBILITY', 'FLEXIBILITY', 'BOXPLOT', 4),
                          _buildEvaluasiRow('SPEED ENDURANCE', 'SPEED', 'BOXPLOT', 2),
                          _buildEvaluasiRow('REACTIVE SPEED / QUICKNESS', 'REACTION TIME', 'BOXPLOT', 6),
                          _buildEvaluasiRow('ANTICIPATION & SPATIAL AWARENESS', 'COORDINATION', 'BOXPLOT', 3),
                          
                          _buildEvaluasiRow('AGILITY', '-', 'RADAR', 8),
                          _buildEvaluasiRow('MOBILITY', '-', 'RADAR', 9),
                          _buildEvaluasiRow('OPEN/REACTIVE AGILITY', '-', 'RADAR', 2),
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
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 9, fontWeight: FontWeight.bold)));
  }

  TableRow _buildEvaluasiRow(String namaKomponen, String polaBoxplot, String tipeGrafik, int dataIdx) {
    String skorTeks = "0";
    bool diAtasRataTim = false;
    
    // Validasi super aman agar tidak memicu Out of Bounds Error saat murid baru di-render
    if (tipeGrafik == "BOXPLOT") {
      if (dataIdx < activeMurid.boxData.length && activeMurid.boxData[dataIdx].length >= 4) {
        double q1 = activeMurid.boxData[dataIdx][1];
        double q2 = activeMurid.boxData[dataIdx][2];
        double sk = activeMurid.boxData[dataIdx][3];
        double avg = dataIdx < teamBoxAverages.length ? teamBoxAverages[dataIdx] : 0.0;
        diAtasRataTim = sk >= avg;
        skorTeks = "Q1:${q1.toStringAsFixed(0)} | Q2:${q2.toStringAsFixed(0)} | S:${sk.toStringAsFixed(0)}";
      } else {
        skorTeks = "Q1:0 | Q2:0 | S:0";
      }
    } else {
      if (dataIdx < activeMurid.radarData.length) {
        double radVal = activeMurid.radarData[dataIdx];
        double avg = dataIdx < teamRadarAverages.length ? teamRadarAverages[dataIdx] : 0.0;
        diAtasRataTim = radVal >= avg;
        skorTeks = "Radar: ${radVal.toStringAsFixed(2)}";
      } else {
        skorTeks = "Radar: 0.00";
      }
    }

    String kelebihanText = diAtasRataTim ? "Kapasitas fungsional optimal di atas target tim harian." : "Stabilitas gerak dasar atlet konsisten.";
    String kekuranganText = !diAtasRataTim ? "Defisit volume energi dibanding target rata-rata tim." : "Memerlukan variasi stimulus beban lanjutan.";
    
    String rekomendasiText = diAtasRataTim 
        ? "UPGRADE: Naikkan intensitas sikit gerakan fungsional bervariasi untuk menjaga keunggulan fisik dominan."
        : "BALANCING: Tambahkan porsi latihan beban terarah khusus area $namaKomponen untuk menyeimbangkan ketertinggalan.";

    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(6.0), child: Text("$namaKomponen ($tipeGrafik)", style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(polaBoxplot, style: TextStyle(color: polaBoxplot == '-' ? Colors.white30 : Colors.amber[400], fontSize: 8, fontWeight: FontWeight.w600))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(skorTeks, style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 8, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(kelebihanText, style: const TextStyle(color: Color(0xFF10B981), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(kekuranganText, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(6.0), child: Text(rekomendasiText, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8))),
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

// ==================== HALAMAN 3: INPUT REPETISI ====================
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('Input Capaian Kuantitatif (Reps * Sets)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFA855F7)))),
            const SizedBox(height: 16),
            const Text("Pilih Atlet:", style: TextStyle(fontSize: 11, color: Colors.white70)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E293B),
              value: widget.selectedMuridId,
              items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text(m.nama))).toList(),
              onChanged: widget.onMuridChanged,
              decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            const Text("Klasifikasi Fokus Motorik (17 Opsi):", style: TextStyle(fontSize: 11, color: Colors.white70)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E293B),
              value: _selectedKlasifikasi,
              items: kDaftarKlasifikasiLatihan.map((opsi) => DropdownMenuItem(value: opsi, child: Text(opsi, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (val) => setState(() => _selectedKlasifikasi = val!),
              decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: _jenisLatihanController, decoration: const InputDecoration(labelText: 'Nama Gerakan Mandiri (e.g., Push Up)', filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _repsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Repetisi', filled: true, fillColor: Color(0xFF1E293B)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Sets', filled: true, fillColor: Color(0xFF1E293B)))),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA855F7)),
                onPressed: () {
                  double r = double.tryParse(_repsController.text) ?? 0;
                  double s = double.tryParse(_setsController.text) ?? 0;
                  widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text, _selectedKlasifikasi, r, s, DateTime.now());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data $_selectedKlasifikasi Sukses Terkalkulasi!')));
                },
                child: const Text('SIMPAN & KALKULASI DATA REPS', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== HALAMAN 4: INPUT DURASI WAKTU ====================
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('Input Capaian Durasi (Waktu * Sets)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4)))),
            const SizedBox(height: 16),
            const Text("Pilih Atlet:", style: TextStyle(fontSize: 11, color: Colors.white70)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E293B),
              value: widget.selectedMuridId,
              items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text(m.nama))).toList(),
              onChanged: widget.onMuridChanged,
              decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            const Text("Klasifikasi Fokus Motorik (17 Opsi):", style: TextStyle(fontSize: 11, color: Colors.white70)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E293B),
              value: _selectedKlasifikasi,
              items: kDaftarKlasifikasiLatihan.map((opsi) => DropdownMenuItem(value: opsi, child: Text(opsi, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (val) => setState(() => _selectedKlasifikasi = val!),
              decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E293B), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: _jenisLatihanController, decoration: const InputDecoration(labelText: 'Jenis Drill (e.g., Plank)', filled: true, fillColor: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _waktuController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Waktu (detik)', filled: true, fillColor: Color(0xFF1E293B)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Sets', filled: true, fillColor: Color(0xFF1E293B)))),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4)),
                onPressed: () {
                  double w = double.tryParse(_waktuController.text) ?? 0;
                  double s = double.tryParse(_setsController.text) ?? 0;
                  widget.onSimpan(widget.selectedMuridId, _jenisLatihanController.text, _selectedKlasifikasi, w, s, DateTime.now());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kalkulasi Durasi $_selectedKlasifikasi Masuk Dashboard!')));
                },
                child: const Text('SIMPAN & KALKULASI DATA WAKTU', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== RENDERING DIAGRAM BOXPLOT UTUH ====================
class MetaBoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  final List<double> teamAverages;

  const MetaBoxplotChart({Key? key, required this.boxData, required this.teamAverages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(double.infinity, 250), painter: _MetaBoxplotPainter(boxData: boxData, teamAverages: teamAverages));
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
    
    final personalScorePaint = Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill;
    final teamMeanPaint = Paint()..color = const Color(0xFFFF1744)..style = PaintingStyle.fill;
    final medianPaint = Paint()..color = const Color(0xFF10B981)..strokeWidth = 2;

    final List<String> longLabels = ['STRENGTH', 'ENDURANCE', 'SPEED', 'COORDINATION', 'FLEXIBILITY', 'BALANCE', 'REACTION TIME'];
    double colWidth = size.width / 8;
    double chartHeight = size.height - 60;

    double getY(double val) {
      return (chartHeight - (val.clamp(0, 100) * (chartHeight / 100))) + 15;
    }

    for (int grid = 0; grid <= 100; grid += 25) {
      double gy = getY(grid.toDouble());
      canvas.drawLine(Offset(colWidth - 10, gy), Offset(size.width - 10, gy), Paint()..color = const Color(0xFF1E293B));
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 7; i++) {
      if (i >= boxData.length || boxData[i].length < 6) continue;
      double x = (i + 1) * colWidth + 10;
      canvas.drawLine(Offset(x, getY(boxData[i][0])), Offset(x, getY(boxData[i][5])), linePaint);
      canvas.drawRect(Rect.fromLTRB(x - 12, getY(boxData[i][4]), x + 12, getY(boxData[i][1])), boxPaint);
      canvas.drawRect(Rect.fromLTRB(x - 12, getY(boxData[i][4]), x + 12, getY(boxData[i][1])), borderBoxPaint);
      canvas.drawLine(Offset(x - 12, getY(boxData[i][2])), Offset(x + 12, getY(boxData[i][2])), medianPaint);
      canvas.drawCircle(Offset(x, getY(boxData[i][3])), 4.5, personalScorePaint);
      
      double teamAvgValue = i < teamAverages.length ? teamAverages[i] : 0.0;
      canvas.drawRect(Rect.fromCenter(center: Offset(x, getY(teamAvgValue)), width: 7, height: 7), teamMeanPaint);

      canvas.save();
      canvas.translate(x, chartHeight + 22);
      canvas.rotate(0.35);
      textPainter.text = TextSpan(text: longLabels[i], style: const TextStyle(color: Colors.white70, fontSize: 7, fontWeight: FontWeight.bold));
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
      canvas.restore();
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==================== RENDERING DIAGRAM RADAR (SAFE FIX) ====================
class MetaRadarChartPainter extends CustomPainter {
  final List<double> activeRadar;
  final List<double> teamRadar;
  MetaRadarChartPainter({required this.activeRadar, required this.teamRadar});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY) * 0.75;
    final baseGridPaint = Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke;
    final personalBorderPaint = Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final teamBorderPaint = Paint()..color = const Color(0xFFFF1744)..style = PaintingStyle.stroke..strokeWidth = 1.2;

    for (int g = 1; g <= 4; g++) canvas.drawCircle(Offset(centerX, centerY), radius * (g / 4), baseGridPaint);

    final teamPath = Path();
    final personalPath = Path();

    // Dibatasi dengan aman memakai nilai maksimum elemen yang tersedia
    int loopBound = math.min(10, math.min(activeRadar.length, teamRadar.length));

    for (int i = 0; i < loopBound; i++) {
      final angle = (i * 2 * math.pi / 10) - (math.pi / 2);
      double tx = centerX + radius * teamRadar[i] * math.cos(angle);
      double ty = centerY + radius * teamRadar[i] * math.sin(angle);
      if (i == 0) teamPath.moveTo(tx, ty); else teamPath.lineTo(tx, ty);

      double px = centerX + radius * activeRadar[i] * math.cos(angle);
      double py = centerY + radius * activeRadar[i] * math.sin(angle);
      if (i == 0) personalPath.moveTo(px, py); else personalPath.lineTo(px, py);

      canvas.drawLine(Offset(centerX, centerY), Offset(centerX + radius * math.cos(angle), centerY + radius * math.sin(angle)), baseGridPaint);
    }
    
    if (loopBound > 0) {
      teamPath.close(); 
      personalPath.close();
      canvas.drawPath(teamPath, teamBorderPaint);
      canvas.drawPath(personalPath, personalBorderPaint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
