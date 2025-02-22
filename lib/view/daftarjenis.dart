import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/scan.dart';
import 'package:plantfit/view/register.dart';
import 'package:plantfit/view/login.dart';
import 'package:plantfit/view/dashboard.dart';
import 'package:plantfit/view/riwayat.dart';

class DaftarJenisTanahPage extends StatefulWidget {
  const DaftarJenisTanahPage({super.key});

  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DaftarJenisTanahPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    DaftarJenisTanahPage(), // Ganti dengan halaman daftar jenis tanah
    ScannerPage(),
    RegisterPage(), // Contoh saja, bisa disesuaikan
    LoginPage(), // Contoh saja, bisa disesuaikan
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/plantfit.png',
              height: 70,
            ),
            SizedBox(width: 7),
            Text(
              'Daftar Jenis Tanah',
              style: GoogleFonts.lora(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.05,
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
            SizedBox(height: 10),

            // List Artikel
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Bisa ditambah sesuai jumlah artikel
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[200],
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
                          height: 120,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.image, size: 50),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 10,
                                color: Colors.green[900],
                                margin: EdgeInsets.symmetric(vertical: 2),
                              ),
                              Container(
                                height: 10,
                                color: Colors.green[900],
                                margin: EdgeInsets.symmetric(vertical: 2),
                              ),
                              Container(
                                height: 10,
                                color: Colors.green[900],
                                margin: EdgeInsets.symmetric(vertical: 2),
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightGreen[200],
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.black54,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Jenis",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Deteksi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Riwayat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
