// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<String?> uploadImageAndGetUrl() async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: ImageSource.camera);

//   if (pickedFile == null) return null;

//   File imageFile = File(pickedFile.path);
//   String fileName = DateTime.now().millisecondsSinceEpoch.toString();

//   // Simpan ke path unik per user
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   Reference storageRef = FirebaseStorage.instance
//       .ref()
//       .child("users/$userId/images/$fileName.jpg");

//   UploadTask uploadTask = storageRef.putFile(imageFile);
//   TaskSnapshot snapshot = await uploadTask;

//   // Ambil URL download
//   String downloadUrl = await snapshot.ref.getDownloadURL();
//   return downloadUrl;
// }
