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
  final String kandungan;
  final String rekomendasiTanaman;

  const HasilDeteksiPage({
    Key? key,
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.description,
    required this.handling,
    required this.imagePath,
    required this.kandungan,
    required this.rekomendasiTanaman,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: Color(0xFF3E6606),
        elevation: 0,
        title: Text(
          'Detail Jenis Tanah',
          style: GoogleFonts.lora(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E6606),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    latinName,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600]),
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.verified, color: Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Akurasi: ${confidence.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Image Preview
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: imagePath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.landscape, size: 50, color: Colors.grey),
                          Text('Gambar Tanah',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 24),

            // Deskripsi Section
            _buildSection(
              title: "Deskripsi Tanah",
              icon: Icons.info_outline,
              color: Color(0xFF4285F4),
              content: description,
            ),
            SizedBox(height: 20),

            // Kandungan Section
            _buildSection(
              title: "Kandungan Mineral",
              icon: Icons.science,
              color: Color(0xFFEA4335),
              content: kandungan,
            ),
            SizedBox(height: 20),

            // Pengelolaan Section
            _buildSection(
              title: "Pengelolaan Tanah",
              icon: Icons.eco,
              color: Color(0xFF34A853),
              content: handling,
            ),
            SizedBox(height: 20),

            // Rekomendasi Tanaman
            if (rekomendasiTanaman.isNotEmpty)
              _buildPlantSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildPlantSection() {
    final plants = rekomendasiTanaman.split(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFFFBBC05).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.agriculture, 
                color: Color(0xFFFBBC05), size: 20),
            ),
            SizedBox(width: 8),
            Text(
              "Rekomendasi Tanaman",
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFBBC05),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plants.map((plant) => Chip(
              label: Text(plant.trim()),
              backgroundColor: Color(0xFFFBBC05).withOpacity(0.1),
              shape: StadiumBorder(
                side: BorderSide(color: Color(0xFFFBBC05).withOpacity(0.3)),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}