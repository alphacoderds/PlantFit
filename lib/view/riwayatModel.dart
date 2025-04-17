import 'package:plantfit/view/riwayat.dart';

class RiwayatStorage {
  static List<RiwayatItem> riwayatList = [];

  static void addRiwayat(RiwayatItem item) {
    riwayatList.add(item);
  }

  static List<RiwayatItem> getAllRiwayat() {
    return riwayatList.reversed.toList(); 
  }
}
