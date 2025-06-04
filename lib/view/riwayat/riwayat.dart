import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/scan/hasilDeteksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RiwayatItem {
  final String label;
  final String latinName;
  final double confidence;
  final String description;
  final String handling;
  final String imagePath;
  final String kandungan;
  final String rekomendasiTanaman;
  final DateTime timestamp;

  RiwayatItem({
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.description,
    required this.handling,
    required this.imagePath,
    required this.kandungan,
    required this.rekomendasiTanaman,
    required this.timestamp,
  });
}

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

enum RiwayatFilter { semua, hariIni, mingguIni, bulanIni }

class _RiwayatPageState extends State<RiwayatPage> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  RiwayatFilter _selectedFilter = RiwayatFilter.semua;
  late CollectionReference _riwayatCollection;

  List<RiwayatItem> _allRiwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      _riwayatCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId!)
          .collection('detection_result');
      _fetchRiwayatFromFirestore();
    }
  }

  void _fetchRiwayatFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    setState(() {
      _isLoading = true;
    });

    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!)
          .collection('detection_result')
          .orderBy('timestamp', descending: true)
          .get();

      final riwayatList = snapshot.docs.map((doc) {
        final data = doc.data();
        final label = data['hasil'] ?? '';
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
        _allRiwayat = riwayatList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat riwayat: $e')),
      );
    }
  }

  List<RiwayatItem> getFilteredRiwayat(List<RiwayatItem> list) {
    DateTime now = DateTime.now();

    return list.where((item) {
      switch (_selectedFilter) {
        case RiwayatFilter.hariIni:
          return item.timestamp.day == now.day &&
              item.timestamp.month == now.month &&
              item.timestamp.year == now.year;
        case RiwayatFilter.mingguIni:
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          return item.timestamp.isAfter(startOfWeek) &&
              item.timestamp.isBefore(now.add(const Duration(days: 1)));
        case RiwayatFilter.bulanIni:
          return item.timestamp.month == now.month &&
              item.timestamp.year == now.year;
        case RiwayatFilter.semua:
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    List<RiwayatItem> riwayatList = _allRiwayat;
    List<RiwayatItem> filteredRiwayatList = getFilteredRiwayat(riwayatList);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/plantfit.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 10),
            Text(
              "Riwayat Deteksi",
              style: GoogleFonts.lora(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF3E6606),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                const Text("Filter: "),
                const SizedBox(width: 10),
                DropdownButton<RiwayatFilter>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: RiwayatFilter.semua,
                      child: Text("Semua"),
                    ),
                    DropdownMenuItem(
                      value: RiwayatFilter.hariIni,
                      child: Text("Hari Ini"),
                    ),
                    DropdownMenuItem(
                      value: RiwayatFilter.mingguIni,
                      child: Text("Minggu Ini"),
                    ),
                    DropdownMenuItem(
                      value: RiwayatFilter.bulanIni,
                      child: Text("Bulan Ini"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilter = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredRiwayatList.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada riwayat untuk filter ini.",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredRiwayatList.length,
                    itemBuilder: (context, index) {
                      final item = filteredRiwayatList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: item.imagePath.isNotEmpty
                              ? Image.network(
                                  (item.imagePath),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                )
                              : const Icon(Icons.image),
                          title: Text(
                            item.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Akurasi: ${(item.confidence * 100).toStringAsFixed(2)}%\n"
                            "Waktu: ${item.timestamp.toLocal().toString().substring(0, 16)}",
                          ),
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
