import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert'; 

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
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFF0F172A), 
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationContainer(),
    );
  }
}

class Murid {
  final String id;
  final String nama;
  final List<double> dataBoxplot; 
  final List<double> dataRadar;   

  Murid({
    required this.id,
    required this.nama,
    required this.dataBoxplot,
    required this.dataRadar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'boxplot': dataBoxplot,
      'radar': dataRadar,
    };
  }

  factory Murid.fromMap(Map<String, dynamic> map) {
    return Murid(
      id: map['id'],
      nama: map['nama'],
      dataBoxplot: List<double>.from(map['boxplot'].map((x) => x.toDouble())),
      dataRadar: List<double>.from(map['radar'].map((x) => x.toDouble())),
    );
  }
}

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({Key? key}) : super(key: key);

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 1; 
  
  List<Murid> _daftarMurid = [
    Murid(
      id: "001",
      nama: "BUDI SANTOSO",
      dataBoxplot: [0.35, 0.40, 0.45, 0.32, 0.38, 0.28, 0.42],
      dataRadar: [0.80, 0.65, 0.85, 0.50, 0.70, 0.90, 0.75, 0.60, 0.80, 0.55],
    ),
    Murid(
      id: "002",
      nama: "AHMAD RIFAI",
      dataBoxplot: [0.50, 0.60, 0.30, 0.45, 0.55, 0.40, 0.35],
      dataRadar: [0.60, 0.80, 0.70, 0.75, 0.60, 0.65, 0.85, 0.70, 0.65, 0.80],
    ),
    Murid(
      id: "003",
      nama: "SITI AMINAH",
      dataBoxplot: [0.20, 0.25, 0.55, 0.58, 0.62, 0.55, 0.68],
      dataRadar: [0.70, 0.70, 0.60, 0.85, 0.80, 0.75, 0.60, 0.80, 0.90, 0.70],
    ),
  ];

  late Murid _muridTerpilih;

  @override
  void initState() {
    super.initState();
    _muridTerpilih = _daftarMurid[0]; 
  }

  @override
  Widget build(BuildContext context) {
    // Di sini Anda bebas menambah widget halaman baru ke dalam List tanpa takut error tipe data lagi
    final List<Widget> _halaman = [
      DashboardAtletPage(murid: _muridTerpilih), 
      ManajemenMuridPage( 
        daftarMurid: _daftarMurid,
        muridTerpilih: _muridTerpilih,
        onMuridDipilih: (muridBaru) { 
          setState(() {
            _muridTerpilih = muridBaru;
            _currentIndex = 0; 
          });
        },
        onDaftarUpdated: (listBaru) {
          setState(() {
            _daftarMurid = listBaru;
            if (!_daftarMurid.contains(_muridTerpilih) && _daftarMurid.isNotEmpty) {
              _muridTerpilih = _daftarMurid[0];
            }
          });
        },
      ),
    ];

    return Scaffold(
      body: _halaman[_currentIndex],
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
        selectedFontSize: 11,
        unselectedFontSize: 11,
        fontWeight: FontWeight.bold,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_add_rounded),
            label: 'MANAJEMEN MURID',
          ),
        ],
      ),
    );
  }
}

class DashboardAtletPage extends StatelessWidget {
  final Murid murid;
  const DashboardAtletPage({Key? key, required this.murid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DASHBOARD PERFORMANCE [${murid.id} - ${murid.nama}]',
          style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KOMKOMPONEN UTAMA',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF38BDF8), letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: BoxplotChart(dataValues: murid.dataBoxplot),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('GLOBAL TEAM AVERAGE', style: TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('68.5', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFF8FAFC))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KOMPONEN TURUNAN',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFF43F5E), letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(width: 8, height: 8, color: const Color(0xFFF43F5E)),
                      const SizedBox(width: 4),
                      const Text('Murid', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(width: 8, height: 8, color: const Color(0xFF0EA5E9)),
                      const SizedBox(width: 4),
                      const Text('Tim Avg', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 340, 
                    child: RadarSpiderChart(dataValues: murid.dataRadar),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManajemenMuridPage extends StatefulWidget {
  final List<Murid> daftarMurid;
  final Murid muridTerpilih;
  
  // PERBAIKAN UTAMA: Definisi tipe fungsi diperketat agar tidak bisa menjadi 'dynamic' lagi
  final void Function(Murid murid) onMuridDipilih;
  final void Function(List<Murid> listBaru) onDaftarUpdated;

  const ManajemenMuridPage({
    Key? key,
    required this.daftarMurid,
    required this.muridTerpilih,
    required this.onMuridDipilih,
    required this.onDaftarUpdated,
  }) : super(key: key);

  @override
  State<ManajemenMuridPage> createState() => _ManajemenMuridPageState();
}

class _ManajemenMuridPageState extends State<ManajemenMuridPage> {
  String _searchQuery = "";
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _ioController = TextEditingController(); 

  void _tambahMurid() {
    if (_idController.text.isEmpty || _namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID dan Nama tidak boleh kosong!'))
      );
      return;
    }
    
    if (widget.daftarMurid.any((m) => m.id == _idController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Murid sudah terdaftar!'))
      );
      return;
    }

    final rand = math.Random();
    List<double> boxplotBaru = List.generate(7, (_) => 0.2 + rand.nextDouble() * 0.6);
    List<double> radarBaru = List.generate(10, (_) => 0.4 + rand.nextDouble() * 0.5);

    Murid muridBaru = Murid(
      id: _idController.text.toUpperCase(),
      nama: _namaController.text.toUpperCase(),
      dataBoxplot: boxplotBaru,
      dataRadar: radarBaru,
    );

    List<Murid> newList = List.from(widget.daftarMurid)..add(muridBaru);
    widget.onDaftarUpdated(newList);

    _idController.clear();
    _namaController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Murid Baru Sukses Ditambahkan!'))
    );
  }

  void _konfirmasiHapus(Murid m) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Hapus Data Murid?', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus ${m.nama} dari sistem? Murid yang berhenti akan dihapus selamanya.', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL', style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () {
              List<Murid> newList = List.from(widget.daftarMurid)..remove(m);
              widget.onDaftarUpdated(newList);
              Navigator.pop(context);
            }, 
            child: const Text('HAPUS', style: TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }

  void _eksporData() {
    List<Map<String, dynamic>> rawList = widget.daftarMurid.map((m) => m.toMap()).toList();
    String jsonString = jsonEncode(rawList);
    _ioController.text = jsonString;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Ekspor Sukses!', style: TextStyle(color: Colors.white, fontSize: 14)),
        content: const Text('Kode teks backup data sudah digenerate di kolom bawah. Silakan salin & simpan di catatan/Notes HP Anda.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(color: Color(0xFF38BDF8))))
        ],
      ),
    );
  }

  void _imporData() {
    if (_ioController.text.isEmpty) return;
    try {
      List<dynamic> decoded = jsonDecode(_ioController.text);
      List<Murid> listImpor = decoded.map((x) => Murid.fromMap(x)).toList();
      
      widget.onDaftarUpdated(listImpor);
      _ioController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database Murid Berhasil Dipulihkan/Diimpor!'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format kode backup salah/error! Gagal impor.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Murid> filteredList = widget.daftarMurid.where((m) => m.nama.contains(_searchQuery.toUpperCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PANEL KONTROL DATA ATLET', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TAMBAH ATLET BARU', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _idController,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'ID', hintStyle: TextStyle(color: Colors.white24),
                      filled: true, fillColor: Color(0xFF1E293B),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _namaController,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'NAMA LENGKAP MURID', hintStyle: TextStyle(color: Colors.white24),
                      filled: true, fillColor: Color(0xFF1E293B),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _tambahMurid,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)),
                  child: const Icon(Icons.add, color: Color(0xFF0F172A), size: 18),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            const Text('PENCARIAN DATA ATLET', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Ketik nama murid untuk menyaring...', hintStyle: TextStyle(color: Colors.white24),
                prefixIcon: Icon(Icons.search, color: Colors.white54, size: 18),
                filled: true, fillColor: Color(0xFF1E293B),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL DATA: ${widget.daftarMurid.length} ATLET', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                const Text('ℹ️ Klik nama untuk buka Dashboard', style: TextStyle(color: Colors.white38, fontSize: 8)),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final murid = filteredList[index];
                  final bool isAktif = murid.id == widget.muridTerpilih.id;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isAktif ? const Color(0xFF0284C7).withOpacity(0.3) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isAktif ? const Color(0xFF38BDF8) : Colors.transparent, width: 1),
                    ),
                    child: ListTile(
                      dense: true,
                      onTap: () => widget.onMuridDipilih(murid), 
                      leading: CircleAvatar(
                        backgroundColor: isAktif ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                        radius: 14,
                        child: Text(murid.id, style: TextStyle(color: isAktif ? const Color(0xFF0F172A) : Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(murid.nama, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      subtitle: const Text('Skor Biomotorik Terarsip', style: TextStyle(color: Colors.white38, fontSize: 9)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFF43F5E), size: 18),
                        onPressed: () => _konfirmasiHapus(murid), 
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SISTEM BACKUP DATA (ANTI DATA HILANG)', style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _eksporData,
                          icon: const Icon(Icons.download_rounded, size: 14, color: Color(0xFF0F172A)),
                          label: const Text('GENERATE CODE BACKUP', style: TextStyle(fontSize: 9, color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _imporData,
                          icon: const Icon(Icons.upload_rounded, size: 14, color: Colors.white),
                          label: const Text('PULIHKAN DATA', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _ioController,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 9),
                    decoration: const InputDecoration(
                      hintText: 'Teks kode JSON backup akan muncul/ditempel di sini...',
                      hintStyle: TextStyle(color: Colors.white12, fontSize: 9),
                      filled: true, fillColor: Color(0xFF0F172A),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BoxplotChart extends StatelessWidget {
  final List<double> dataValues;
  const BoxplotChart({Key? key, required this.dataValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ['STRENGTH', 'ENDURANCE', 'SPEED', 'COORD', 'FLEX', 'BALANCE', 'REACTION'];
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: BoxplotPainter(dataValues: dataValues),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels.map((label) => SizedBox(
            width: 44,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class BoxplotPainter extends CustomPainter {
  final List<double> dataValues;
  BoxplotPainter({required this.dataValues});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..color = const Color(0xFF475569)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final Paint boxPaint = Paint()..color = const Color(0xFF0284C7)..style = PaintingStyle.fill;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    int dataCount = 7;
    double spacing = size.width / dataCount;

    for (int i = 0; i < dataCount; i++) {
      double x = (spacing * i) + (spacing / 2);
      double baseVal = dataValues[i]; 
      
      double outlier = (baseVal * 0.1) * size.height;
      double topWhisker = (baseVal * 0.5) * size.height;
      double q3 = (baseVal * 0.7) * size.height;
      double median = baseVal * size.height;
      double q1 = (baseVal * 1.2).clamp(0.0, 1.4) * size.height;
      double bottomWhisker = (baseVal * 1.5).clamp(0.0, 1.9) * size.height;
      double boxWidth = spacing * 0.35;

      canvas.drawCircle(Offset(x, outlier), 2.5, Paint()..color = const Color(0xFF38BDF8));
