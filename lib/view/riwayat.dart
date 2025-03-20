import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/register.dart';
import 'package:plantfit/view/login.dart';
import 'package:plantfit/view/daftarjenis.dart';
import 'package:plantfit/view/scan.dart';
import 'package:plantfit/view/riwayatModel.dart';

class RiwayatItem {
  final String label;
  final String latinName;
  final double confidence;
  final String description;
  final String handling;
  final String imagePath;
  final DateTime timestamp;

  RiwayatItem({
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.description,
    required this.handling,
    required this.imagePath,
    required this.timestamp,
  });
}

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DaftarJenisPage(),
    ScannerPage(),
    RegisterPage(),
    LoginPage(),
    RiwayatPage(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

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
                  elevation: 3,
                  child: ListTile(
                    leading: Image.file(
                      File(item.imagePath),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF3E6606),
                      ),
                    ),
                    subtitle: Text(
                      "Akurasi: ${(item.confidence * 100).toStringAsFixed(2)}%\n"
                      "Waktu: ${item.timestamp.toLocal()}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
