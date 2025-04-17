import 'package:flutter/material.dart';
import 'package:plantfit/view/splashscreen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantFit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), 
    );
  }
}
