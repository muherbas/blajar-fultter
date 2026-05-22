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
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F7FA),
        primaryColor: const Color(0xFF1E88E5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
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
}

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({Key? key}) : super(key: key);

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 1; // Default ke halaman Manajemen agar langsung kelihatan hasilnya

  final List<Murid> _daftarMurid = [
    Murid(
      id: "100",
      nama: "Ruri",
      dataBoxplot: [0.35, 0.40, 0.45, 0.32, 0.38, 0.28, 0.42],
      dataRadar: [0.80, 0.65, 0.85, 0.50, 0.70, 0.90, 0.75, 0.60, 0.80, 0.55],
    ),
    Murid(
      id: "101",
      nama: "Adi Wijaya",
      dataBoxplot: [0.50, 0.60, 0.30, 0.45, 0.55, 0.40, 0.35],
      dataRadar: [0.60, 0.80, 0.70, 0.75, 0.60, 0.65, 0.85, 0.70, 0.65, 0.80],
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
            _currentIndex = 0; // Pindah ke dashboard setelah dipilih
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
      body: SafeArea(child: _halaman[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1E88E5),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'MANAJEMEN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'MATERI',
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
        title: Text('DASHBOARD: ${murid.nama}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DATA SEBARAN BOXPLOT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 8),
                  Text(murid.dataBoxplot.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DATA PARAMETER RADAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 8),
                  Text(murid.dataRadar.toString()),
                ],
              ),
            ),
          ),
        ],
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
  final TextEditingController _namaController = TextEditingController();
  String _searchQuery = "";
  int _nextIdCounter = 102; // ID counter otomatis selanjutnya

  void _tambahMurid() {
    if (_namaController.text.trim().isEmpty) return;

    final rand = math.Random();
    List<double> boxplotBaru = List.generate(7, (_) => double.parse((rand.nextDouble() * 0.5 + 0.2).toStringAsFixed(2)));
    List<double> radarBaru = List.generate(10, (_) => double.parse((rand.nextDouble() * 0.5 + 0.4).toStringAsFixed(2)));

    Murid muridBaru = Murid(
      id: _nextIdCounter.toString(),
      nama: _namaController.text.trim(),
      dataBoxplot: boxplotBaru,
      dataRadar: radarBaru,
    );

    List<Murid> newList = List.from(widget.daftarMurid)..add(muridBaru);
    widget.onDaftarUpdated(newList);

    setState(() {
      _nextIdCounter++;
    });
    _namaController.clear();
    FocusScope.of(context).unfocus();
  }

  void _hapusMurid(Murid murid) {
    if (widget.daftarMurid.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal harus menyisakan 1 atlet di database.')),
      );
      return;
    }
    List<Murid> newList = List.from(widget.daftarMurid)..remove(murid);
    widget.onDaftarUpdated(newList);
  }

  @override
  Widget build(BuildContext context) {
    // Filter pencarian nama atlet
    final filteredList = widget.daftarMurid.where((m) {
      return m.nama.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Judul Utama Halaman
          const Center(
            child: Text(
              'Database JUMBO & Kontrol Atlet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
            ),
          ),
          const SizedBox(height: 16),

          // Baris Tombol Ekspor & Impor
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.archive_outlined, color: Colors.deepOrangeAccent),
                  label: const Text('Ekspor Backup', style: TextStyle(color: Color(0xFF1565C0))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueGrey, style: BorderStyle.solid),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.unarchive_outlined, color: Colors.deepOrangeAccent),
                  label: const Text('Impor Restore', style: TextStyle(color: Color(0xFF1565C0))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueGrey, style: BorderStyle.solid),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kolom Pencarian Nama Atlet
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
              hintText: 'Cari nama atlet untuk kelola/hapus...',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Item Atlet Terfilter
          ...filteredList.map((murid) {
            final bool isSelected = murid.id == widget.muridTerpilih.id;
            return Card(
              color: Colors.white,
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.person, color: Color(0xFF1E88E5)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            murid.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'ID - ${murid.id}',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    // Status Tombol Sedang Dilihat / Pilih
                    ElevatedButton(
                      onPressed: () => widget.onMuridDipilih(murid),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFF2EC4B6) : Colors.blueGrey.shade100,
                        foregroundColor: isSelected ? Colors.white : Colors.black87,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text(isSelected ? 'Sedang Dilihat' : 'Lihat Atlet'),
                    ),
                    const SizedBox(width: 6),
                    // Tombol Hapus
                    IconButton(
                      onPressed: () => _hapusMurid(murid),
                      icon: const Icon(Icons.cancel, color: Color(0xFFE53935)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),

          // Container Box Pendaftaran Atlet Baru
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF0288D1), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Tambah Murid Baru (+ID: $_nextIdCounter)',
                    style: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap Murid Baru',
                    hintText: 'Contoh: Adi Wijaya',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _tambahMurid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'DAFTARKAN ATLET BARU',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
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
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MATERI NUNCHAKU', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kurikulumNunchaku.length,
        itemBuilder: (context, index) {
          final item = kurikulumNunchaku[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item["kategori"], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Divider(),
                  ...(item["materi"] as List<String>).map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('• $m'),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}