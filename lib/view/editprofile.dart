import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController firstNameController =
      TextEditingController(text: "Putri");
  final TextEditingController lastNameController =
      TextEditingController(text: "Radisa");
  final TextEditingController phoneNumberController =
      TextEditingController(text: "xxxx");
  final TextEditingController genderController =
      TextEditingController(text: "Woman");
  final TextEditingController locationController =
      TextEditingController(text: "Madiun");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F4E6),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF3E6606),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3E6606)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF3E6606),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            buildTextField("First Name", firstNameController),
            buildTextField("Last Name", lastNameController),
            buildTextField("Phone Number", phoneNumberController),
            buildTextField("Gender", genderController),
            buildTextField("Location", locationController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
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
