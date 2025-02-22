import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerPage> {
  File? _selectedImage;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
    }
  }

  Future<void> captureImageFromCamera() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _selectedImage = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar berhasil diambil'),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        debugPrint("Error capturing image: $e");
      }
    } else {
      debugPrint("Kamera tidak tersedia.");
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
              onPressed: captureImageFromCamera,
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
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ambil Gambar dengan Kamera',
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
  runApp(const MaterialApp(home: ScannerPage()));
}
