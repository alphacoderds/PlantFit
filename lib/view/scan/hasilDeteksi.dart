import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/services/firebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantfit/view/scan/dataTanah.dart';
import 'package:plantfit/services/backendService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plantfit/view/scan/offlineQueue.dart';

class HasilDeteksiPage extends StatefulWidget {
  final String label;
  final String latinName;
  final double confidence;
  final String imagePath;
  final String rekomendasiTanaman;

  const HasilDeteksiPage({
    Key? key,
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.imagePath,
    required this.rekomendasiTanaman,
  }) : super(key: key);

  @override
  _HasilDeteksiPageState createState() => _HasilDeteksiPageState();
}

class _HasilDeteksiPageState extends State<HasilDeteksiPage> {
  Map<String, dynamic>? detailTanah;
  String rekomendasiTanaman = '';
  bool _isSaving = false; // untuk mencegah simpan ganda
  String? uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    detailTanah = DataTanah().getDetailByNama(widget.label);
    rekomendasiTanaman = detailTanah?['rekomendasiTanaman'] ?? '';
  }

  Future<void> _simpanHasilDeteksi() async {
    if (_isSaving)
      Stack(
        children: [
          Opacity(
              opacity: 0.4,
              child: ModalBarrier(dismissible: false, color: Colors.black)),
          const Center(child: CircularProgressIndicator()),
        ],
      );

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda belum login.')),
        );
        return;
      }

      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;

      final imageFile = File(widget.imagePath);
      if (!imageFile.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar tidak ditemukan.')),
        );
        return;
      }

      if (isOnline) {
        // Upload ke Firestore + Storage
        final detectionRef =
            await FirebaseService.saveDetectionResultWithReference(
          userId: user.uid,
          hasil: widget.label,
          confidence: widget.confidence,
          imageFile: imageFile,
        );

        try {
          final imageUrl = await CloudStorageService().uploadImageToBackend(
            imageFile: imageFile,
            userId: user.uid,
            detectionId: detectionRef.id,
          );
          if (imageUrl != null) {
            await detectionRef.update({'image_url': imageUrl});
          }
        } catch (e) {
          print("Gagal upload gambar: $e");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan online.')),
        );
      } else {
        // Simpan ke queue offline
        final detectionData = {
          'userId': user.uid,
          'hasil': widget.label,
          'confidence': widget.confidence,
          'imagePath': widget.imagePath,
          'timestamp': DateTime.now().toIso8601String(),
        };

        await OfflineQueue.addToQueue(detectionData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline: Data disimpan sementara.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat menyimpan: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUrl = widget.imagePath.startsWith('http');
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E6606),
        elevation: 0,
        title: Text(
          'Hasil Deteksi',
          style: GoogleFonts.lora(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
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
                    widget.label,
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E6606),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.latinName,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.green, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Akurasi: ${widget.confidence.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            AspectRatio(
              aspectRatio: 1, // rasio 1:1
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isUrl
                    ? Image.network(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Text("Gagal memuat gambar.")),
                      )
                    : File(widget.imagePath).existsSync()
                        ? Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                    child: Text("Gagal memuat gambar lokal.")),
                          )
                        : const Center(
                            child: Text("Gambar lokal tidak ditemukan.")),
              ),
            ),

            const SizedBox(height: 24),

            // Deskripsi Section
            _buildSection(
              title: "Deskripsi Tanah",
              icon: Icons.info_outline,
              color: const Color(0xFF4285F4),
              content: detailTanah?['deskripsi'] ?? 'Data tidak tersedia',
            ),
            const SizedBox(height: 20),

            // Kandungan Section
            _buildSection(
              title: "Kandungan Mineral",
              icon: Icons.science,
              color: const Color(0xFFEA4335),
              content: detailTanah?['kandungan'] ?? 'Data tidak tersedia',
            ),
            const SizedBox(height: 20),

            // Pengelolaan Section
            _buildSection(
              title: "Pengelolaan Tanah",
              icon: Icons.eco,
              color: const Color(0xFF34A853),
              content: detailTanah?['pengelolaan'] ?? 'Data tidak tersedia',
            ),
            const SizedBox(height: 20),
            if (detailTanah?['characteristics'] != null && detailTanah!['characteristics'].toString().isNotEmpty)
              _buildSection(
                title: "Karakteristik Tanah",
                icon: Icons.terrain,
                color: const Color(0xFF6D4C41),
                content: detailTanah!['characteristics'],
              ),
               if (detailTanah?['characteristics'] != null) const SizedBox(height: 20),
            if (detailTanah?['handling'] != null && detailTanah!['handling'].toString().isNotEmpty)
              _buildSection(
                title: "Penanganan Tanah",
                icon: Icons.build_circle_outlined,
                color: const Color(0xFF1E88E5),
                content: detailTanah!['handling'],
              ),
            const SizedBox(height: 20),

            // Rekomendasi Tanaman
            if (rekomendasiTanaman.isNotEmpty) _buildPlantSection(),
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
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
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
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
              color: Colors.black,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildPlantSection() {
    final plants = rekomendasiTanaman.split(', ');
    final plantImages = {
      'Bawang Merah': 'assets/images/rekomendasi/bawangmerah.png',
      'Bayam': 'assets/images/rekomendasi/bayam.png',
      'Cabai': 'assets/images/rekomendasi/cabai.png',
      'Cengkeh': 'assets/images/rekomendasi/cengkeh.png',
      'Gandum': 'assets/images/rekomendasi/gandum.png',
      'Jagung': 'assets/images/rekomendasi/jagung.png',
      'Jagung Pulut': 'assets/images/rekomendasi/jagungpalut.png',
      'Jambu Mete': 'assets/images/rekomendasi/jambumete.png',
      'Kacang Hijau': 'assets/images/rekomendasi/kacanghijau.png',
      'Kacang Tanah': 'assets/images/rekomendasi/kacangtanah.png',
      'Kakao': 'assets/images/rekomendasi/kakao.png',
      'Kangkung': 'assets/images/rekomendasi/kangkung.png',
      'Kapas': 'assets/images/rekomendasi/kapas.png',
      'Karet': 'assets/images/rekomendasi/karet.png',
      'Kedelai': 'assets/images/rekomendasi/kedelai.png',
      'Kelapa Sawit': 'assets/images/rekomendasi/kelapasawit.png',
      'Kopi': 'assets/images/rekomendasi/kopi.png',
      'Labu': 'assets/images/rekomendasi/labu.png',
      'Melon': 'assets/images/rekomendasi/melon.png',
      'Nanas': 'assets/images/rekomendasi/nanas.png',
      'Padi': 'assets/images/rekomendasi/padi.png',
      'Pisang': 'assets/images/rekomendasi/pisang.png',
      'Sawit': 'assets/images/rekomendasi/sawit.png',
      'Semangka': 'assets/images/rekomendasi/semangka.png',
      'Singkong': 'assets/images/rekomendasi/singkong.png',
      'Sorgum': 'assets/images/rekomendasi/sorgum.png',
      'Tebu': 'assets/images/rekomendasi/tebu.png',
      'Teh': 'assets/images/rekomendasi/teh.png',
      'Tembakau': 'assets/images/rekomendasi/tembakau.png',
      'Tomat': 'assets/images/rekomendasi/tomat.png',
      'Ubi Jalar': 'assets/images/rekomendasi/ubijalar.png',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBC05).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.agriculture,
                  color: Color(0xFFFBBC05), size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              "Rekomendasi Tanaman",
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFBBC05),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: plants.map((plant) {
                final image =
                    plantImages[plant.trim()] ?? 'assets/images/plantfit.jpg';
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.asset(
                          image,
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          plant.trim(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
