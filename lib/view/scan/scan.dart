import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:plantfit/view/scan/dataTanah.dart';
import 'package:plantfit/view/scan/hasilDeteksi.dart';
import 'package:plantfit/view/riwayat/riwayat.dart';
import 'package:plantfit/view/riwayat/riwayatModel.dart';
import 'package:image/image.dart' as img;

class Result {
  final String label;
  final String latinName;
  final double confidence;
  final String description;
  final String handling;
  final String imagePath;
  final String kandungan;
  final String rekomendasiTanaman;

  Result({
    required this.label,
    required this.latinName,
    required this.confidence,
    required this.description,
    required this.handling,
    required this.imagePath,
    required this.kandungan,
    required this.rekomendasiTanaman,
  });
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  int _selectedIndex = 2;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String? _lastImagePath;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

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
    _dataTanah = DataTanah();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
      loadModel();
    });
  }

  void _showUnrecognizedDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Mencegah pengguna menutup dialog dengan mengetuk luar dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Menambahkan warna latar belakang
        title: Text(
          "Gambar Tidak Dikenali",
          textAlign: TextAlign.center, 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E6606), // Menambahkan warna hijau untuk judul
          ),
        ),
        content: Text(
          "Gambar tidak dikenali sebagai jenis tanah. Harap gunakan gambar tanah yang jelas dan dengan pencahayaan yang baik.",
          style: TextStyle(color: Colors.black87), 
          textAlign: TextAlign.center, 
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Coba Lagi",
              style: TextStyle(color: Colors.green), 
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Menutup dialog
              setState(() {
                _lastImagePath = null; // Mengatur ulang gambar terakhir
              });
            },
          ),
        ],
      );
    },
  );
}


  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
        }
      }
    } catch (e) {
      print("Error initializing camera: $e");
      if (mounted) {
        _showUnrecognizedDialog();
      }
    }
  }

  Future<String> _resizeImageTo150(String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Gagal decode image");
    img.Image resized = img.copyResize(image, width: 150, height: 150);

    final resizedPath = path.replaceFirst('.jpg', '_resized.jpg');
    await File(resizedPath).writeAsBytes(img.encodeJpg(resized));
    return resizedPath;
  }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: 'assets/model/model_b.tflite',
        labels: 'assets/model/labels.txt',
      );
      print("Model loaded successfully: $res");
    } catch (e) {
      print("Failed to load model: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat model")),
        );
      }
    }
  }

  Future<Result?> predictUsingTFLite(String imagePath) async {
    try {
      final resizedPath = await _resizeImageTo150(imagePath);
      final List<dynamic>? dynamicResults = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );

      if (dynamicResults == null || dynamicResults.isEmpty) {
        print("No results from model");
        return null;
      }

      final int predictionIndex = dynamicResults[0]['index'] as int;
      final String label = dynamicResults[0]['label']
          .toString()
          .replaceAll(RegExp(r'[0-9]'), '')
          .trim();
      final double confidence = dynamicResults[0]['confidence'] as double;

      // Pastikan predictionIndex valid
      if (predictionIndex < 0 ||
          predictionIndex >= _dataTanah.treatment.length) {
        print("Invalid prediction index: $predictionIndex");
        return null;
      }

      final soilData = _dataTanah.treatment[predictionIndex];
      return Result(
        label: soilData['nama'] ?? label,
        latinName: soilData['latinName'] ?? '',
        confidence: confidence,
        description: soilData['deskripsi'] ?? '',
        handling: soilData['pengelolaan'] ?? '',
        imagePath: imagePath,
        kandungan: soilData['kandungan'] ?? '',
        rekomendasiTanaman: soilData['rekomendasiTanaman'] ?? '',
      );
    } catch (e) {
      print("Error during prediction: $e");
      return null;
    }
  }

  Future<void> takePictureAndPredict() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kamera belum siap")),
      );
      return;
    }

    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final XFile image = await _cameraController!.takePicture();
      setState(() => _lastImagePath = image.path);

      final result = await predictUsingTFLite(image.path);

//Confidence Threshold = 0.4
      if (result != null && result.confidence >= 0.4) {
        RiwayatStorage.addRiwayat(RiwayatItem(
          label: result.label,
          latinName: result.latinName,
          confidence: result.confidence,
          description: result.description,
          handling: result.handling,
          imagePath: result.imagePath,
          kandungan: result.kandungan,
          rekomendasiTanaman: result.rekomendasiTanaman,
          timestamp: DateTime.now(),
        ));

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
              kandungan: result.kandungan,
              rekomendasiTanaman: result.rekomendasiTanaman,
            ),
          ),
        );

        setState(() {
          _lastImagePath = null;
        });
      } else {
        _showUnrecognizedDialog();
      }
    } catch (e) {
      print("Error taking picture: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> pickImageFromGallery() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => _lastImagePath = image.path);
        final result = await predictUsingTFLite(image.path);

        if (result != null && result.confidence >= 0.4) {
          RiwayatStorage.addRiwayat(RiwayatItem(
            label: result.label,
            latinName: result.latinName,
            confidence: result.confidence,
            description: result.description,
            handling: result.handling,
            imagePath: result.imagePath,
            kandungan: result.kandungan,
            rekomendasiTanaman: result.rekomendasiTanaman,
            timestamp: DateTime.now(),
          ));

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
                kandungan: result.kandungan,
                rekomendasiTanaman: result.rekomendasiTanaman,
              ),
            ),
          );
        }

        setState(() {
          _lastImagePath = null;
        });
      } else {
        _showUnrecognizedDialog();
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isProcessing = false);
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
                  Icon(Icons.info_outline, color: Colors.orange, size: 25),
                  SizedBox(width: 10),
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
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isProcessing
                    ? Center(child: CircularProgressIndicator())
                    : _lastImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(_lastImagePath!),
                                fit: BoxFit.cover),
                          )
                        : (_cameraController != null &&
                                _cameraController!.value.isInitialized
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio:
                                      _cameraController!.value.aspectRatio,
                                  child: CameraPreview(_cameraController!),
                                ),
                              )
                            : Center(child: CircularProgressIndicator())),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : pickImageFromGallery,
                  icon: Icon(Icons.image, color: Colors.black),
                  label: Text('Galeri'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[100],
                    minimumSize: Size(140, 40),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : takePictureAndPredict,
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
                        "📊 Akurasi: ${(_confidence! * 100).toStringAsFixed(2)}"),
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
