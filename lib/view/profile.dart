import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/editprofile.dart';
import 'package:plantfit/view/login.dart';
import 'package:plantfit/view/tentangKami.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/plantfit.png', height: 50),
            SizedBox(width: 10),
            Text(
              'Profile',
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF3E6606),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF3E6606),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ProfileDetail(title: 'Nama', value: 'Putri'),
                  ProfileDetail(
                      title: 'Phone Number', value: '+62 812-xxxx-xxx'),
                  ProfileDetail(title: 'Gender', value: 'Women'),
                  ProfileDetail(title: 'Location', value: 'Madiun'),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF3E6606),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Tentang kami',
                      style: GoogleFonts.lora(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ProfileButton(
              text: 'Edit Profile',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            SizedBox(height: 10),
            ProfileButton(
              text: 'Logout',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetail({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lora(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ProfileButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
