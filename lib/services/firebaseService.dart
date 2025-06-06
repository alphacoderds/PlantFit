import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static Future<void> uploadDetectionResult({
    required String userId,
    required String hasil,
    required double confidence,
    required File imageFile,
    bool uploadToStorage = true, // jika false, tidak upload ke Cloud Storage
  }) async {
    try {
      String imageUrl = '';

      if (uploadToStorage) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('detection_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

          final uploadTaskSnapshot = await storageRef.putFile(imageFile);
          imageUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        } catch (e) {
          print("⚠️ Gagal upload gambar ke Storage, lanjut simpan data tanpa URL: $e");
        }
      }

      final detectionData = {
        'hasil': hasil,
        'confidence': confidence,
        'image_url': imageUrl, 
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('detection_result')
          .add(detectionData);

      print("✅ Data berhasil disimpan ke Firestore.");
    } catch (e) {
      print("❌ Gagal menyimpan hasil deteksi: $e");
    }
  }
}
