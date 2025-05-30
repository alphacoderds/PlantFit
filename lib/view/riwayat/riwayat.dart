import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/riwayat/riwayatModel.dart';
import 'package:plantfit/view/scan/hasilDeteksi.dart';

class RiwayatItem {
  final String label;
  final String latinName;
  final double confidence;
  final String description;
  final String handling;
  final String imagePath;
  final String kandungan; // Tambahkan
  final String rekomendasiTanaman; // Tambahkan
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
  RiwayatFilter _selectedFilter = RiwayatFilter.semua;

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
    List<RiwayatItem> riwayatList = RiwayatStorage.getAllRiwayat();
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
                              ? Image.file(
                                  File(item.imagePath),
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
                                  description: item.description,
                                  handling: item.handling,
                                  imagePath: item.imagePath,
                                  kandungan: item.kandungan,
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