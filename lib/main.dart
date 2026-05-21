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
  
  final List<Murid> _daftarMurid = [
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
            _daftarMurid.clear();
            _daftarMurid.addAll(listBaru);
            if (!_daftarMurid.contains(_muridTerpilih) && _daftarMurid.isNotEmpty) {
              _muridTerpilih = _daftarMurid[0];
            }
          });
        },
      ),
      const MateriNunchakuPage(),
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
            label: 'MANAJEMEN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menuBookRounded), // Perbaikan: Huruf m kecil
            label: 'MATERI',
          ),
        ],
      ),
    );
  }
}

class MateriNunchakuPage extends StatelessWidget {
  const MateriNunchakuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> kurikulumNunchaku = [
      {
        "kategori": "NUNCHAKU BASIC",
        "materi": ["BARBEL SEBAGAI GADA", "BASIC MOVEMENT NUNCHAKU"]
      },
      {
        "kategori": "NUNCHAKU INTERMEDIATE",
        "materi": ["NUNCHAKU SWITCH HAND"]
      },
      {
        "kategori": "NUNCHAKU EXPERT",
        "materi": ["NUNCHAKU TECHNIQUE / KOMBINASI MOVEMENT"]
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('KURIKULUM MATERI NUNCHAKU', style: TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kurikulumNunchaku.length,
        itemBuilder: (context, index) {
          final item = kurikulumNunchaku[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["kategori"],
                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const Divider(color: Colors.white10, height: 20),
                Column(
                  children: (item["materi"] as List<String>).map((materiNama) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFFF43F5E), size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              materiNama,
                              style: const TextStyle(fontSize: 12, color: Color(0xFFF8FAFC)), // Perbaikan: Menghapus Colors.whiteBF yang typo
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          );
        },
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
                    'KOMPONEN UTAMA',
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
        content: Text('Apakah Anda yakin ingin menghapus ${m.nama} dari sistem?', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
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
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Saring nama murid...', hintStyle: TextStyle(color: Colors.white24),
                prefixIcon: Icon(Icons.search, color: Colors.white54, size: 18),
                filled: true, fillColor: Color(0xFF1E293B),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFF43F5E), size: 18),
                        onPressed: () => _konfirmasiHapus(murid), 
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _eksporData,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
                          child: const Text('BACKUP CODE', style: TextStyle(fontSize: 9, color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _imporData,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF475569)),
                          child: const Text('PULIHKAN DATA', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _ioController,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 9),
                    decoration: const InputDecoration(
                      hintText: 'Kolom impor/ekspor data...',
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
        Expanded(child: CustomPaint(size: Size.infinite, painter: BoxplotPainter(dataValues: dataValues))),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels.map((label) => SizedBox(
            width: 44,
            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
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
    double spacing = size.width / 7;

    for (int i = 0; i < 7; i++) {
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
      canvas.drawLine(Offset(x, topWhisker), Offset(x, q3), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, topWhisker), Offset(x + boxWidth/3, topWhisker), linePaint);
      canvas.drawLine(Offset(x, q1), Offset(x, bottomWhisker), linePaint);
      canvas.drawLine(Offset(x - boxWidth/3, bottomWhisker), Offset(x + boxWidth/3, bottomWhisker), linePaint);

      Rect boxRect = Rect.fromLTRB(x - boxWidth / 2, q3, x + boxWidth / 2, q1);
      canvas.drawRect(boxRect, boxPaint);
      canvas.drawRect(boxRect, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1);
      canvas.drawLine(Offset(x - boxWidth / 2, median), Offset(x + boxWidth / 2, median), Paint()..color = const Color(0xFFF8FAFC)..strokeWidth = 1.5);
    }
  }
  @override
  bool shouldRepaint(covariant BoxplotPainter oldDelegate) => oldDelegate.dataValues != dataValues;
}

class RadarSpiderChart extends StatelessWidget {
  final List<double> dataValues;
  const RadarSpiderChart({Key? key, required this.dataValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: RadarSpiderPainter(dataValues: dataValues));
  }
}

class RadarSpiderPainter extends CustomPainter {
  final List<double> dataValues;
  RadarSpiderPainter({required this.dataValues});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double maxRadius = math.min(size.width, size.height) / 2.7; 
    int numFeatures = 10;
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
      
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: labels[j], style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
        textDirection: TextDirection.ltr,
      )..layout();
      double textX = center.dx + (maxRadius + 14) * math.cos(angle) - (textPainter.width / 2);
      double textY = center.dy + (maxRadius + 10) * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(textX, textY));
    }

    List<double> teamAvgValues = [0.65, 0.70, 0.60, 0.65, 0.68, 0.70, 0.62, 0.65, 0.70, 0.60];
    Path teamPath = Path();
    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double currentRadius = maxRadius * teamAvgValues[j];
      if (j == 0) teamPath.moveTo(center.dx + currentRadius * math.cos(angle), center.dy + currentRadius * math.sin(angle));
      else teamPath.lineTo(center.dx + currentRadius * math.cos(angle), center.dy + currentRadius * math.sin(angle));
    }
    teamPath.close();
    canvas.drawPath(teamPath, Paint()..color = const Color(0xFF0EA5E9).withOpacity(0.12)..style = PaintingStyle.fill);

    Path studentPath = Path();
    List<Offset> studentPoints = [];
    for (int j = 0; j < numFeatures; j++) {
      double angle = (j * 2 * math.pi / numFeatures) - (math.pi / 2);
      double currentRadius = maxRadius * dataValues[j];
      double x = center.dx + currentRadius * math.cos(angle);
      double y = center.dy + currentRadius * math.sin(angle);
      studentPoints.add(Offset(x, y));
      if (j == 0) studentPath.moveTo(x, y); else studentPath.lineTo(x, y);
    }
    studentPath.close();
    canvas.drawPath(studentPath, Paint()..color = const Color(0xFFF43F5E).withOpacity(0.28)..style = PaintingStyle.fill);
    canvas.drawPath(studentPath, Paint()..color = const Color(0xFFF43F5E)..style = PaintingStyle.stroke..strokeWidth = 2.0);

    for (Offset point in studentPoints) {
      canvas.drawCircle(point, 3, Paint()..color = const Color(0xFFFFF1F2));
    }
  }

  @override
  bool shouldRepaint(covariant RadarSpiderPainter oldDelegate) => oldDelegate.dataValues != dataValues;
}
