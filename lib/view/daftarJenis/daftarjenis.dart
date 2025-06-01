import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarJenisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> soilTypes = [
      {
        'title': 'Aluvial',
        'description':
            'Tanah Aluvial berasal dari endapan lumpur sungai, biasanya ditemukan di dataran rendah. Teksturnya halus hingga sedang, kaya akan unsur hara, dan sangat subur, menjadikannya ideal untuk berbagai jenis tanaman seperti padi, jagung, sayuran, buah-buahan, dan tebu. Tanah ini mendukung pertanian intensif dengan pengolahan rutin untuk menjaga kesuburannya.',
        'image': 'assets/images/aluvial.png',
      },
      {
        'title': 'Grumosol',
        'description':
            'Grumosol adalah tanah liat berat yang terbentuk dari batuan kapur atau vulkanik, berwarna kelabu hingga hitam, dan mengalami retakan besar saat musim kemarau. Tanah ini memiliki kandungan lempung tinggi dan cenderung basa, cocok untuk tanaman padi, jagung, kapas, serta tebu. Perlu pengelolaan drainase dan pengolahan intensif untuk hasil optimal.',
        'image': 'assets/images/grumosol.png',
      },
      {
        'title': 'Laterit',
        'description':
            'Tanah Laterit terbentuk di daerah tropis dengan curah hujan tinggi, kaya akan oksida besi dan aluminium, sehingga berwarna merah hingga kecokelatan. Tanah ini miskin unsur hara dan cenderung asam, sehingga memerlukan pemupukan dan pengapuran untuk meningkatkan kesuburannya. Cocok untuk tanaman keras seperti karet, kelapa sawit, kopi, kakao, dan singkong.',
        'image': 'assets/images/laterit.png',
      },
      {
        'title': 'Regosol',
        'description':
            'Tanah Regosol merupakan tanah muda hasil pelapukan material vulkanik, bertekstur kasar hingga sedang, dengan kandungan bahan organik yang rendah. Regosol memiliki drainase yang baik namun mudah kering, sehingga cocok untuk tanaman palawija seperti jagung, kacang tanah, singkong, cabai, dan tomat. Pengelolaan tanah ini membutuhkan tambahan bahan organik secara rutin.',
        'image': 'assets/images/regosol.png',
      },
      {
        'title': 'Vertisol',
        'description':
            'Vertisol adalah tanah liat berat yang sangat plastis saat basah dan membentuk retakan besar saat kering. Mengandung mineral lempung montmorillonit yang tinggi, tanah ini kaya unsur hara tetapi sulit diolah. Cocok untuk tanaman seperti padi, kapas, sorgum, dan kedelai. Pengolahan terbaik dilakukan saat kadar air tanah dalam kondisi optimum.',
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSoilPage(
                      title: soil['title']!,
                      description: soil['description']!,
                      image: soil['image']!,
                    ),
                  ),
                );
              },
              child: Container(
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailSoilPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const DetailSoilPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF5E3),
        elevation: 0,
        title: Text(
          title,
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF3E6606),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
