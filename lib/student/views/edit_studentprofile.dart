

import 'package:flutter/material.dart';
import 'package:newifchaly/student/views/bookings.dart';
import 'package:newifchaly/student/views/search_results.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';
// Import your bottom navigation bar file and screens
// import 'your_custom_bottom_navigation_bar.dart';
// import 'student_home_screen.dart';
// import 'search_results.dart';
// import 'bookings_screen.dart';

class EditStudentProfileScreen extends StatefulWidget {
  @override
  _EditStudentProfileScreenState createState() => _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState extends State<EditStudentProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: "Aliyan Rizvi");
  final TextEditingController cityController = TextEditingController(text: "Rawalpindi");
  final TextEditingController emailController = TextEditingController(text: "aliyanrizvi@gmail.com");
  final TextEditingController educationController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomeScreen()));
          break;
        case 1:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchResults()));
          break;
        case 2:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingsScreen()));
          break;
        case 3:
          // Already on profile screen
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  Positioned(
                    top: 120,
                    bottom: -10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit, color: Colors.green, size: 20),
                            onPressed: () {
                              // Change profile image
                            },
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () {
                              // Delete profile image
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: buildTextField("Full Name", "Enter your full name", nameController)),
                const SizedBox(width: 10),
                Expanded(child: buildTextField("City", "Enter your city", cityController)),
              ],
            ),
            const SizedBox(height: 20),
            buildTextField("Email", "Enter your email", emailController, readOnly: true),
            const SizedBox(height: 20),
            buildTextField("Education Level", "Enter your education level", educationController),
            const SizedBox(height: 20),
            buildTextField("Subjects I am weak at", "Enter subjects", subjectsController),
            const SizedBox(height: 20),
            buildTextField("Learning Goals", "Enter your goals", goalsController),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Save logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
