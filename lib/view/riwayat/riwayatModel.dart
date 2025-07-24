import 'package:plantfit/view/riwayat/riwayat.dart';

/// Class untuk menyimpan riwayat deteksi
class RiwayatStorage {
  static final List<RiwayatItem> _riwayatList = [];

  /// Menambahkan item ke riwayat
  static void addRiwayat(RiwayatItem item) {
    _riwayatList.insert(0, item); // Tambahkan di awal list
    if (_riwayatList.length > 50) {
      _riwayatList.removeLast(); // Batasi jumlah riwayat
    }
  }

  /// Mendapatkan semua riwayat
  static List<RiwayatItem> getAllRiwayat() {
    return List.from(_riwayatList); 
  }

  /// Menghapus semua riwayat
  static void clearRiwayat() {
    _riwayatList.clear();
  }
}