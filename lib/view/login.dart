import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:plantfit/view/register.dart';
import 'package:plantfit/view/dashboard.dart';
import 'package:plantfit/view/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, $email!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: GoogleFonts.lora(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.05,
            color: Color(0xFF3E6606),
          ),
        ),
        backgroundColor: const Color(0xFFF5FBEF),
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFF5FBEF),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/plantfit.png',
                  height: screenHeight * 0.15,
                  width: screenHeight * 0.15,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -50),
                  child: Image.asset(
                    'assets/images/scan.png',
                    height: screenHeight * 0.3,
                    width: screenHeight * 0.3,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -80), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF4D6A3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color(0xFF4D6A3F)), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
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
