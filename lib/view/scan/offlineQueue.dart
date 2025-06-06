import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OfflineQueue {
  static Future<File> _getQueueFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/offline_queue.json');
  }

  static Future<void> addToQueue(Map<String, dynamic> data) async {
    final file = await _getQueueFile();
    List<Map<String, dynamic>> queue = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      queue = List<Map<String, dynamic>>.from(jsonDecode(content));
    }

    queue.add(data);
    await file.writeAsString(jsonEncode(queue));
  }

  static Future<List<Map<String, dynamic>>> getQueue() async {
    final file = await _getQueueFile();
    if (!(await file.exists())) return [];
    final content = await file.readAsString();
    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  static Future<void> clearQueue() async {
    final file = await _getQueueFile();
    if (await file.exists()) await file.writeAsString(jsonEncode([]));
  }
}
