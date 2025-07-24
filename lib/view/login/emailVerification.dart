import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantfit/view/profile/editprofile.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isResending = false;
  Timer? _checkEmailTimer;

  @override
  void initState() {
    super.initState();

    // Cek email setiap 3 detik
    _checkEmailTimer = Timer.periodic(Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      var user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        _checkEmailTimer?.cancel();

        if (!mounted) return;

        // Tampilkan SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verifikasi berhasil! Silakan lengkapi profil.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi ke halaman EditProfile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EditProfilePage(
              nameController: TextEditingController(),
              phoneNumberController: TextEditingController(),
              genderController: TextEditingController(),
              locationController: TextEditingController(),
              isFromSignup: true,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _checkEmailTimer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isResending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email verifikasi telah dikirim ulang.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim ulang email: $e')),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5FBEF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/emailVerification.png',
                height: screenHeight * 0.3,
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                "Email Verification",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Tautan verifikasi telah dikirim ke email Anda.\nKlik tautan tersebut untuk melanjutkan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              GestureDetector(
                onTap: _isResending ? null : _resendVerificationEmail,
                child: Text(
                  _isResending
                      ? "Mengirim ulang..."
                      : "Belum menerima email? Kirim ulang verifikasi",
                  style: TextStyle(
                    color: Color(0xFF4D6A3F),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF4D6A3F)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A3F),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
