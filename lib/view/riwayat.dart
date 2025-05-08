import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/register.dart';
import 'package:plantfit/view/login.dart';
import 'package:plantfit/view/daftarjenis.dart';
import 'package:plantfit/view/scan.dart';
import 'package:plantfit/view/riwayatModel.dart';
import 'package:plantfit/view/hasilDeteksi.dart';

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

class _RiwayatPageState extends State<RiwayatPage> {
  int _selectedIndex = 3; // Sesuaikan dengan index riwayat

  @override
  Widget build(BuildContext context) {
    List<RiwayatItem> riwayatList = RiwayatStorage.getAllRiwayat();

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
      body: riwayatList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada riwayat deteksi.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                final item = riwayatList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    );
  }
}
