import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantfit/view/editprofile.dart';
import 'package:plantfit/view/login.dart';
import 'package:plantfit/view/tentangKami.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Ini data user
  String nama = "Putri";
  String phoneNumber = "+62 812-xxxx-xxx";
  String gender = "Women";
  String location = "Madiun";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF5E3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/plantfit.png', height: 50),
            const SizedBox(width: 10),
            Text(
              'Profile',
              style: GoogleFonts.lora(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF3E6606),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF3E6606),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3E6606),
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
                  const SizedBox(height: 10),
                  ProfileDetail(title: 'Nama', value: nama),
                  ProfileDetail(title: 'Phone Number', value: phoneNumber),
                  ProfileDetail(title: 'Gender', value: gender),
                  ProfileDetail(title: 'Location', value: location),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E6606),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 8),
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
            const SizedBox(height: 20),
            ProfileButton(
              text: 'Edit Profile',
              onPressed: () async {
                // Pergi ke EditProfilePage dan tunggu hasilnya
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      firstNameController: TextEditingController(text: nama),
                      lastNameController: TextEditingController(),
                      phoneNumberController: TextEditingController(text: phoneNumber),
                      genderController: TextEditingController(text: gender),
                      locationController: TextEditingController(text: location),
                    ),
                  ),
                );

                // Kalau ada data dikembalikan
                if (result != null) {
                  setState(() {
                    nama = result['firstName']; // Sesuaikan key dari EditProfilePage
                    phoneNumber = result['phone'];
                    gender = result['gender'];
                    location = result['location'];
                  });

                  // Option: munculkan SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile berhasil diperbarui!')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
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
      padding: const EdgeInsets.only(bottom: 8),
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
          const SizedBox(height: 5),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
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
