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
import 'package:plantfit/services/firebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plantfit/view/scan/offlineQueue.dart';

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

  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isUploading = false;
  bool _hasDetected = false;
  bool _hasSavedResult = false;

  // Hasil prediksi
  String? _label,
      _latinName,
      _description,
      _handling,
      _kandungan,
      _rekomendasiTanaman;
  double? _confidence;
  String? _lastImagePath;

  late DataTanah _dataTanah;

  @override
  void initState() {
    super.initState();
    _dataTanah = DataTanah();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
      loadModel();
      _syncOfflineData();
    });
  }

  void _resetDetectionState() {
    setState(() {
      _label = null;
      _latinName = null;
      _confidence = null;
      _description = null;
      _handling = null;
      _lastImagePath = null;
    });
  }

  void _showUnrecognizedDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Mencegah pengguna menutup dialog dengan mengetuk luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Gambar Tidak Dikenali",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E6606),
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
                  _hasDetected = false; // Mengatur ulang status deteksi});
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

  Future<String> _cropAndResizeTo192(String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Gagal decode image");

    // Crop ke square
    int cropSize = image.width < image.height ? image.width : image.height;
    int offsetX = (image.width - cropSize) ~/ 2;
    int offsetY = (image.height - cropSize) ~/ 2;
    img.Image cropped = img.copyCrop(
      image,
      x: offsetX,
      y: offsetY,
      width: cropSize,
      height: cropSize,
    );

    // Resize ke 192x192
    img.Image resized = img.copyResize(cropped, width: 192, height: 192);

    // Simpan hasil
    final resizedPath = path.replaceAll(RegExp(r'\.\w+$'), '_resized.jpg');
    await File(resizedPath).writeAsBytes(img.encodeJpg(resized));
    return resizedPath;
  }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: 'assets/model/my_newmodel6class140725_9444.tflite',
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
      final resizedPath = await _cropAndResizeTo192(imagePath);
      final List<dynamic>? dynamicResults = await Tflite.runModelOnImage(
        path: resizedPath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 1,
        threshold: 0.4,
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

      if (label.toLowerCase() == 'nontanah') {
        print("Deteksi: Gambar bukan tanah");
        return null;
      }

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

  Future<void> _detectImage(File image) async {
    final result = await predictUsingTFLite(image.path);

    if (result == null || result.confidence < 0.4) {
      _showUnrecognizedDialog();
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await saveDetectionResultWithImage(userId, result);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilDeteksiPage(
          label: result.label,
          latinName: result.latinName,
          confidence: result.confidence,
          imagePath: result.imagePath,
          rekomendasiTanaman: result.rekomendasiTanaman,
        ),
      ),
    );
  }

  Future<void> saveDetectionResultWithImage(
      String userId, Result result) async {
    if (_isUploading || _hasSavedResult) {
      print("Skip saving: already uploading or saved.");
      return;
    }

    _isUploading = true;
    _hasSavedResult =
        true; // Pindah flag ini jadi true duluan supaya dipanggil kedua kali langsung skip

    final detectionData = {
      "userId": userId,
      "hasil": result.label,
      "confidence": result.confidence,
      "imagePath": result.imagePath,
      "timestamp": DateTime.now().toIso8601String()
    };

    try {
      final imageFile = File(result.imagePath);
      String imageUrl = result.imagePath;

      if (await isConnected()) {
        imageUrl = await FirebaseService.uploadDetectionResult(
          userId: userId,
          hasil: result.label,
          confidence: result.confidence,
          imageFile: imageFile,
        );

        // Jika upload gagal dan URL kosong, fallback ke path lokal
        if (imageUrl.isEmpty) {
          print("⚠️ Upload gagal, gunakan path lokal.");
          imageUrl = result.imagePath;
        }
      } else {
        await OfflineQueue.addToQueue(detectionData);
        print("Tidak ada koneksi. Disimpan ke antrean offline.");
      }

      final detectionItem = RiwayatItem(
        label: result.label,
        latinName: result.latinName,
        confidence: result.confidence,
        description: result.description,
        handling: result.handling,
        imagePath: imageUrl,
        kandungan: result.kandungan,
        rekomendasiTanaman: result.rekomendasiTanaman,
        timestamp: DateTime.now(),
      );
      RiwayatStorage.addRiwayat(detectionItem);
    } catch (e) {
      print("Error saat simpan hasil deteksi: $e");
      _hasSavedResult = false; // Reset kalau gagal agar bisa coba lagi
    } finally {
      _isUploading = false;
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _syncOfflineData() async {
    if (await isConnected()) {
      final queue = await OfflineQueue.getQueue();
      if (queue.isNotEmpty) {
        for (final item in queue) {
          try {
            final file = File(item['imagePath']);
            await FirebaseService.uploadDetectionResult(
              userId: item['userId'],
              hasil: item['hasil'],
              confidence: item['confidence'],
              imageFile: file,
            );
          } catch (e) {
            print("Gagal upload data dari antrean offline: $e");
          }
        }
        await OfflineQueue.clearQueue();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data offline berhasil disinkronkan.")),
          );
        }
      }
    }
  }

  Future<void> takePictureAndPredict() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kamera belum siap")),
      );
      return;
    }

    if (_isProcessing || _hasDetected) return; // Cegah multiple scan
    _hasSavedResult = false; // Reset flag

    setState(() {
      _isProcessing = true;
      _hasDetected = true;
      _label = null;
      _latinName = null;
      _confidence = null;
      _description = null;
      _handling = null;
      _lastImagePath = null;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      setState(() => _lastImagePath = image.path);

      final result = await predictUsingTFLite(image.path);

      if (result != null && result.confidence >= 0.4) {
        setState(() {
          _label = result.label;
          _latinName = result.latinName;
          _confidence = result.confidence;
          _description = result.description;
          _handling = result.handling;
        });

        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null && !_hasSavedResult) {
          await saveDetectionResultWithImage(userId, result);
          _hasSavedResult = true; // Tandai sudah disimpan
        }

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HasilDeteksiPage(
              label: result.label,
              latinName: result.latinName,
              confidence: result.confidence,
              imagePath: result.imagePath,
              rekomendasiTanaman: result.rekomendasiTanaman,
            ),
          ),
        );

        setState(() {
          _label = null;
          _latinName = null;
          _confidence = null;
          _description = null;
          _handling = null;
          _lastImagePath = null;
          _hasDetected = false; // Reset deteksi aktif
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

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _isProcessing = true; // Mulai loading setelah user pilih gambar
          _hasSavedResult = false;
          _lastImagePath = image.path;
        });

        final result = await predictUsingTFLite(image.path);

        if (result != null && result.confidence >= 0.4) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null && !_hasSavedResult) {
            await saveDetectionResultWithImage(userId, result);
            _hasSavedResult = true;
          }

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HasilDeteksiPage(
                label: result.label,
                latinName: result.latinName,
                confidence: result.confidence,
                imagePath: result.imagePath,
                rekomendasiTanaman: result.rekomendasiTanaman,
              ),
            ),
          );

          setState(() {
            _label = null;
            _latinName = null;
            _confidence = null;
            _description = null;
            _handling = null;
            _lastImagePath = null;
          });
        } else {
          _showUnrecognizedDialog();
        }
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
                      "Pastikan kondisi sample tanah normal dan gambar jelas dengan pencahayaan baik dan latar belakang sederhana. "
                      "Aplikasi akan memproses dan menampilkan hasil jenis tanah secara otomatis setelah melakukan klik deteksi.",
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Sedang memproses deteksi...",
                            style: GoogleFonts.lora(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      )
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
