import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const MainNavigationHolder(),
    );
  }
}

// --- MODEL DATA ---
class Murid {
  final String id;
  final String nama;
  final List<List<double>> boxData; // Data untuk Boxplot
  final List<double> radarData;
  List<Map<String, dynamic>> riwayatLatihanKuantitatif;
  List<Map<String, dynamic>> riwayatLatihanDurasi;

  Murid({
    required this.id, required this.nama, required this.boxData, required this.radarData,
    required this.riwayatLatihanKuantitatif, required this.riwayatLatihanDurasi,
  });
}

// --- DATA GLOBAL ---
List<Murid> daftarMurid = [
  Murid(id: "M-01", nama: "Atlet Utama", boxData: [[10, 20, 30, 40, 50]], radarData: [0.8, 0.7, 0.9, 0.6, 0.8, 0.7], riwayatLatihanKuantitatif: [], riwayatLatihanDurasi: []),
];
int indexTerpilih = 0;

// --- HALAMAN UTAMA (MainNavigationHolder) ---
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({Key? key}) : super(key: key);
  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _index = 0;
  final List<Widget> _halaman = [
    const DashboardPage(),
    const DaftarSiswaPage(),
    const InputPage(tipe: "Repetisi"),
    const InputPage(tipe: "Waktu"),
    const AITrainingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.cyan,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Siswa'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Reps'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Waktu'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Coach'),
        ],
      ),
    );
  }
}

// --- HALAMAN 1: DASHBOARD (Boxplot & Radar) ---
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final murid = daftarMurid[indexTerpilih];
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard: ${murid.nama}")),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text("Analisis Boxplot (Distribusi Performa)"),
        Container(height: 150, color: Colors.white10, child: const Center(child: Text("Grafik Boxplot di sini"))),
        const SizedBox(height: 20),
        const Text("Riwayat Latihan"),
        ...murid.riwayatLatihanKuantitatif.map((e) => ListTile(title: Text(e['jenis']), subtitle: Text(e['skor']))),
      ]),
    );
  }
}

// --- HALAMAN 2: DAFTAR SISWA (Opsi Tinjau & History) ---
class DaftarSiswaPage extends StatelessWidget {
  const DaftarSiswaPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Siswa")),
      body: ListView.builder(
        itemCount: daftarMurid.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(daftarMurid[i].nama),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.analytics), onPressed: () => print("Buka Tinjau")),
            IconButton(icon: const Icon(Icons.history), onPressed: () => print("Buka History")),
          ]),
        ),
      ),
    );
  }
}

// --- HALAMAN 3 & 4: INPUT (Klasifikasi Kemampuan) ---
class InputPage extends StatefulWidget {
  final String tipe;
  const InputPage({Key? key, required this.tipe}) : super(key: key);
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String _klasifikasi = "STRENGTH";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Input ${widget.tipe}")),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        DropdownButtonFormField<String>(
          value: _klasifikasi,
          items: ["STRENGTH", "ENDURANCE", "SPEED"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _klasifikasi = v!),
          decoration: const InputDecoration(labelText: "Klasifikasi Kemampuan"),
        ),
      ])),
    );
  }
}

// --- HALAMAN 6: AI COACH (Penjelasan & Saran) ---
class AITrainingPage extends StatefulWidget {
  const AITrainingPage({Key? key}) : super(key: key);
  @override
  State<AITrainingPage> createState() => _AITrainingPageState();
}

class _AITrainingPageState extends State<AITrainingPage> {
  bool _generated = false;
  void _generate() => setState(() => _generated = true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Coach Generator")),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ElevatedButton(onPressed: _generate, child: const Text("Generate Program")),
        if (_generated) ...[
          const Text("Saran Program:", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("1. Lakukan Pemanasan Dinamis\n2. Fokus pada eksploasi otot inti\n3. Detail gerakan: Lakukan secara perlahan dan terkontrol."),
        ]
      ]),
    );
  }
}
