import 'package:flutter/material.dart';
import 'splash_overlay.dart'; // Import file yang baru dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blajar Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _showSplash
          ? SplashOverlay(onFinished: () {
              setState(() {
                _showSplash = false;
              });
            })
          : const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: const Center(
        child: Text("Selamat Datang di Aplikasi Utama!"),
      ),
    );
  }
}