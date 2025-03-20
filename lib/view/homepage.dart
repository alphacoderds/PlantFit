import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantfit/view/daftarjenis.dart';
import 'package:plantfit/view/dashboard.dart';
import 'package:plantfit/view/profile.dart';
import 'package:plantfit/view/riwayat.dart';
import 'package:plantfit/view/scan.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    DashboardPage(),
    DaftarJenisPage(),
    ScannerPage(),
    RiwayatPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    print('Navigasi ke index: $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightGreen[200],
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            if (index == 2) return const SizedBox(width: 20); // Ruang untuk FAB
            return Expanded(
              child: buildNavBarItem(
                [
                  CupertinoIcons.home,
                  CupertinoIcons.list_bullet,
                  CupertinoIcons.camera_viewfinder,
                  CupertinoIcons.clock,
                  CupertinoIcons.person
                ][index],
                ['Beranda', 'Jenis', '', 'Riwayat', 'Profil'][index],
                index,
              ),
            );
          }),
        ),
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: Colors.green[900],
          elevation: 10,
          child: InkWell(
            onTap: () => _onItemTapped(2), // Pindah ke halaman Scanner
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                CupertinoIcons.camera_viewfinder,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.green[900] : Colors.black87,
          ),
          Text(
            label,
            style: TextStyle(
              color:
                  _selectedIndex == index ? Colors.green[900] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
