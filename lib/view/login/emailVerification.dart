import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isResending = false;

  Future<void> _resendVerificationEmail() async {
    setState(() => _isResending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email has been resent.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend email: $e')),
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
                'assets/images/emailVerification.png', // Ganti dengan path gambar kamu
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
                "A verification link has been sent to your email.\nPlease click the link to complete your registration.",
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
                      ? "Resending..."
                      : "Didn't receive the email? Resend Email",
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
                  onPressed: () {
                    Navigator.pop(context); // kembali ke halaman sebelumnya
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF4D6A3F)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'BACK',
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
