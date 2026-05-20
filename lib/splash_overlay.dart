import 'package:flutter/material.dart';

class SplashOverlay extends StatelessWidget {
  final VoidCallback onFinished;

  const SplashOverlay({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    // Simulasi loading selama 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      onFinished();
    });

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.Bolt, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Blajar Flutter",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}