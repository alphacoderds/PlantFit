import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController genderController;
  final TextEditingController locationController;

  EditProfilePage({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    required this.genderController,
    required this.locationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E6),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF3E6606),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E6606)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF3E6606),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            buildTextField("First Name", firstNameController),
            buildTextField("Last Name", lastNameController),
            buildTextField("Phone Number", phoneNumberController),
            buildTextField("Gender", genderController),
            buildTextField("Location", locationController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Map<String, String> updatedProfile = {
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                  'phone': phoneNumberController.text,
                  'gender': genderController.text,
                  'location': locationController.text,
                };
                Navigator.pop(context, updatedProfile);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}