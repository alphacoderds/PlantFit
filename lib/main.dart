import 'package:flutter/material.dart';
import 'package:plantfit/view/daftarjenis.dart';
import 'package:plantfit/view/scan.dart';
import 'package:plantfit/view/login.dart';
import 'package:plantfit/view/splashscreen.dart';
import 'package:plantfit/view/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DaftarJenisTanahPage(),
    );
  }
}