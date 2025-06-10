import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudStorageService {
  Future<String> uploadImageToBackend({
    required File imageFile,
    required String userId,
    required String detectionId,
  }) async {
    final uri = Uri.parse('https://plantfit-backend-364500172149.asia-southeast2.run.app/upload');

    print('🔍 Uploading: ${imageFile.path}');
    print('📦 Size: ${imageFile.lengthSync()} bytes');

    final request = http.MultipartRequest('POST', uri)
      ..fields['userId'] = userId
      ..fields['detectionId'] = detectionId
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print("📥 Response body: $responseBody");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);

        // Periksa nama field yang benar
        if (jsonResponse.containsKey('imageUrl')) {
          return jsonResponse['imageUrl'];
        } else if (jsonResponse.containsKey('url')) {
          return jsonResponse['url'];
        } else {
          print("⚠️ Field 'imageUrl' tidak ditemukan dalam respons backend.");
          return '';
        }
      } else {
        print('🛑 Gagal upload gambar. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
        return '';
      }
    } catch (e, stack) {
      print('❌ Exception saat upload: $e');
      print(stack);
      return '';
    }
  }
}
