import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // --- DATA SOURCE MOCKING SIFATNYA PERSIS SEPERTI DI GAMBAR ---
  
  // Data Boxplot (Minimum, Kuartil 1, Median, Kuartil 3, Maximum)
  final List<BoxPlotData> _boxData = [
    BoxPlotData('Str', 0.1, 0.2, 0.4, 0.6, 0.8),
    BoxPlotData('End', 0.2, 0.3, 0.5, 0.7, 0.9),
    BoxPlotData('Spd', 0.1, 0.4, 0.6, 0.75, 0.85),
    BoxPlotData('Coord', 0.3, 0.4, 0.55, 0.65, 0.9),
    BoxPlotData('Flex', 0.2, 0.35, 0.5, 0.7, 0.8),
    BoxPlotData('Bal', 0.15, 0.3, 0.45, 0.6, 0.75),
    BoxPlotData('React', 0.25, 0.4, 0.6, 0.8, 0.95),
  ];

  // Data Radar (10 Komponen Turunan sesuai gambar)
  final List<RadarData> _radarData = [
    RadarData('M.Endur', 75),
    RadarData('Power', 80),
    RadarData('Core', 65),
    RadarData('Dyn.Flex', 70),
    RadarData('Spd.Endur', 85),
    RadarData('React.Spd', 60),
    RadarData('Agility', 90),
    RadarData('Anticip', 75),
    RadarData('Mobility', 80),
    RadarData('Open.Agil', 70),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Background abu-abu tipis khas mobile app
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ================= CARD 1: BOXPLOT =================
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '1 Boxplot Atlet: Komponen Utama',
                          style: TextStyle(
                            color: Color(0xFF1E70E0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend Manual
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD0E3FF),
                              border: Border.solid(color: const Color(0xFF1E70E0), width: 2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Statistik Ruri',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      // Chart Boxplot
                      SizedBox(
                        height: 260,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelRotation: -30, // Kemiringan label teks axis X
                            majorGridLines: const MajorGridLines(width: 0.5),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 1.0,
                            interval: 0.1,
                            majorGridLines: const MajorGridLines(width: 0.5),
                          ),
                          series: <BoxAndWhiskerSeries<BoxPlotData, String>>[
                            BoxAndWhiskerSeries<BoxPlotData, String>(
                              dataSource: _boxData,
                              xValueMapper: (BoxPlotData data, _) => data.x,
                              yValueMapper: (BoxPlotData data, _) => [
                                data.min,
                                data.q1,
                                data.median,
                                data.q3,
                                data.max,
                              ],
                              boxPlotMode: BoxPlotMode.normal,
                              fillColor: const Color(0xFFD0E3FF),
                              strokeColor: const Color(0xFF1E70E0),
                              strokeWidth: 2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= CARD 2: RADAR CHART =================
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '1 Radar Atlet: Komponen Turunan',
                          style: TextStyle(
                            color: Color(0xFF1E70E0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend Manual
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              border: Border.solid(color: const Color(0Style.purple), width: 2),
                            ),
                            style: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.purple, width: 2)),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purple, width: 2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Nilai Rata-rata Komponen Turunan',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      // Chart Radar Poligon
                      SizedBox(
                        height: 320,
                        child: SfRadarChart(
                          primaryXAxis: const CategoryAxis(
                            labelPlacement: LabelPlacement.onTicks,
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 20,
                          ),
                          drawType: RadarDrawType.polygon, // Menjadikan bentuk segi-10 (bukan lingkaran)
                          series: <RadarSeries<RadarData, String>>[
                            RadarSeries<RadarData, String>(
                              dataSource: _radarData,
                              xValueMapper: (RadarData data, _) => data.kategori,
                              yValueMapper: (RadarData data, _) => data.nilai,
                              color: Colors.purple.withOpacity(0.05),
                              borderColor: Colors.purple,
                              borderWidth: 2,
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                                color: Colors.purple,
                                shape: DataMarkerType.circle,
                                width: 6,
                                height: 6,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // ================= BOTTOM NAVIGATION BAR =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E70E0),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_rounded),
            label: 'Input Reps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Input Waktu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Daftar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline_rounded),
            label: 'Saran AI',
          ),
        ],
      ),
    );
  }
}

// --- DATA MODELS ---

class BoxPlotData {
  final String x;
  final double min;
  final double q1;
  final double median;
  final double q3;
  final double max;

  BoxPlotData(this.x, this.min, this.q1, this.median, this.q3, this.max);
}

class RadarData {
  final String kategori;
  final double nilai;

  RadarData(this.kategori, this.nilai);
}