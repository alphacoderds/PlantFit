import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarJenisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> soilTypes = [
      {
        'title': 'Regosol',
        'description': 'Tanah vulkanik muda, subur dan cocok untuk pertanian.',
        'image': 'assets/images/regosol.png',
      },
      {
        'title': 'Laterit',
        'description': 'Tanah dengan kandungan besi tinggi, kurang subur.',
        'image': 'assets/images/laterit.png',
      },
      {
        'title': 'Aluvial',
        'description': 'Tanah endapan sungai, sangat cocok untuk bertani.',
        'image': 'assets/images/aluvial.png',
      },
      {
        'title': 'Grumosol',
        'description': 'Tanah liat berat, menyimpan air dengan baik.',
        'image': 'assets/images/grumosol.png',
      },
      {
        'title': 'Vertisol',
        'description': 'Tanah mengembang dan mengerut, cocok untuk kapas.',
        'image': 'assets/images/vertisol.png',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/plantfit.png', height: 50),
            const SizedBox(width: 10),
            Text(
              'Daftar Jenis Tanah',
              style: GoogleFonts.lora(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF3E6606),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: soilTypes.length,
          itemBuilder: (context, index) {
            final soil = soilTypes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      soil['image']!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          soil['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF3E6606),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          soil['description']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
