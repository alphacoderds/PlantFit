import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:plantfit/services/backendService.dart';

class FirebaseService {
  /// Upload gambar ke Firebase Storage (lama, opsional)
  static Future<String> uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'detection_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("⚠️ Gagal upload gambar ke Firebase Storage: $e");
      return '';
    }
  }

  /// Simpan hasil deteksi + upload gambar (utama)
  static Future<void> uploadDetectionResult({
    required String userId,
    required String hasil,
    required double confidence,
    required File imageFile,
    bool useBackend = true,
  }) async {
    try {
      String imageUrl = '';
      DocumentReference? docRef;

      // Tambah data Firestore dengan image_url kosong lebih dulu
      docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('detection_result')
          .add({
        'hasil': hasil,
        'confidence': confidence,
        'image_url': '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Upload gambar ke backend atau Firebase Storage
      if (useBackend) {
        imageUrl = await CloudStorageService().uploadImageToBackend(
          imageFile: imageFile,
          userId: userId,
          detectionId: docRef.id,
        );
      } else {
        imageUrl = await uploadImageToStorage(imageFile);
      }

      print("🔗 URL gambar yang didapat: $imageUrl");

      // Periksa & update URL gambar ke Firestore
      if (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
        await docRef.update({'image_url': imageUrl});
        print("✅ Gambar berhasil diupdate di Firestore.");
      } else {
        print("⚠️ URL gambar kosong atau tidak valid.");
      }
    } catch (e) {
      print("❌ Gagal menyimpan hasil deteksi: $e");
    }
  }

  /// Simpan deteksi dengan ref dan upload (dipakai di hasilDeteksi.dart)
  static Future<DocumentReference> saveDetectionResultWithReference({
    required String userId,
    required String hasil,
    required double confidence,
    required File imageFile,
  }) async {
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('detection_result')
        .add({
      'hasil': hasil,
      'confidence': confidence,
      'image_url': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    final imageUrl = await CloudStorageService().uploadImageToBackend(
      imageFile: imageFile,
      userId: userId,
      detectionId: docRef.id,
    );

    if (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      await docRef.update({'image_url': imageUrl});
      print("✅ Gambar berhasil diupdate di Firestore.");
    } else {
      print("⚠️ Gagal update image_url di Firestore (URL tidak valid)");
    }

    return docRef;
  }

  /// Sinkronisasi antrean offline
  static Future<void> syncOfflineQueue(List<Map<String, dynamic>> queue) async {
    for (var item in queue) {
      try {
        final String userId = item['userId'];
        final String hasil = item['hasil'];
        final double confidence = (item['confidence'] as num).toDouble();
        final String imagePath = item['imagePath'];

        final File imageFile = File(imagePath);

        if (await imageFile.exists()) {
          await uploadDetectionResult(
            userId: userId,
            hasil: hasil,
            confidence: confidence,
            imageFile: imageFile,
            useBackend: true,
          );
        } else {
          print("⚠️ Gambar offline tidak ditemukan: $imagePath");
        }
      } catch (e) {
        print("❌ Gagal upload dari antrean offline: $e");
      }
    }
  }
}
