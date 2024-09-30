import 'package:flutter/material.dart';
import 'verification_screen.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  String _fullName = '';
  String _email = '';
  String _password = '';

  // Function to get the color for input field labels
  Color _getLabelColor(String text) {
    if (text.isNotEmpty) {
      return Colors.black;
    } else {
      return const Color.fromARGB(255, 192, 161, 161);
    }
  }

  // Function to change the Register button color when fields are filled
  Color _getButtonColor() {
    if (_fullName.isNotEmpty && _email.isNotEmpty && _password.isNotEmpty) {
      return const Color(0xff87e64c);
    } else {
      return const Color(0xffc3f3a5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/ali.png', // You can replace with your image path
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Register As A Tutor',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            // Name Field
            TextField(
              onChanged: (value) {
                setState(() {
                  _fullName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Your Full Name',
                labelStyle: TextStyle(color: _getLabelColor(_fullName)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Email Field
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'youremail@gmail.com',
                labelStyle: TextStyle(color: _getLabelColor(_email)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Password Field
            TextField(
              obscureText: !_isPasswordVisible,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Choose A Strong Password',
                labelStyle: TextStyle(color: _getLabelColor(_password)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Password Guidelines
            const Text(
              'At least 8 characters\nAt least one uppercase letter\nAt least one number\nAt least one special character',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Register Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(),
                minimumSize: const Size(400, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_fullName.isNotEmpty && _email.isNotEmpty && _password.isNotEmpty) {
                  // Navigate to Verification Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationScreen()), // Navigate to the new screen
                  );
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
