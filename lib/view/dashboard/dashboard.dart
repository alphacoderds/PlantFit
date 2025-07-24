import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plantfit/view/riwayat/riwayat.dart';
import 'package:plantfit/view/scan/hasilDeteksi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Menampilkan data deteksi tanah terbaru & grafik distribusi tanah
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Daftar untuk menyimpan riwayat deteksi terbaru
  List<RiwayatItem> latestRiwayat = [];
  List<RiwayatItem> allRiwayat = [];

  @override
  void initState() {
    super.initState();
    _loadLatestRiwayat();
    _checkProfileCompleteness();
  }

  Future<void> _loadLatestRiwayat() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User belum login.");
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('detection_result')
          .orderBy('timestamp', descending: true)
          .get();

      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return RiwayatItem(
          label: data['hasil'] ?? '',
          latinName: data['latinName'] ?? '',
          confidence: (data['confidence'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          handling: data['handling'] ?? '',
          imagePath: data['image_url'] ?? '',
          kandungan: data['kandungan'] ?? '',
          rekomendasiTanaman: data['rekomendasiTanaman'] ?? '',
          timestamp: (data['timestamp'] != null)
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();

      setState(() {
        allRiwayat = items;
        latestRiwayat = items.take(10).toList(); // Ambil 10 deteksi terbaru
      });
    } catch (e) {
      print('Gagal memuat riwayat dari Firestore: $e');
    }
  }

  Future<void> _checkProfileCompleteness() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!doc.exists) return;

    final data = doc.data()!;
    final name = data['name'] ?? '';
    final phone = data['phone'] ?? '';
    final gender = data['gender'] ?? '';
    final location = data['location'] ?? '';

    final isIncomplete =
        name.isEmpty || phone.isEmpty || gender.isEmpty || location.isEmpty;

    if (isIncomplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Profil Belum Lengkap",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E6606),
                ),
              ),
              content: Text(
                "Silakan lengkapi profil Anda terlebih dahulu untuk menggunakan aplikasi secara optimal.",
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Isi Sekarang",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  Map<String, int> _countSoilTypes(List<RiwayatItem> items) {
    Map<String, int> counts = {};
    for (var item in items) {
      String label =
          (item.label.trim().isEmpty) ? 'Tidak Diketahui' : item.label.trim();
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts;
  }

  List<PieChartSectionData> _buildPieChartSections(
      Map<String, int> soilCounts) {
    final total = soilCounts.values.fold(0, (sum, val) => sum + val);
    final colors = {
      'Regosol': Color(0xFF4CAF50),
      'Laterit': Color(0xFF8BC34A),
      'Alluvial': Color(0xFFFFDF88),
      'Grumosol': Color(0xFFFFA55D),
      'Vertisol': Color(0xFFA76545),
      'Tidak Diketahui': Color(0xFFCB0A0A),
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

  List<Widget> _buildLegendItems(Map<String, int> soilCounts, int total) {
    final colors = {
      'Regosol': Color(0xFF4CAF50),
      'Laterit': Color(0xFF8BC34A),
      'Alluvial': Color(0xFFFFDF88),
      'Grumosol': Color(0xFFFFA55D),
      'Vertisol': Color(0xFFA76545),
      'Tidak Diketahui': Color(0xFFCB0A0A),
    };

    return soilCounts.entries.map((entry) {
      final color = colors[entry.key.trim().isEmpty
              ? 'Tidak Diketahui'
              : entry.key.trim()] ??
          Colors.grey;

      return _LegendItem(
        color: color,
        text:
            '${entry.key} (${((entry.value / total) * 100).toStringAsFixed(0)}%)',
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
            Text(
              'Deteksi Terbaru',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E6606),
              ),
            ),
            SizedBox(height: 10),
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
                      itemCount:
                          latestRiwayat.length > 10 ? 10 : latestRiwayat.length,
                      itemBuilder: (context, index) {
                        final item = latestRiwayat[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HasilDeteksiPage(
                                    label: item.label,
                                    latinName: item.latinName,
                                    confidence: item.confidence,
                                    imagePath: item.imagePath,
                                    rekomendasiTanaman: item.rekomendasiTanaman,
                                  ),
                                ),
                              );
                            },
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
                                  (item.imagePath ?? '').isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            item.imagePath,
                                            width: 120,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return SizedBox(
                                                width: 120,
                                                height: 100,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.broken_image,
                                                        color: Colors.grey),
                                          ))
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
                          '${allRiwayat.length} ',
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
                        child: PieChart(PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 50,
                          startDegreeOffset: -90,
                          sections: _buildPieChartSections(
                              _countSoilTypes(allRiwayat)),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Legend untuk 5 jenis tanah
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 10,
                    children: _buildLegendItems(_countSoilTypes(allRiwayat),
                        allRiwayat.length), // Tambahkan argumen kedua
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
        text.isEmpty ? 'Tidak Diketahui' : text,
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
