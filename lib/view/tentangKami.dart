import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD5E8B2), // Warna latar belakang hijau muda
      appBar: AppBar(
        backgroundColor: Color(0xFFD5E8B2),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF3E6606)),
        title: Text(
          'Tentang Kami',
          style: GoogleFonts.lora(
            color: Color(0xFF3E6606),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/plantfit.png',
                height: 120), // Logo di atas
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tentang Aplikasi',
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi PlantFit merupakan aplikasi berbasis Artificial Intelligence (AI) '
              'yang bertujuan untuk membantu pengguna dalam mendeteksi jenis tanah secara akurat '
              'melalui gambar. Aplikasi ini dirancang untuk memudahkan petani, pelajar, dan masyarakat umum '
              'dalam mengenal karakteristik tanah dan rekomendasi tanaman untuk mendukung optimalisasi hasil pertanian.',
              style: GoogleFonts.lora(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tentang Pengembang',
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi ini dikembangkan oleh Rahmanda Putri Radisa, mahasiswa Teknologi Informasi di Politeknik Negeri Madiun sebagai bagian dari tugas akhir dan pengembangan inovasi machine learning berbasis mobile.',
              style: GoogleFonts.lora(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
