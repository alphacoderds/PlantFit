import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        // <-- Added SingleChildScrollView here
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid Kategori Tanah
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  List<String> titles = [
                    'Regosol',
                    'Laterit',
                    'Aluvial',
                    'Grumosol',
                    'Vertisol'
                  ];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 120,
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
                          Icon(Icons.landscape, size: 50, color: Colors.green),
                          SizedBox(height: 5),
                          Text(
                            titles[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
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
                color: Colors.black,
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
                          '200', // Total semua deteksi
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
                            sections: [
                              PieChartSectionData(
                                value: 40, // 20%
                                title: '20%',
                                color: Color(0xFF4CAF50), // Hijau tua
                                radius: 60,
                                titleStyle: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget:
                                    _ChartBadge('Regosol', Color(0xFF4CAF50)),
                                badgePositionPercentageOffset: 1.2,
                              ),
                              PieChartSectionData(
                                value: 30, // 15%
                                title: '15%',
                                color: Color(0xFF8BC34A), // Hijau muda
                                radius: 60,
                                titleStyle: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget:
                                    _ChartBadge('Laterit', Color(0xFF8BC34A)),
                                badgePositionPercentageOffset: 1.3,
                              ),
                              PieChartSectionData(
                                value: 50, // 25%
                                title: '25%',
                                color: Color(0xFFFFDF88), // Kuning hijau
                                radius: 60,
                                titleStyle: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget:
                                    _ChartBadge('Aluvial', Color(0xFFFFDF88)),
                                badgePositionPercentageOffset: 1.1,
                              ),
                              PieChartSectionData(
                                value: 40, // 20%
                                title: '20%',
                                color: Color(0xFFFFA55D), // Coklat
                                radius: 60,
                                titleStyle: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget:
                                    _ChartBadge('Grumosol', Color(0xFFFFA55D)),
                                badgePositionPercentageOffset: 1.3,
                              ),
                              PieChartSectionData(
                                value: 40, // 20%
                                title: '20%',
                                color: Color(0xFFA76545), // Biru abu-abu
                                radius: 60,
                                titleStyle: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget:
                                    _ChartBadge('Vertisol', Color(0xFFA76545)),
                                badgePositionPercentageOffset: 1.2,
                              ),
                            ],
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
                    children: [
                      _LegendItem(
                        color: Color(0xFF4CAF50),
                        text: 'Regosol (20%)',
                        value: '40 deteksi',
                      ),
                      _LegendItem(
                        color: Color(0xFF8BC34A),
                        text: 'Laterit (15%)',
                        value: '30 deteksi',
                      ),
                      _LegendItem(
                        color: Color(0xFFFFDF88),
                        text: 'Aluvial (25%)',
                        value: '50 deteksi',
                      ),
                      _LegendItem(
                        color: Color(0xFFFFA55D),
                        text: 'Grumosol (20%)',
                        value: '40 deteksi',
                      ),
                      _LegendItem(
                        color: Color(0xFFA76545),
                        text: 'Vertisol (20%)',
                        value: '40 deteksi',
                      ),
                    ],
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
