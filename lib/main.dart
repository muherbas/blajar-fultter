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
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationHolder(),
    );
  }
}

const List<String> kDaftarKlasifikasiLatihan = [
  "STRENGTH", "ENDURANCE", "SPEED", "COORDINATION", "FLEXIBILITY", "BALANCE", "REACTION TIME",
  "MUSCULAR ENDURANCE", "POWER", "CORE STABILITY", "DYNAMIC FLEXIBILITY", "SPEED ENDURANCE",
  "REACTIVE SPEED / QUICKNESS", "AGILITY", "ANTICIPATION & SPATIAL AWARENESS", "MOBILITY", "OPEN/REACTIVE AGILITY"
];

class Murid {
  final String id;
  final String nama;
  final List<List<double>> boxData; 
  final List<double> radarData; 
  List<Map<String, dynamic>> riwayatLatihanKuantitatif;
  List<Map<String, dynamic>> riwayatLatihanDurasi;

  Murid({
    required this.id, required this.nama, required this.boxData, required this.radarData,
    List<Map<String, dynamic>>? riwayatLatihanKuantitatif,
    List<Map<String, dynamic>>? riwayatLatihanDurasi,
  })  : this.riwayatLatihanKuantitatif = riwayatLatihanKuantitatif ?? [],
        this.riwayatLatihanDurasi = riwayatLatihanDurasi ?? [];
}

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);
  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0; 
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
        id: "001", nama: "BUDI SANTOSO",
        boxData: [
          [20.0, 35.0, 48.0, 0.0, 60.0, 85.0],
          [25.0, 40.0, 52.0, 0.0, 65.0, 88.0],
          [30.0, 42.0, 65.0, 0.0, 75.0, 90.0],
          [18.0, 32.0, 45.0, 0.0, 58.0, 76.0],
          [22.0, 48.0, 52.0, 0.0, 56.0, 78.0],
          [12.0, 38.0, 40.0, 0.0, 42.0, 72.0],
          [28.0, 42.0, 56.0, 0.0, 68.0, 92.0],
        ],
        radarData: List.generate(10, (_) => 0.0),
      ),
      Murid(
        id: "100", nama: "RURI",
        boxData: [
          [20.0, 35.0, 50.0, 0.0, 65.0, 85.0],
          [25.0, 40.0, 55.0, 0.0, 70.0, 90.0],
          [22.0, 38.0, 48.0, 0.0, 62.0, 86.0],
          [15.0, 30.0, 42.0, 0.0, 58.0, 75.0],
          [20.0, 35.0, 50.0, 0.0, 65.0, 88.0],
          [18.0, 32.0, 46.0, 0.0, 60.0, 78.0],
          [25.0, 40.0, 52.0, 0.0, 66.0, 90.0],
        ],
        radarData: List.generate(10, (_) => 0.0),
      ),
    ];
  }

  Murid get _currentMurid => _daftarMurid.firstWhere((m) => m.id == _selectedMuridId, orElse: () => _daftarMurid.first);

  List<double> get _teamAverageBoxScores {
    List<double> averages = List.generate(7, (_) => 0.0);
    if (_daftarMurid.isEmpty) return averages;
    for (int i = 0; i < 7; i++) {
      double sum = 0;
      int count = 0;
      for (var murid in _daftarMurid) {
        if (i < murid.boxData.length && murid.boxData[i].length > 3) {
          if (murid.boxData[i][3] > 0) { 
            sum += murid.boxData[i][3];
            count++;
          }
        }
      }
      averages[i] = count > 0 ? sum / count : 0.0;
    }
    return averages;
  }

  List<double> get _teamAverageRadar {
    List<double> averages = List.generate(10, (_) => 0.0);
    if (_daftarMurid.isEmpty) return averages;
    for (int i = 0; i < 10; i++) {
      double sum = 0;
      int count = 0;
      for (var murid in _daftarMurid) {
        if (i < murid.radarData.length) {
          if (murid.radarData[i] > 0) {
            sum += murid.radarData[i];
            count++;
          }
        }
      }
      averages[i] = count > 0 ? sum / count : 0.0;
    }
    return averages;
  }

  int _dapatkanBoxIndex(String klasifikasi) {
    final String upper = klasifikasi.toUpperCase();
    if (upper == "STRENGTH" || upper == "POWER" || upper == "CORE STABILITY") return 0;
    if (upper == "ENDURANCE" || upper == "MUSCULAR ENDURANCE") return 1;
    if (upper == "SPEED" || upper == "SPEED ENDURANCE") return 2;
    if (upper == "COORDINATION" || upper == "ANTICIPATION & SPATIAL AWARENESS") return 3;
    if (upper == "FLEXIBILITY" || upper == "DYNAMIC FLEXIBILITY") return 4;
    if (upper == "BALANCE") return 5;
    if (upper == "REACTION TIME" || upper == "REACTIVE SPEED / QUICKNESS") return 6;
    return -1;
  }

  void _simpanDataKuantitatif(String id, String jenis, String klas, double reps, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == id);
      if (idx != -1) {
        double skor = reps * sets;
        _daftarMurid[idx].riwayatLatihanKuantitatif.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klas, 'skor': skor, 'isReps': true
        });

        int bIdx = _dapatkanBoxIndex(klas);
        if (bIdx != -1) {
          _daftarMurid[idx].boxData[bIdx][3] = skor;
          _daftarMurid[idx].radarData[bIdx] = (skor / 100).clamp(0.0, 1.0);
        } else {
          double normalisasi = (skor / 100).clamp(0.0, 1.0);
          if (klas.contains("AGILITY") && !klas.contains("OPEN")) _daftarMurid[idx].radarData[8] = normalisasi;
          if (klas.contains("MOBILITY")) _daftarMurid[idx].radarData[9] = normalisasi;
          if (klas.contains("OPEN")) _daftarMurid[idx].radarData[2] = normalisasi;
        }
        _selectedMuridId = id;
      }
    });
  }

  void _simpanDataDurasi(String id, String jenis, String klas, double waktu, double sets, DateTime tgl) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == id);
      if (idx != -1) {
        double skor = waktu * sets;
        _daftarMurid[idx].riwayatLatihanDurasi.add({
          'tanggal': tgl, 'jenis': jenis, 'klasifikasi': klas, 'skor': skor, 'isReps': false
        });

        int bIdx = _dapatkanBoxIndex(klas);
        if (bIdx != -1) {
          _daftarMurid[idx].boxData[bIdx][3] = skor;
          _daftarMurid[idx].radarData[bIdx] = (skor / 100).clamp(0.0, 1.0);
        } else {
          double normalisasi = (skor / 100).clamp(0.0, 1.0);
          if (klas.contains("AGILITY") && !klas.contains("OPEN")) _daftarMurid[idx].radarData[8] = normalisasi;
          if (klas.contains("MOBILITY")) _daftarMurid[idx].radarData[9] = normalisasi;
          if (klas.contains("OPEN")) _daftarMurid[idx].radarData[2] = normalisasi;
        }
        _selectedMuridId = id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Murid> filtered = _daftarMurid.where((m) => m.nama.contains(_searchQuery.toUpperCase()) || m.id.contains(_searchQuery)).toList();

    final List<Widget> pages = [
      DashboardAtletPage(activeMurid: _currentMurid, teamBoxAverages: _teamAverageBoxScores, teamRadarAverages: _teamAverageRadar, dapatkanBoxIndexFunc: _dapatkanBoxIndex),
      DaftarMuridPage(
        daftarMurid: filtered, selectedId: _selectedMuridId, namaController: _namaController, searchController: _searchController,
        onSearchChanged: (v) => setState(() => _searchQuery = v),
        onSelect: (id) => setState(() { _selectedMuridId = id; _currentIndex = 0; }), 
        onDelete: (m) => setState(() => _daftarMurid.remove(m)),
        onAdd: () {
          if (_namaController.text.trim().isEmpty) return;
          setState(() {
            int maxId = 0;
            for (var m in _daftarMurid) {
              int? cId = int.tryParse(m.id);
              if (cId != null && cId > maxId) maxId = cId;
            }
            String nextId = (maxId + 1).toString().padLeft(3, '0');
            _daftarMurid.add(Murid(id: nextId, nama: _namaController.text.trim().toUpperCase(), boxData: List.generate(7, (_) => [20, 35, 50, 0, 65, 85]), radarData: List.generate(10, (_) => 0.0)));
          });
          _namaController.clear();
        },
      ),
      InputLatihanKuantitatifPage(daftarMurid: _daftarMurid, selectedMuridId: _selectedMuridId, onMuridChanged: (id) => setState(() => _selectedMuridId = id!), onSimpan: _simpanDataKuantitatif),
      InputLatihanDurasiPage(daftarMurid: _daftarMurid, selectedMuridId: _selectedMuridId, onMuridChanged: (id) => setState(() => _selectedMuridId = id!), onSimpan: _simpanDataDurasi),
      TimelineHistoryPage(activeMurid: _currentMurid), 
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF1E293B), 
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: const Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'DASHBOARD'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'DAFTAR SISWA'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'INPUT REPS'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'INPUT WAKTU'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'HISTORY'),
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
  final int Function(String) dapatkanBoxIndexFunc;

  const DashboardAtletPage({Key? key, required this.activeMurid, required this.teamBoxAverages, required this.teamRadarAverages, required this.dapatkanBoxIndexFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155), width: 1), 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'COMPREHENSIVE PERFORMANCE DASHBOARD',
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${activeMurid.id} - ${activeMurid.nama}',
                    style: const TextStyle(
                      color: Color(0xFF38BDF8), 
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 16, color: const Color(0xFF38BDF8)),
                      const SizedBox(width: 8),
                      const Text(
                        'DISTRIBUSI MOTORIK TIM VS INDIVIDU (BOXPLOT)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 250, child: MetaBoxplotChart(boxData: activeMurid.boxData, teamAverages: teamBoxAverages)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 16, color: const Color(0xFF22C55E)), 
                      const SizedBox(width: 8),
                      const Text(
                        'PROFIL BIOMOTORIK METRIKS RADAR (10 DIMENSI)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF22C55E)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 16, color: const Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      const Text(
                        'MATRIKS ANALISIS GERAK & REKOMENDASI TAKTIS',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 1050, 
                      child: Table(
                        border: TableBorder.all(color: const Color(0xFF334155), width: 1), 
                        columnWidths: const {
                          0: FlexColumnWidth(1.8),
                          1: FlexColumnWidth(2.3),
                          2: FlexColumnWidth(2.5),
                          3: FlexColumnWidth(2.3),
                          4: FlexColumnWidth(2.3),
                          5: FlexColumnWidth(3.4)
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFF0F172A)), 
                            children: [
                              _buildHeaderCell('KOMPONEN'),
                              _buildHeaderCell('POLA BOXPLOT'),
                              _buildHeaderCell('ARTI POLA'),
                              _buildHeaderCell('KELEBIHAN'),
                              _buildHeaderCell('KEKURANGAN'),
                              _buildHeaderCell('REKOMENDASI')
                            ],
                          ),
                          _buildEvaluasiRow('STRENGTH', 'BOXPLOT', 0),
                          _buildEvaluasiRow('ENDURANCE', 'BOXPLOT', 1),
                          _buildEvaluasiRow('SPEED', 'BOXPLOT', 2),
                          _buildEvaluasiRow('COORDINATION', 'BOXPLOT', 3),
                          _buildEvaluasiRow('FLEXIBILITY', 'BOXPLOT', 4),
                          _buildEvaluasiRow('BALANCE', 'BOXPLOT', 5),
                          _buildEvaluasiRow('REACTION TIME', 'BOXPLOT', 6),
                          _buildEvaluasiRow('MUSCULAR ENDURANCE', 'BOXPLOT', 1),
                          _buildEvaluasiRow('POWER', 'BOXPLOT', 0),
                          _buildEvaluasiRow('CORE STABILITY', 'BOXPLOT', 0),
                          _buildEvaluasiRow('DYNAMIC FLEXIBILITY', 'BOXPLOT', 4),
                          _buildEvaluasiRow('SPEED ENDURANCE', 'BOXPLOT', 2),
                          _buildEvaluasiRow('REACTIVE SPEED / QUICKNESS', 'BOXPLOT', 6),
                          _buildEvaluasiRow('ANTICIPATION & SPATIAL AWARENESS', 'BOXPLOT', 3),
                          _buildEvaluasiRow('AGILITY', 'RADAR', 8),
                          _buildEvaluasiRow('MOBILITY', 'RADAR', 9),
                          _buildEvaluasiRow('OPEN/REACTIVE AGILITY', 'RADAR', 2),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Map<String, String> _analisisKomplet40Pola(int idx, String namaKomponen) {
    bool adaDataInput = activeMurid.riwayatLatihanKuantitatif.any((e) => e['klasifikasi'].toString().toUpperCase() == namaKomponen.toUpperCase() || dapatkanBoxIndexFunc(e['klasifikasi'].toString()) == idx) ||
                        activeMurid.riwayatLatihanDurasi.any((e) => e['klasifikasi'].toString().toUpperCase() == namaKomponen.toUpperCase() || dapatkanBoxIndexFunc(e['klasifikasi'].toString()) == idx) ||
                        (activeMurid.boxData[idx][3] > 0);

    if (!adaDataInput || idx >= activeMurid.boxData.length) {
      return {"pola": "Belum Ada Data", "arti": "Menunggu input performa fungsional dari latihan."};
    }

    final List<double> data = activeMurid.boxData[idx];
    double min = data[0]; double q1 = data[1]; double q2 = data[2]; double q3 = data[4]; double max = data[5];
    double dLower = q2 - q1; double dUpper = q3 - q2; double iqr = q3 - q1; double wLower = q1 - min; double wUpper = max - q3;

    String skew = ""; String kurtosis = "";
    if ((dUpper - dLower).abs() <= 2.0 && (wUpper - wLower).abs() <= 3.0) skew = "Symmetrical";
    else if (dUpper > dLower && wUpper > wLower) skew = "Extremely Skewed Right";
    else if (dUpper > dLower) skew = "Mildly Skewed Right";
    else if (dLower > dUpper && wLower > wUpper) skew = "Extremely Skewed Left";
    else skew = "Mildly Skewed Left";

    if (iqr < 10) kurtosis = "Leptokurtic (Narrow)";
    else if (iqr > 38) kurtosis = "Platykurtic (Wide)";
    else kurtosis = "Mesokurtic (Optimal)";

    return {"pola": "$skew - $kurtosis", "arti": "Kombinasi adaptasi sirkuit & fluktuatif atlet fisik."};
  }

  TableRow _buildEvaluasiRow(String namaKomponen, String tipeGrafik, int dataIdx) {
    bool diAtasRataTim = false; bool belumAdaData = true; String labelPola = "-"; String labelArti = "-";
    bool adaDataDiInput = activeMurid.riwayatLatihanKuantitatif.any((e) => e['klasifikasi'].toString().toUpperCase() == namaKomponen.toUpperCase() || dapatkanBoxIndexFunc(e['klasifikasi'].toString()) == dataIdx) ||
                        activeMurid.riwayatLatihanDurasi.any((e) => e['klasifikasi'].toString().toUpperCase() == namaKomponen.toUpperCase() || dapatkanBoxIndexFunc(e['klasifikasi'].toString()) == dataIdx) ||
                        (tipeGrafik == "BOXPLOT" && dataIdx < activeMurid.boxData.length && activeMurid.boxData[dataIdx][3] > 0) ||
                        (tipeGrafik == "RADAR" && dataIdx < activeMurid.radarData.length && activeMurid.radarData[dataIdx] > 0);

    if (tipeGrafik == "BOXPLOT") {
      Map<String, String> hasilPola = _analisisKomplet40Pola(dataIdx, namaKomponen);
      labelPola = hasilPola["pola"]!; labelArti = hasilPola["arti"]!;
      if (adaDataDiInput && dataIdx < activeMurid.boxData.length) {
        belumAdaData = false;
        diAtasRataTim = activeMurid.boxData[dataIdx][3] >= (dataIdx < teamBoxAverages.length ? teamBoxAverages[dataIdx] : 0.0);
      }
    } else {
      if (adaDataDiInput && dataIdx < activeMurid.radarData.length) {
        belumAdaData = false;
        diAtasRataTim = activeMurid.radarData[dataIdx] >= (dataIdx < teamRadarAverages.length ? teamRadarAverages[dataIdx] : 0.0);
      }
    }

    String kelebihanText = belumAdaData ? "Data rekam kosong." : (diAtasRataTim ? "Kapasitas fungsional optimal di atas target rata-rata." : "Stabilitas gerak dasar atlet konsisten.");
    String kekuranganText = belumAdaData ? "Menunggu uji fisik." : (!diAtasRataTim ? "Defisit volume energi dibanding target rata-rata tim." : "Memerlukan variasi stimulus beban lanjutan.");
    String rekomendasiText = belumAdaData ? "Silakan masukkan data latihan siswa di tab REPS / WAKTU." : "UPGRADE / BALANCING program sirkuit.";

    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(namaKomponen, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold))),
        // DI SINI PERBAIKANNYA: Mengubah Colors.white20 menjadi const Color(0x33FFFFFF)
        Padding(padding: const EdgeInsets.all(8.0), child: Text(labelPola, style: TextStyle(color: belumAdaData ? const Color(0x33FFFFFF) : Colors.amber[400], fontSize: 8))),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(labelArti, style: TextStyle(color: belumAdaData ? const Color(0x33FFFFFF) : const Color(0xFF34D399), fontSize: 8))),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(kelebihanText, style: const TextStyle(fontSize: 8.5, color: Colors.white70))),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(kekuranganText, style: const TextStyle(fontSize: 8.5, color: Colors.white70))),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(rekomendasiText, style: const TextStyle(fontSize: 8.5, color: Color(0xFF38BDF8)))),
      ],
    );
  }
}

// ==================== HALAMAN 5: HISTORY TIMELINE ====================
class TimelineHistoryPage extends StatelessWidget {
  final Murid activeMurid;
  const TimelineHistoryPage({Key? key, required this.activeMurid}) : super(key: key);

  String _formatTanggalManual(DateTime dt) {
    final List<String> bulan = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
    return "${dt.day.toString().padLeft(2, '0')} ${bulan[dt.month - 1]} ${dt.year} | ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> allHistory = [...activeMurid.riwayatLatihanKuantitatif, ...activeMurid.riwayatLatihanDurasi];
    allHistory.sort((a, b) => (b['tanggal'] as DateTime).compareTo(a['tanggal'] as DateTime));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: Text("HISTORY TIMELINE: ${activeMurid.nama}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), backgroundColor: const Color(0xFF1E293B), centerTitle: true),
      body: allHistory.isEmpty
          ? const Center(child: Text("Belum ada riwayat latihan manual.", style: TextStyle(color: Colors.white54)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allHistory.length,
              itemBuilder: (context, index) {
                final item = allHistory[index];
                final bool isReps = item['isReps'] ?? true;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: isReps ? Colors.cyan : Colors.orange, shape: BoxShape.circle)),
                      Container(width: 2, height: 70, color: Colors.blueGrey.withOpacity(0.3)),
                    ]),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(item['klasifikasi'], style: TextStyle(color: isReps ? Colors.cyan : Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
                            Text(_formatTanggalManual(item['tanggal']), style: const TextStyle(color: Colors.white38, fontSize: 10)),
                          ]),
                          const Divider(color: Colors.white10),
                          Text(item['jenis'].toString().toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          Text("Capaian: ${item['skor'].toStringAsFixed(0)} ${isReps ? 'Reps' : 'Detik'}", style: const TextStyle(fontSize: 12, color: Color(0xFF10B981))),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

// ==================== HALAMAN 2: DAFTAR SISWA ====================
class DaftarMuridPage extends StatelessWidget {
  final List<Murid> daftarMurid;
  final String selectedId;
  final TextEditingController namaController, searchController;
  final ValueChanged<String> onSearchChanged;
  final Function(String) onSelect;
  final Function(Murid) onDelete;
  final VoidCallback onAdd;

  const DaftarMuridPage({Key? key, required this.daftarMurid, required this.selectedId, required this.namaController, required this.searchController, required this.onSearchChanged, required this.onSelect, required this.onDelete, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController, 
              onChanged: onSearchChanged, 
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari Murid...', 
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38), 
                fillColor: const Color(0xFF1E293B),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: namaController, 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'NAMA BARU', 
                    hintStyle: const TextStyle(color: Colors.white38),
                    fillColor: const Color(0xFF1E293B),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onAdd, 
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), 
                child: const Text("DAFTAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: daftarMurid.length,
                itemBuilder: (context, i) {
                  final m = daftarMurid[i];
                  final bool isSelected = m.id == selectedId;
                  return Card(
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155), width: isSelected ? 1.5 : 1)),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: const Color(0xFF0F172A), child: Text(m.id, style: const TextStyle(fontSize: 12, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold))),
                      title: Text(m.nama, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(icon: const Icon(Icons.analytics, color: Colors.cyan), onPressed: () => onSelect(m.id)), 
                        IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => onDelete(m)),
                      ]),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== HALAMAN 3: INPUT REPS ====================
class InputLatihanKuantitatifPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String, String, String, double, double, DateTime) onSimpan;

  const InputLatihanKuantitatifPage({Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan}) : super(key: key);

  @override
  State<InputLatihanKuantitatifPage> createState() => _InputLatihanKuantitatifPageState();
}

class _InputLatihanKuantitatifPageState extends State<InputLatihanKuantitatifPage> {
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  String _selectedKlasifikasi = kDaftarKlasifikasiLatihan.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("INPUT TARGET REPETISI (KUANTITATIF)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.cyan)),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: widget.selectedMuridId, 
              dropdownColor: const Color(0xFF1E293B),
              items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text("${m.id} - ${m.nama}", style: const TextStyle(color: Colors.white)))).toList(),
              onChanged: widget.onMuridChanged, decoration: const InputDecoration(labelText: "Pilih Atlet", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedKlasifikasi, 
              dropdownColor: const Color(0xFF1E293B),
              items: kDaftarKlasifikasiLatihan.map((k) => DropdownMenuItem(value: k, child: Text(k, style: const TextStyle(color: Colors.white)))).toList(),
              onChanged: (v) => setState(() => _selectedKlasifikasi = v!), decoration: const InputDecoration(labelText: "Klasifikasi Kemampuan", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: _jenisController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nama Latihan (cth: Push Up, Sit Up)", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _repsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Jumlah Reps", border: OutlineInputBorder()))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Jumlah Sets", border: OutlineInputBorder()))),
            ]),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                double reps = double.tryParse(_repsController.text) ?? 0.0;
                double sets = double.tryParse(_setsController.text) ?? 0.0;
                if (_jenisController.text.isNotEmpty && reps > 0 && sets > 0) {
                  widget.onSimpan(widget.selectedMuridId, _jenisController.text, _selectedKlasifikasi, reps, sets, DateTime.now());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Repetisi Berhasil Disimpan!")));
                  _jenisController.clear(); _repsController.clear(); _setsController.clear();
                }
              },
              child: const Text("SIMPAN PERFORMANCE DATA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ))
          ]),
        ),
      ),
    );
  }
}

// ==================== HALAMAN 4: INPUT WAKTU ====================
class InputLatihanDurasiPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String, String, String, double, double, DateTime) onSimpan;

  const InputLatihanDurasiPage({Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan}) : super(key: key);

  @override
  State<InputLatihanDurasiPage> createState() => _InputLatihanDurasiPageState();
}

class _InputLatihanDurasiPageState extends State<InputLatihanDurasiPage> {
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _menitController = TextEditingController();
  final TextEditingController _detikController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  String _selectedKlasifikasi = kDaftarKlasifikasiLatihan.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("INPUT TARGET DURASI WAKTU (TIME-BASED)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: widget.selectedMuridId, 
              dropdownColor: const Color(0xFF1E293B),
              items: widget.daftarMurid.map((m) => DropdownMenuItem(value: m.id, child: Text("${m.id} - ${m.nama}", style: const TextStyle(color: Colors.white)))).toList(),
              onChanged: widget.onMuridChanged, decoration: const InputDecoration(labelText: "Pilih Atlet", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedKlasifikasi, 
              dropdownColor: const Color(0xFF1E293B),
              items: kDaftarKlasifikasiLatihan.map((k) => DropdownMenuItem(value: k, child: Text(k, style: const TextStyle(color: Colors.white)))).toList(),
              onChanged: (v) => setState(() => _selectedKlasifikasi = v!), decoration: const InputDecoration(labelText: "Klasifikasi Kemampuan", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: _jenisController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nama Latihan (cth: Plank, Kuda-Kuda)", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _menitController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Menit", border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _detikController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Detik", border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _setsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Sets", border: OutlineInputBorder()))),
            ]),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                double dtk = double.tryParse(_detikController.text) ?? 0.0;
                double mnt = double.tryParse(_menitController.text) ?? 0.0;
                double sets = double.tryParse(_setsController.text) ?? 0.0;
                double totalDetik = (mnt * 60) + dtk;
                if (_jenisController.text.isNotEmpty && totalDetik > 0 && sets > 0) {
                  widget.onSimpan(widget.selectedMuridId, _jenisController.text, _selectedKlasifikasi, totalDetik, sets, DateTime.now());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Durasi Berhasil Disimpan!")));
                  _jenisController.clear(); _menitController.clear(); _detikController.clear(); _setsController.clear();
                }
              },
              child: const Text("SIMPAN PERFORMANCE DATA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ))
          ]),
        ),
      ),
    );
  }
}

// ==================== ENGINE GRAFIK 1: BOXPLOT CUSTOM PAINT ====================
class MetaBoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  final List<double> teamAverages;

  const MetaBoxplotChart({Key? key, required this.boxData, required this.teamAverages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 240),
        painter: _BoxplotPainter(boxData: boxData, teamAverages: teamAverages),
      ),
    );
  }
}

class _BoxplotPainter extends CustomPainter {
  final List<List<double>> boxData;
  final List<double> teamAverages;

  _BoxplotPainter({required this.boxData, required this.teamAverages});

  @override
  void paint(Canvas canvas, Size size) {
    final int itemLength = boxData.length;
    if (itemLength == 0) return;

    double chartWidth = size.width - 50;
    double chartHeight = size.height - 40;
    double spacing = chartWidth / itemLength;

    final Paint pGaris = Paint()..color = const Color(0xFF334155)..strokeWidth = 1.0;
    final Paint pBox = Paint()..color = const Color(0xFF38BDF8).withOpacity(0.3)..style = PaintingStyle.fill;
    final Paint pBorderBox = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    final Paint pMedian = Paint()..color = Colors.amber..strokeWidth = 2.0;
    final Paint pSkorKini = Paint()..color = const Color(0xFFF43F5E)..style = PaintingStyle.fill;
    final Paint pGarisHubungScore = Paint()..color = const Color(0xFFF43F5E).withOpacity(0.4)..strokeWidth = 1.0;
    final Paint pRataTim = Paint()..color = const Color(0xFF10B981)..strokeWidth = 1.5..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      double y = 10 + (chartHeight / 4) * i;
      canvas.drawLine(Offset(40, y), Offset(size.width, y), pGaris);
    }

    Offset? prevScoreOffset;

    for (int i = 0; i < itemLength; i++) {
      double x = 55 + (spacing * i) + (spacing / 4);
      List<double> d = boxData[i];
      if (d.length < 6) continue;

      double mapY(double val) {
        if (val == 0.0) return 10 + chartHeight; 
        return 10 + (chartHeight * (1.0 - (val / 100.0))).clamp(0.0, chartHeight);
      }

      double yMin = mapY(d[0]);
      double yQ1 = mapY(d[1]);
      double yQ2 = mapY(d[2]);
      double yScore = mapY(d[3]); 
      double yQ3 = mapY(d[4]);
      double yMax = mapY(d[5]);

      canvas.drawLine(Offset(x, yMin), Offset(x, yMax), pBorderBox);
      canvas.drawLine(Offset(x - 5, yMin), Offset(x + 5, yMin), pBorderBox);
      canvas.drawLine(Offset(x - 5, yMax), Offset(x + 5, yMax), pBorderBox);

      Rect rectBox = Rect.fromLTRB(x - 12, yQ3, x + 12, yQ1);
      canvas.drawRect(rectBox, pBox);
      canvas.drawRect(rectBox, pBorderBox);

      canvas.drawLine(Offset(x - 12, yQ2), Offset(x + 12, yQ2), pMedian);

      if (i < teamAverages.length && teamAverages[i] > 0) {
        double yAvg = mapY(teamAverages[i]);
        canvas.drawLine(Offset(x - 15, yAvg), Offset(x + 15, yAvg), pRataTim);
      }

      Offset currentScoreOffset = Offset(x, yScore);
      if (prevScoreOffset != null) {
        canvas.drawLine(prevScoreOffset, currentScoreOffset, pGarisHubungScore);
      }
      prevScoreOffset = currentScoreOffset;

      canvas.drawCircle(currentScoreOffset, 5.0, pSkorKini);

      final List<String> labels = ["STR", "END", "SPD", "CRD", "FLX", "BAL", "REA"];
      final txt = TextPainter(text: TextSpan(text: labels[i], style: const TextStyle(fontSize: 8, color: Colors.white60)), textDirection: TextDirection.ltr)..layout();
      txt.paint(canvas, Offset(x - (txt.width / 2), size.height - 22));
    }
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==================== ENGINE GRAFIK 2: RADAR CHART PAINTER ====================
class MetaRadarChartPainter extends CustomPainter {
  final List<double> activeRadar;
  final List<double> teamRadar;

  MetaRadarChartPainter({required this.activeRadar, required this.teamRadar});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double maxRadius = math.min(size.width, size.height) / 2.3;
    int kDimensi = 10;

    final Paint pGrid = Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final Paint pAtlet = Paint()..color = const Color(0xFF22C55E).withOpacity(0.25)..style = PaintingStyle.fill; 
    final Paint pBorderAtlet = Paint()..color = const Color(0xFF22C55E)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final Paint pTim = Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1.2; 

    for (int i = 1; i <= 5; i++) {
      double r = maxRadius * (i / 5.0);
      Path pJaring = Path();
      for (int j = 0; j < kDimensi; j++) {
        double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
        Offset pPoint = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (j == 0) pJaring.moveTo(pPoint.dx, pPoint.dy);
        else pJaring.lineTo(pPoint.dx, pPoint.dy);
      }
      pJaring.close();
      canvas.drawPath(pJaring, pGrid);
    }

    for (int j = 0; j < kDimensi; j++) {
      double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
      Offset endPoint = Offset(center.dx + maxRadius * math.cos(angle), center.dy + maxRadius * math.sin(angle));
      canvas.drawLine(center, endPoint, pGrid);
    }

    Path pathAtlet = Path();
    bool hasDataAtlet = false;
    for (int j = 0; j < kDimensi; j++) {
      double val = j < activeRadar.length ? activeRadar[j] : 0.0;
      if (val > 0) hasDataAtlet = true;
      double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
      double r = maxRadius * val.clamp(0.0, 1.0);
      Offset pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (j == 0) pathAtlet.moveTo(pt.dx, pt.dy);
      else pathAtlet.lineTo(pt.dx, pt.dy);
    }
    pathAtlet.close();
    if (hasDataAtlet) {
      canvas.drawPath(pathAtlet, pAtlet);
      canvas.drawPath(pathAtlet, pBorderAtlet);
    }

    Path pathTim = Path();
    bool hasDataTim = false;
    for (int j = 0; j < kDimensi; j++) {
      double val = j < teamRadar.length ? teamRadar[j] : 0.0;
      if (val > 0) hasDataTim = true;
      double angle = (j * 2 * math.pi / kDimensi) - (math.pi / 2);
      double r = maxRadius * val.clamp(0.0, 1.0);
      Offset pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (j == 0) pathTim.moveTo(pt.dx, pt.dy);
      else pathTim.lineTo(pt.dx, pt.dy);
    }
    pathTim.close();
    if (hasDataTim) {
      canvas.drawPath(pathTim, pTim);
    }
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}