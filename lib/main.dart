import 'package:flutter/material.dart';
import 'package:plantfit/view/login/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantfit/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantfit/view/login/login.dart';
import 'package:plantfit/view/dashboard/homepage.dart';
import 'package:plantfit/view/profile/editprofile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // label aplikasi 
      debugShowCheckedModeBanner: false,
      title: 'PlantFit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => Navbar(),
        '/profile': (context) => EditProfilePage(
              nameController: TextEditingController(),
              phoneNumberController: TextEditingController(),
              genderController: TextEditingController(),
              locationController: TextEditingController(),
            ),
      },
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // cek status login
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // masih menunggu hasil
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.emailVerified) {
          // user sudah login dan email terverifikasi
          return Navbar();
        } else {
          // belum login atau email belum verifikasi
          return const LoginPage();
        }
      },
    );
  }
}
