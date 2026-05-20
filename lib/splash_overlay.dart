import 'package:flutter/material.dart';

// Variabel global untuk mendeteksi booting awal aplikasi
bool apakahAplikasiBaruBuka = true;

class MemuatHalaman extends StatefulWidget {
  final Widget halamanTujuan;
  final String pesanLoading;

  const MemuatHalaman({
    super.key, 
    required this.halamanTujuan, 
    this.pesanLoading = 'Memuat Data...',
  });

  @override
  State<MemuatHalaman> createState() => _MemuatHalamanState();
}

class _MemuatHalamanState extends State<MemuatHalaman> {
  @override
  void initState() {
    super.initState();

    // Durasi: 6 detik jika pertama buka, 3 detik jika pindah halaman biasa
    int durasiDetik = apakahAplikasiBaruBuka ? 6 : 3;

    Future.delayed(Duration(seconds: durasiDetik), () {
      if (apakahAplikasiBaruBuka) {
        apakahAplikasiBaruBuka = false;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.halamanTujuan),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.analytics_rounded,
              size: 90,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              apakahAplikasiBaruBuka ? 'Memulai Aplikasi...' : widget.pesanLoading,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              apakahAplikasiBaruBuka ? 'Mohon tunggu 6 detik...' : 'Tunggu 3 detik...',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
