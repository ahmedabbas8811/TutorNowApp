import 'package:flutter/material.dart';

class EditStudentProfileScreen extends StatefulWidget {
  @override
  _EditStudentProfileScreenState createState() => _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState extends State<EditStudentProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: "Aliyan Rizvi");
  final TextEditingController emailController = TextEditingController(text: "aliyanrizvi123@gmail.com");
  final TextEditingController educationController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.lightGreenAccent.shade400,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            buildTextField("Name", nameController),
            buildTextField("Email", emailController),
            buildTextField("Education Level", educationController),
            buildTextField("City", cityController),
            buildTextField("Subjects I am weak at", subjectsController),
            buildTextField("Learning Goals", goalsController),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Save logic here
                  Navigator.pop(context); // back to profile screen after saving
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
