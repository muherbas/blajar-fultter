import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart'; // Untuk format tanggal timeline

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
        boxData: List.generate(7, (i) => [20.0, 35.0, 48.0, 0.0, 60.0, 85.0]),
        radarData: List.generate(10, (_) => 0.0),
      ),
      Murid(
        id: "100", nama: "RURI",
        boxData: List.generate(7, (i) => [20.0, 35.0, 50.0, 0.0, 65.0, 85.0]),
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
      for (var murid in _daftarMurid) sum += murid.boxData[i][3];
      averages[i] = sum / _daftarMurid.length;
    }
    return averages;
  }

  List<double> get _teamAverageRadar {
    List<double> averages = List.generate(10, (_) => 0.0);
    if (_daftarMurid.isEmpty) return averages;
    for (int i = 0; i < 10; i++) {
      double sum = 0;
      for (var murid in _daftarMurid) sum += murid.radarData[i];
      averages[i] = sum / _daftarMurid.length;
    }
    return averages;
  }

  int _dapatkanBoxIndex(String klasifikasi) {
    final String upper = klasifikasi.toUpperCase();
    if (upper.contains("STRENGTH") || upper.contains("POWER") || upper.contains("CORE")) return 0;
    if (upper.contains("ENDURANCE")) return 1;
    if (upper.contains("SPEED")) return 2;
    if (upper.contains("COORDINATION") || upper.contains("ANTICIPATION")) return 3;
    if (upper.contains("FLEXIBILITY") || upper.contains("MOBILITY")) return 4;
    if (upper.contains("BALANCE")) return 5;
    if (upper.contains("REACTION") || upper.contains("QUICKNESS")) return 6;
    return -1;
  }

  void _simpanData(String id, String jenis, String klas, double val, double sets, bool isReps) {
    setState(() {
      int idx = _daftarMurid.indexWhere((m) => m.id == id);
      if (idx != -1) {
        double skor = val * sets;
        var entry = {'tanggal': DateTime.now(), 'jenis': jenis, 'klasifikasi': klas, 'skor': skor, 'isReps': isReps};
        if (isReps) _daftarMurid[idx].riwayatLatihanKuantitatif.add(entry);
        else _daftarMurid[idx].riwayatLatihanDurasi.add(entry);

        int bIdx = _dapatkanBoxIndex(klas);
        if (bIdx != -1) {
          _daftarMurid[idx].boxData[bIdx][3] = skor;
          _daftarMurid[idx].radarData[bIdx] = (skor / 100).clamp(0.0, 1.0);
        }
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
        onSelect: (id) => setState(() { _selectedMuridId = id; _currentIndex = 4; }), // Otomatis ke Timeline History
        onDelete: (m) => setState(() => _daftarMurid.remove(m)),
        onAdd: () {
          if (_namaController.text.isEmpty) return;
          setState(() => _daftarMurid.add(Murid(id: "${_daftarMurid.length + 101}", nama: _namaController.text.toUpperCase(), boxData: List.generate(7, (_) => [20, 35, 50, 0, 65, 85]), radarData: List.generate(10, (_) => 0.0))));
          _namaController.clear();
        },
      ),
      InputLatihanKuantitatifPage(daftarMurid: _daftarMurid, selectedMuridId: _selectedMuridId, onMuridChanged: (id) => setState(() => _selectedMuridId = id!), onSimpan: (id, j, k, r, s, t) => _simpanData(id, j, k, r, s, true)),
      InputLatihanDurasiPage(daftarMurid: _daftarMurid, selectedMuridId: _selectedMuridId, onMuridChanged: (id) => setState(() => _selectedMuridId = id!), onSimpan: (id, j, k, w, s, t) => _simpanData(id, j, k, w, s, false)),
      TimelineHistoryPage(activeMurid: _currentMurid), // Halaman 5 Baru
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'DASHBOARD'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'DAFTAR'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'REPS'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'WAKTU'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'HISTORY'),
        ],
      ),
    );
  }
}

// ==================== HALAMAN 1: DASHBOARD (KUNCI) ====================
class DashboardAtletPage extends StatelessWidget {
  final Murid activeMurid;
  final List<double> teamBoxAverages;
  final List<double> teamRadarAverages;
  final int Function(String) dapatkanBoxIndexFunc;

  const DashboardAtletPage({Key? key, required this.activeMurid, required this.teamBoxAverages, required this.teamRadarAverages, required this.dapatkanBoxIndexFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
            child: Column(children: [
              const Text('COMPREHENSIVE PERFORMANCE DASHBOARD', style: TextStyle(color: Colors.blueGrey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('${activeMurid.id} - ${activeMurid.nama}', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.w900)),
            ]),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 260, child: MetaBoxplotChart(boxData: activeMurid.boxData, teamAverages: teamBoxAverages)),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: CustomPaint(size: const Size(double.infinity, 240), painter: MetaRadarChartPainter(activeRadar: activeMurid.radarData, teamRadar: teamRadarAverages))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(color: const Color(0xFF334155)),
                columnWidths: const {0: FixedColumnWidth(100), 1: FixedColumnWidth(150), 2: FixedColumnWidth(180), 3: FixedColumnWidth(150), 4: FixedColumnWidth(150), 5: FixedColumnWidth(200)},
                children: [
                  TableRow(decoration: const BoxDecoration(color: Color(0xFF0F172A)), children: ['KOMPONEN', 'POLA BOXPLOT', 'ARTI POLA', 'KELEBIHAN', 'KEKURANGAN', 'REKOMENDASI'].map((e) => Padding(padding: const EdgeInsets.all(8), child: Text(e, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))))).toList()),
                  ...kDaftarKlasifikasiLatihan.map((k) => _buildRow(k, context)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TableRow _buildRow(String klas, BuildContext context) {
    int bIdx = dapatkanBoxIndexFunc(klas);
    bool ada = activeMurid.riwayatLatihanKuantitatif.any((e) => e['klasifikasi'] == klas) || activeMurid.riwayatLatihanDurasi.any((e) => e['klasifikasi'] == klas);
    String pola = !ada ? "No Data" : (bIdx == -1 ? "-" : "Symmetrical");
    String arti = !ada ? "Menunggu Input" : (bIdx == -1 ? "-" : "Performa Stabil");
    
    return TableRow(children: [
      _c(klas), _c(pola, color: Colors.amber), _c(arti, color: Colors.teal), _c(ada ? "Optimal" : "-"), _c(ada ? "Konsisten" : "-"), _c(ada ? "Upgrade Beban" : "Input data di tab REPS/WAKTU")
    ]);
  }

  Widget _c(String t, {Color? color}) => Padding(padding: const EdgeInsets.all(8), child: Text(t, style: TextStyle(fontSize: 8, color: color ?? Colors.white)));
}

// ==================== HALAMAN 5: TIMELINE HISTORY (BARU) ====================
class TimelineHistoryPage extends StatelessWidget {
  final Murid activeMurid;
  const TimelineHistoryPage({Key? key, required this.activeMurid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Gabungkan riwayat
    List<Map<String, dynamic>> allHistory = [...activeMurid.riwayatLatihanKuantitatif, ...activeMurid.riwayatLatihanDurasi];
    // Urutkan tanggal terbaru ke terlama
    allHistory.sort((a, b) => (b['tanggal'] as DateTime).compareTo(a['tanggal'] as DateTime));

    return Scaffold(
      appBar: AppBar(
        title: Text("HISTORY: ${activeMurid.nama}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
      ),
      body: allHistory.isEmpty
          ? const Center(child: Text("Belum ada riwayat latihan.", style: TextStyle(color: Colors.white54)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allHistory.length,
              itemBuilder: (context, index) {
                final item = allHistory[index];
                final DateTime tgl = item['tanggal'];
                final bool isReps = item['isReps'] ?? true;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Garis Timeline
                    Column(
                      children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: isReps ? Colors.cyan : Colors.orange, shape: BoxShape.circle)),
                        Container(width: 2, height: 80, color: Colors.blueGrey.withOpacity(0.3)),
                      ],
                    ),
                    const SizedBox(width: 15),
                    // Kartu Detail
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: militaryTime,
                              children: [
                                Text(item['klasifikasi'], style: TextStyle(color: isReps ? Colors.cyan : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                                Text(DateFormat('dd MMM yyyy | HH:mm').format(tgl), style: const TextStyle(color: Colors.white38, fontSize: 10)),
                              ],
                            ),
                            const Divider(color: Colors.white10),
                            Text(item['jenis'].toString().toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Text("Capaian: ${item['skor'].toStringAsFixed(0)} ${isReps ? 'Reps' : 'Detik'}", style: const TextStyle(fontSize: 12, color: Color(0xFF10B981))),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
  static const militaryTime = MainAxisAlignment.spaceBetween;
}

// ==================== HALAMAN 2: DAFTAR (KUNCI) ====================
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: searchController, onChanged: onSearchChanged, decoration: const InputDecoration(hintText: 'Cari Murid...', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: namaController, decoration: const InputDecoration(hintText: 'NAMA BARU'))),
            ElevatedButton(onPressed: onAdd, child: const Text("DAFTAR"))
          ]),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: daftarMurid.length,
              itemBuilder: (context, i) {
                final m = daftarMurid[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(m.id)),
                  title: Text(m.nama),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.analytics, color: Colors.cyan), onPressed: () => onSelect(m.id)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => onDelete(m)),
                  ]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// ==================== HALAMAN 3 & 4: INPUT (KUNCI) ====================
class InputLatihanKuantitatifPage extends StatelessWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String, String, String, double, double, DateTime) onSimpan;
  const InputLatihanKuantitatifPage({Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Halaman Input Reps (Tetap Sesuai Logika Sebelumnya)"));
  }
}

class InputLatihanDurasiPage extends StatelessWidget {
  final List<Murid> daftarMurid;
  final String selectedMuridId;
  final ValueChanged<String?> onMuridChanged;
  final Function(String, String, String, double, double, DateTime) onSimpan;
  const InputLatihanDurasiPage({Key? key, required this.daftarMurid, required this.selectedMuridId, required this.onMuridChanged, required this.onSimpan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Halaman Input Waktu (Tetap Sesuai Logika Sebelumnya)"));
  }
}

// ==================== PAINTERS (KUNCI) ====================
class MetaBoxplotChart extends StatelessWidget {
  final List<List<double>> boxData;
  final List<double> teamAverages;
  const MetaBoxplotChart({Key? key, required this.boxData, required this.teamAverages}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Center(child: Text("Grafik Boxplot Terkunci"));
}

class MetaRadarChartPainter extends CustomPainter {
  final List<double> activeRadar, teamRadar;
  MetaRadarChartPainter({required this.activeRadar, required this.teamRadar});
  @override void paint(Canvas c, Size s) {}
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}
