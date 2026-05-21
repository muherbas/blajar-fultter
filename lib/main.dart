import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Menggunakan satu package utama agar aman dari konflik shader

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DashboardAtlet(),
    );
  }
}

class DashboardAtlet extends StatefulWidget {
  const DashboardAtlet({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardAtletView();
  }
}

class DashboardAtletView extends StatefulWidget {
  const DashboardAtletView({super.key});

  @override
  State<DashboardAtletView> createState() => _DashboardAtletViewState();
}

// Model data untuk Boxplot 7 Parameter Utama
class BoxPlotData {
  final String x;
  final List<num> y;
  BoxPlotData(this.x, this.y);
}

// Model data untuk Radial Bar Chart Interaktif
class RadialChartData {
  final String x;
  final num y;
  final Color color;
  RadialChartData(this.x, this.y, this.color);
}

class _DashboardAtletViewState extends State<DashboardAtletView> {
  String parameterTurunanTerpilih = "MUSCULAR ENDURANCE"; // Default awal

  // Data 10 Parameter Komponen Turunan
  final Map<String, double> komponenTurunan = {
    "MUSCULAR ENDURANCE": 78,
    "POWER": 82,
    "CORE STABILITY": 70,
    "DYNAMIC FLEXIBILITY": 65,
    "SPEED ENDURANCE": 75,
    "REACTIVE SPEED": 60,
    "AGILITY": 88,
    "ANTICIPATION & SPATIAL AWARENESS": 80,
    "MOBILITY": 72,
    "OPEN REACTIVE AGILITY": 67,
  };

  double get rataRataTurunan {
    double total = komponenTurunan.values.fold(0, (sum, item) => sum + item);
    return total / komponenTurunan.length;
  }

  @override
  Widget build(BuildContext context) {
    // Data sebaran Boxplot 7 Parameter Utama
    final List<BoxPlotData> dataBoxPlot = [
      BoxPlotData('STRENGTH', [45, 60, 75, 82, 95]),
      BoxPlotData('ENDURANCE', [50, 58, 68, 78, 92]),
      BoxPlotData('SPEED', [40, 52, 65, 74, 88]),
      BoxPlotData('COORD', [55, 65, 72, 85, 96]),
      BoxPlotData('FLEX', [35, 48, 60, 72, 85]),
      BoxPlotData('BALANCE', [60, 68, 76, 88, 98]),
      BoxPlotData('REACTION', [42, 50, 63, 75, 90]),
    ];

    double nilaiAktif = komponenTurunan[parameterTurunanTerpilih] ?? 0;

    // Data Radial Ring: Cincin luar adalah nilai parameter aktif, cincin dalam adalah rata-rata (Sebagai pengganti jarum pointer)
    final List<RadialChartData> dataRadialInteraktif = [
      RadialChartData('Skor Aktif', nilaiAktif, Colors.orangeAccent.shade700),
      RadialChartData('Rata-rata Murid', rataRataTurunan, Colors.indigo.shade900),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik Ruri", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ========================================================
            // GRAFIK 1: BOXPLOT 7 PARAMETER (KOMPONEN UTAMA)
            // ========================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "1 Boxplot Atlet: Komponen Utama",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: SfCartesianChart(
                        primaryXAxis: const CategoryAxis(
                          majorGridLines: MajorGridLines(width: 0),
                          labelStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                        primaryYAxis: const NumericAxis(
                          minimum: 0,
                          maximum: 100,
                          interval: 20,
                          majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey),
                        ),
                        plotAreaBorderWidth: 0,
                        series: <CartesianSeries<BoxPlotData, String>>[
                          BoxAndWhiskerSeries<BoxPlotData, String>(
                            dataSource: dataBoxPlot,
                            xValueMapper: (BoxPlotData data, _) => data.x,
                            yValueMapper: (BoxPlotData data, _) => data.y,
                            boxPlotMode: BoxPlotMode.normal,
                            showMean: true,
                            fillColor: Colors.blueAccent.withOpacity(0.6),
                            strokeColor: Colors.blue.shade900,
                            strokeWidth: 1.5,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Nilai Rata-Rata Keseluruhan Murid", style: TextStyle(fontSize: 9, color: Colors.black54)),
                            Text("68.5", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ========================================================
            // GRAFIK 2: RADIAL RING INTERAKTIF (10 PARAMETER TURUNAN)
            // ========================================================
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "1 Radar Atlet: Komponen Turunan",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'Avg: ${rataRataTurunan.toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),

                    // RADIAL BAR BERLAPIS (AMAN SEPANJANG MASA DARI ERROR GRADIENT SHADER)
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 160,
                            child: SfCircularChart(
                              key: UniqueKey(), // Memaksa grafik re-render mulus saat diklik
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  widget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${nilaiAktif.toStringAsFixed(0)}%',
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      const Text("SKOR", style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )
                              ],
                              series: <CircularSeries<RadialChartData, String>>[
                                RadialBarSeries<RadialChartData, String>(
                                  dataSource: dataRadialInteraktif,
                                  xValueMapper: (RadialChartData data, _) => data.x,
                                  yValueMapper: (RadialChartData data, _) => data.y,
                                  pointColorMapper: (RadialChartData data, _) => data.color,
                                  maximumValue: 100,
                                  radius: '100%',
                                  innerRadius: '55%',
                                  gap: '12%',
                                )
                              ],
                            ),
                          ),
                        ),
                        // Detail parameter terpilih
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("INFO INDIKATOR:", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                _buildLegendRow(Colors.orangeAccent.shade700, "Cincin Luar: Skor Aktif"),
                                const SizedBox(height: 4),
                                _buildLegendRow(Colors.indigo.shade900, "Cincin Dalam: Rata-rata"),
                                const Divider(height: 16),
                                const Text("TERPILIH ATLET:", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                Text(
                                  parameterTurunanTerpilih,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),

                    // LIST VIEW 10 PARAMETER INTERAKTIF
                    const Text("Sentuh nama komponen untuk memutar grafik:", style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 160,
                      child: ListView(
                        shrinkWrap: true,
                        children: komponenTurunan.keys.map((String key) {
                          bool isSelected = parameterTurunanTerpilih == key;
                          return Card(
                            color: isSelected ? Colors.orange.shade700 : Colors.grey.shade100,
                            margin: const EdgeInsets.only(bottom: 6),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                key,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 11,
                                ),
                              ),
                              trailing: Text(
                                '${komponenTurunan[key]?.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.orange.shade900,
                                  fontSize: 11,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  parameterTurunanTerpilih = key; 
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 4, color: color),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black70))),
      ],
    );
  }
}
