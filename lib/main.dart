import 'package:flutter/material.dart';
import 'package:plantfit/splashscreen.dart';
import 'package:plantfit/scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Halaman awal SplashScreen
      routes: {
        '/': (context) => SplashScreen(),
        '/scan': (context) => Scanner(), // Tambahkan rute ke halaman Scan
      },
    );
  }
}
