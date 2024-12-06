import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  File? _selectedImage;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Warna garis scan
        'Cancel', // Tombol batal
        true, // Format kamera
        ScanMode.BARCODE, // Mode scan (BARCODE atau QRCODE)
      );

      if (barcodeScanRes != '-1') {
        // Jika berhasil scan (bukan dibatalkan)
        debugPrint("Hasil scan: $barcodeScanRes");

        // Menampilkan hasil scan dengan SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hasil scan: $barcodeScanRes'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on PlatformException {
      debugPrint("Error: Failed to scan barcode.");
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar berhasil dipilih'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlantFit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scanBarcodeNormal,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(25),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Scan Kamera',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImageFromGallery,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(25),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.photo_library,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pilih Gambar dari Galeri',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const Text(
                    "Belum ada gambar dipilih",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Scanner()));
}
