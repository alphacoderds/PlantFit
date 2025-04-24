import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plantfit/view/riwayat.dart';
import 'package:plantfit/view/riwayatModel.dart';
import 'dart:io';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<RiwayatItem> latestRiwayat = [];

  @override
  void initState() {
    super.initState();
    _loadLatestRiwayat();
  }

  void _loadLatestRiwayat() async {
    List<RiwayatItem> allRiwayat = await RiwayatStorage.getAllRiwayat();
    allRiwayat.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    setState(() {
      latestRiwayat = allRiwayat.take(10).toList();
    });
  }

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _loadLatestRiwayat();
      _isLoaded = true;
    }
  }

  Map<String, int> _countSoilTypes(List<RiwayatItem> items) {
    Map<String, int> counts = {};
    for (var item in items) {
      counts[item.label] = (counts[item.label] ?? 0) + 1;
    }
    return counts;
  }

  List<PieChartSectionData> _buildPieChartSections(
      Map<String, int> soilCounts) {
    final total = soilCounts.values.fold(0, (sum, val) => sum + val);
    final colors = {
      'Regosol': Color(0xFF4CAF50),
      'Laterit': Color(0xFF8BC34A),
      'Aluvial': Color(0xFFFFDF88),
      'Grumosol': Color(0xFFFFA55D),
      'Vertisol': Color(0xFFA76545),
    };

    return soilCounts.entries.map((entry) {
      final percentage = (entry.value / total * 100).toStringAsFixed(0);
      final color = colors[entry.key] ?? Colors.grey;

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '$percentage%',
        color: color,
        radius: 60,
        titleStyle: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _ChartBadge(entry.key, color),
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  List<Widget> _buildLegendItems(Map<String, int> soilCounts) {
    final colors = {
      'Regosol': Color(0xFF4CAF50),
      'Laterit': Color(0xFF8BC34A),
      'Aluvial': Color(0xFFFFDF88),
      'Grumosol': Color(0xFFFFA55D),
      'Vertisol': Color(0xFFA76545),
    };

    return soilCounts.entries.map((entry) {
      final color = colors[entry.key] ?? Colors.grey;
      return _LegendItem(
        color: color,
        text:
            '${entry.key} (${((entry.value / latestRiwayat.length) * 100).toStringAsFixed(0)}%)',
        value: '${entry.value} deteksi',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/plantfit.png',
              height: 50,
            ),
            SizedBox(width: 10),
            Text(
              'Dashboard',
              style: GoogleFonts.lora(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF3E6606),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: latestRiwayat.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada hasil deteksi.',
                        style: GoogleFonts.lora(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: latestRiwayat.length,
                      itemBuilder: (context, index) {
                        final item = latestRiwayat[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (item.imagePath ?? '').isNotEmpty &&
                                        File(item.imagePath).existsSync()
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(item.imagePath),
                                          width: 120,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image,
                                                      color: Colors.grey),
                                        ),
                                      )
                                    : Icon(Icons.landscape,
                                        size: 50, color: Colors.green),
                                SizedBox(height: 5),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Text(
              'Grafik Hasil Deteksi',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E6606),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Total Detections Card
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF3E6606).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Deteksi:',
                          style: GoogleFonts.lora(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${latestRiwayat.length}',
                          style: GoogleFonts.lora(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E6606),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Pie Chart dengan 5 jenis tanah
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.2,
                      child: AspectRatio(
                        aspectRatio: 1.6,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 50,
                            startDegreeOffset: -90,
                            sections: _buildPieChartSections(
                                _countSoilTypes(latestRiwayat)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Legend untuk 5 jenis tanah
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 10,
                    children: _buildLegendItems(_countSoilTypes(latestRiwayat)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _ChartBadge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.lora(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final String value;

  const _LegendItem({
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                text,
                style: GoogleFonts.lora(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.lora(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
