import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _verificationCode = '';

  // Function applied
  Color _getButtonColor() {
    if (_verificationCode.isNotEmpty) {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Image.asset(
                'assets/ali.png', 
                height: 100,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              onChanged: (value) {
                setState(() {
                  _verificationCode = value; 
                });
              },
              decoration: InputDecoration(
                labelText: 'Verification Code',
                hintText: '0000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(), 
                minimumSize: const Size(400, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_verificationCode.isNotEmpty) {
                  print('Verification code entered: $_verificationCode');
                }
              },
              child: const Text(
                'Verify Email',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
