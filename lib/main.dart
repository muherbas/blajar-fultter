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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Athlete App',
      home: MainNavigationContainer(),
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
      dataBoxplot: List<double>.from(map['boxplot']),
      dataRadar: List<double>.from(map['radar']),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'MANAJEMEN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
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
        title: Text('DASHBOARD - ${murid.nama}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('KOMPONEN UTAMA'),
          Text('Data: ${murid.dataBoxplot.toString()}'),
          const SizedBox(height: 20),
          const Text('KOMPONEN TURUNAN'),
          Text('Data: ${murid.dataRadar.toString()}'),
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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _ioController = TextEditingController();

  void _tambahMurid() {
    if (_idController.text.isEmpty || _namaController.text.isEmpty) return;

    final rand = math.Random();
    List<double> boxplotBaru = List.generate(7, (_) => rand.nextDouble());
    List<double> radarBaru = List.generate(10, (_) => rand.nextDouble());

    Murid muridBaru = Murid(
      id: _idController.text,
      nama: _namaController.text,
      dataBoxplot: boxplotBaru,
      dataRadar: radarBaru,
    );

    List<Murid> newList = List.from(widget.daftarMurid)..add(muridBaru);
    widget.onDaftarUpdated(newList);

    _idController.clear();
    _namaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MANAJEMEN MURID')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: const InputDecoration(hintText: 'ID'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(hintText: 'NAMA'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _tambahMurid,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.daftarMurid.length,
              itemBuilder: (context, index) {
                final murid = widget.daftarMurid[index];
                return ListTile(
                  title: Text(murid.nama),
                  subtitle: Text('ID: ${murid.id}'),
                  onTap: () => widget.onMuridDipilih(murid),
                );
              },
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
      appBar: AppBar(title: const Text('MATERI NUNCHAKU')),
      body: ListView.builder(
        itemCount: kurikulumNunchaku.length,
        itemBuilder: (context, index) {
          final item = kurikulumNunchaku[index];
          return ListTile(
            title: Text(item["kategori"]),
            subtitle: Text((item["materi"] as List<String>).join(', ')),
          );
        },
      ),
    );
  }
}
