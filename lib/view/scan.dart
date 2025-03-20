import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:plantfit/view/dataTanah.dart';
import 'package:plantfit/view/hasilDeteksi.dart';
import 'package:plantfit/view/riwayat.dart';
import 'package:plantfit/view/riwayatModel.dart';

class Result {
  final String label;
  final String latinName;
  final double confidence;
  final String description;
  final String handling;
  final String imagePath;

  Result({
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.description,
    required this.handling,
    required this.imagePath,
  });
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  int _selectedIndex = 2; // Index default untuk Deteksi
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String? _lastImagePath;
  bool _isCameraInitialized = false;

  // Hasil prediksi
  String? _label;
  String? _latinName;
  double? _confidence;
  String? _description;
  String? _handling;

  late DataTanah _dataTanah;

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Tambahkan ini
    loadModel();
    _dataTanah = DataTanah();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model/model.tflite',
      labels: 'assets/model/labels.txt',
    );
  }

  Future<Result?> predictUsingTFLite(String imagePath) async {
    try {
      final List<dynamic>? dynamicResults = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );

      if (dynamicResults != null && dynamicResults.isNotEmpty) {
        final int predictionIndex = dynamicResults[0]['index'] as int;
        final String label = dynamicResults[0]['label'] as String;
        final double confidence = dynamicResults[0]['confidence'] as double;

        // Check if the predictionIndex is valid
        if (predictionIndex < _dataTanah.treatment.length) {
          final String latinName =
              _dataTanah.treatment[predictionIndex]['latinName'] ?? '';
          return Result(
            label: label,
            latinName: latinName,
            confidence: confidence,
            description:
                _dataTanah.treatment[predictionIndex]['characteristics'] ?? '',
            handling: _dataTanah.treatment[predictionIndex]['handling'] ?? '',
            imagePath: imagePath,
          );
        } else {
          return Result(
            label: 'Tidak Diketahui',
            latinName: 'Tidak Diketahui',
            confidence: confidence,
            description: '',
            handling: '',
            imagePath: imagePath,
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<void> takePictureAndPredict() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        print("Taking picture...");
        final XFile image = await _cameraController!.takePicture();
        print("Picture taken: ${image.path}");

        setState(() {
          _lastImagePath = image.path; // Update _lastImagePath
        });

        print("Predicting image...");
        final result = await predictUsingTFLite(image.path);

        if (result != null) {
          setState(() {
            _label = result.label;
            _latinName = result.latinName;
            _confidence = result.confidence;
            _description = result.description;
            _handling = result.handling;
          });

          RiwayatStorage.addRiwayat(RiwayatItem(
            label: result.label,
            latinName: result.latinName,
            confidence: result.confidence,
            description: result.description,
            handling: result.handling,
            imagePath: result.imagePath,
            timestamp: DateTime.now(),
          ));

          print("Prediction successful: ${result.label}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HasilDeteksiPage(
                label: result.label,
                latinName: result.latinName,
                confidence: result.confidence,
                description: result.description,
                handling: result.handling,
                imagePath: result.imagePath,
              ),
            ),
          );
        } else {
          print("Prediction returned null");
        }
      } catch (e) {
        print("Error taking picture: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Gagal mengambil gambar. Pastikan kamera aktif.")),
        );
      }
    } else {
      print("Camera not initialized");
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _lastImagePath = image.path; // <-- Tambahkan ini
      });

      final result = await predictUsingTFLite(image.path);

      if (result != null) {
        bool _isProcessing = false;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HasilDeteksiPage(
              label: result.label,
              latinName: result.latinName,
              confidence: result.confidence,
              description: result.description,
              handling: result.handling,
              imagePath: result.imagePath,
            ),
          ),
        );
      }
    }
  }

  Future<void> testWithStaticImage() async {
    final result = await predictUsingTFLite('assets/test_image.jpg');
    if (result != null) {
      print("Test prediction: ${result.label}");
    } else {
      print("Test prediction failed");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/plantfit.png',
              height: 50,
            ),
            SizedBox(width: 10),
            Text(
              'Deteksi',
              style: GoogleFonts.lora(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF3E6606),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.orange, size: 25),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Pastikan kondisi tanah normal dan gambar jelas dengan pencahayaan baik dan latar belakang sederhana. "
                      "Aplikasi akan memproses dan menampilkan hasil jenis tanah Anda secara otomatis setelah melakukan klik deteksi.",
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: _lastImagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          Image.file(File(_lastImagePath!), fit: BoxFit.cover),
                    )
                  : (_cameraController != null &&
                          _cameraController!.value.isInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          ),
                        )
                      : Center(child: CircularProgressIndicator())),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      pickImageFromGallery, // Fungsi untuk mengambil gambar dari galeri
                  icon: Icon(Icons.image, color: Colors.black),
                  label: Text('Galeri'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[100],
                    minimumSize: Size(140, 40),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:
                      takePictureAndPredict, // Fungsi untuk mengambil gambar dari kamera
                  icon: Icon(Icons.camera_alt, color: Colors.black),
                  label: Text('Deteksi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[100],
                    minimumSize: Size(140, 40),
                  ),
                ),
              ],
            ),
            if (_label != null) ...[
              SizedBox(height: 16),
              Text("Hasil Deteksi:",
                  style: GoogleFonts.lora(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🌱 Jenis Tanah: $_label",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("🔍 Nama Latin: $_latinName"),
                    Text(
                        "📊 Akurasi: ${(_confidence! * 100).toStringAsFixed(2)}%"),
                    SizedBox(height: 8),
                    Text("📌 Karakteristik:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("$_description"),
                    SizedBox(height: 8),
                    Text("🛠 Penanganan:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("$_handling"),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
