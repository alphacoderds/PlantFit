import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarJenisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> soilTypes = [
      {
        'title': 'Alluvial',
        'description':
            'Tanah Alluvial terbentuk dari endapan lumpur yang dibawa oleh aliran sungai dan biasanya terdapat di wilayah dataran rendah. Proses sedimentasi ini berlangsung selama bertahun-tahun, sehingga menghasilkan tanah yang relatif muda dengan tingkat kesuburan tinggi. Tekstur tanah ini halus hingga sedang, serta memiliki kandungan unsur hara yang melimpah seperti nitrogen dan fosfor. Warna tanah Alluvial umumnya cokelat hingga kelabu muda, dan memiliki kemampuan menahan air dengan baik, menjadikannya ideal untuk pertanian lahan basah. Tanah ini sangat cocok untuk tanaman pangan seperti padi, jagung, dan sayuran, serta tanaman industri seperti tebu. Dengan pengolahan dan irigasi yang baik, tanah Alluvial bisa mendukung pertanian intensif secara berkelanjutan.',
        'image': 'assets/images/alluvial.png',
      },
      {
        'title': 'Grumosol',
        'description':
            'Tanah Grumosol adalah jenis tanah yang terbentuk dari batuan kapur atau material vulkanik, yang umumnya dijumpai di wilayah dengan curah hujan sedang hingga rendah. Tanah ini dikenal dengan warna kelabu hingga hitam dan teksturnya yang liat berat. Salah satu ciri khas Grumosol adalah kemampuannya membentuk retakan besar saat musim kemarau akibat sifat menyusut dan mengembang yang tinggi. Meskipun memiliki kandungan unsur hara cukup baik, drainase tanah ini cenderung buruk karena daya resap air yang rendah. Tanaman seperti padi, jagung, kapas, dan tebu dapat tumbuh dengan baik di tanah ini, tetapi diperlukan pengelolaan intensif seperti sistem drainase yang baik dan pengolahan tanah yang tepat untuk memaksimalkan hasil pertanian.',
        'image': 'assets/images/grumosol.png',
      },
      {
        'title': 'Laterit',
        'description':
            'Tanah Laterit terbentuk di daerah tropis basah dengan curah hujan tinggi, melalui proses pelapukan batuan yang berlangsung lama. Tingginya curah hujan menyebabkan unsur hara tercuci, dan menyisakan kandungan oksida besi dan aluminium yang tinggi, sehingga tanah ini berwarna merah atau cokelat kemerahan. Karena unsur hara tercuci, tanah ini umumnya miskin nutrisi penting bagi tanaman. Selain itu, tanah Laterit juga bersifat asam dan cenderung keras saat kering. Oleh sebab itu, pemupukan dan pengapuran perlu dilakukan secara rutin untuk meningkatkan kesuburannya. Tanah Laterit cocok untuk tanaman tahunan seperti karet, kelapa sawit, kakao, kopi, dan singkong, terutama jika dibarengi dengan teknik konservasi tanah yang tepat seperti pemanfaatan mulsa dan tanaman penutup tanah.',
        'image': 'assets/images/laterit.png',
      },
      {
        'title': 'Regosol',
        'description':
            'Tanah Regosol berasal dari pelapukan material vulkanik muda seperti abu dan pasir vulkanik, sehingga sering ditemukan di sekitar daerah gunung berapi aktif atau bekas erupsi. Tanah ini memiliki struktur yang longgar dan tekstur kasar hingga sedang. Karena terbentuk dari material baru, kandungan bahan organiknya masih rendah dan tanah ini cenderung cepat mengering. Namun, Regosol memiliki keunggulan pada sistem aerasi dan drainase yang baik, membuat akar tanaman mudah berkembang. Dengan tambahan pupuk organik atau kompos, tanah ini sangat cocok untuk tanaman hortikultura seperti cabai, tomat, kacang tanah, singkong, dan jagung. Petani perlu memberikan perawatan rutin agar kandungan nutrisi tanah tetap terjaga.',
        'image': 'assets/images/regosol.png',
      },
      {
        'title': 'Vertisol',
        'description':
            'Tanah Vertisol merupakan jenis tanah liat berat yang kaya akan mineral lempung, terutama montmorillonit. Tanah ini banyak ditemukan di dataran rendah atau daerah dengan musim kering dan basah yang bergantian. Warna tanah ini cenderung hitam dan sangat subur. Ciri khas utama Vertisol adalah sifatnya yang sangat plastis saat basah dan mudah pecah membentuk retakan besar saat kering. Hal ini membuat pengolahan tanah menjadi cukup sulit dan memerlukan waktu tertentu saat kadar air berada dalam kondisi ideal. Tanaman seperti padi, kedelai, sorgum, dan kapas sangat cocok ditanam di tanah Vertisol. Untuk hasil maksimal, pengolahan tanah sebaiknya dilakukan saat tanah tidak terlalu basah atau terlalu kering, dan disertai praktik rotasi tanaman agar struktur tanah tetap baik.',
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
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
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
