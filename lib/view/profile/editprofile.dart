import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController genderController;
  final TextEditingController locationController;

  const EditProfilePage({
    Key? key,
    required this.nameController,
    required this.phoneNumberController,
    required this.genderController,
    required this.locationController,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final List<String> genderOptions = ['Laki-laki', 'Perempuan'];
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // Sinkronkan dropdown dengan controller jika sudah ada nilai
    selectedGender = genderOptions.contains(widget.genderController.text)
        ? widget.genderController.text
        : null;
  }

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
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF3E6606),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            buildTextField("Name", widget.nameController),
            buildTextField("Phone Number", widget.phoneNumberController),
            buildGenderDropdown(),
            buildTextField("Location", widget.locationController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId == null) return;

                // Set nilai ke controller sebelum disimpan
                widget.genderController.text = selectedGender ?? '';

                final updatedProfile = {
                  'name': widget.nameController.text,
                  'phone': widget.phoneNumberController.text,
                  'gender': widget.genderController.text,
                  'location': widget.locationController.text,
                };

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .set(updatedProfile, SetOptions(merge: true));

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

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
