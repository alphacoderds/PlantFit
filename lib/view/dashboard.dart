import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/register.dart';
import 'package:plantfit/view/daftarjenis.dart';
import 'package:plantfit/view/scan.dart';
import 'package:plantfit/view/riwayat.dart';
import 'package:plantfit/view/profile.dart';
import 'package:plantfit/view/homepage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF5E3),
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
              'Dashboard',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid Kategori Tanah
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  List<String> titles = [
                    'Regosol',
                    'Laterit',
                    'Aluvial',
                    'Grumosol',
                    'Vertisol'
                  ];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.landscape, size: 50, color: Colors.green),
                          SizedBox(height: 5),
                          Text(
                            titles[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Artikel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.article,
                              size: 50, color: Colors.green),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Judul Artikel $index',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Deskripsi singkat artikel ini...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}