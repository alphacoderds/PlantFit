import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HasilDeteksiPage extends StatelessWidget {
  final String label;
  final String latinName;
  final double confidence;
  final String description;
  final String handling;
  final String imagePath;

  const HasilDeteksiPage({
    Key? key,
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.description,
    required this.handling,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Deteksi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🌱 Jenis Tanah: $label",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("🔍 Nama Latin: $latinName"),
            Text("📊 Akurasi: ${(confidence * 100).toStringAsFixed(2)}%"),
            SizedBox(height: 8),
            Text("📌 Karakteristik:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(description),
            SizedBox(height: 8),
            Text("🛠 Penanganan:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(handling),
            SizedBox(height: 20),
            Image.file(File(imagePath), fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
