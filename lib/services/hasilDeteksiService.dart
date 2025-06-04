import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HasilDeteksiService {
  static Future<List<Map<String, dynamic>>> getRiwayatDeteksi() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('detection_result')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        ...data,
        'timestamp': (data['timestamp'] is Timestamp)
            ? (data['timestamp'] as Timestamp).toDate()
            : null,
      };
    }).toList();
  }
}
