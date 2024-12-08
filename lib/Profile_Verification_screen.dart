import 'package:flutter/material.dart';
import 'package:newifchaly/availabilityscreen.dart';

import 'package:newifchaly/profile_screen.dart';


class ProfileVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/ali.png', // Replace with your actual logo asset path
          width: 50,
          height: 50,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 140),

              // Checkmark inside a black square box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_rounded, // Green checkmark icon
                    size: 40,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Message Text
              const Text(
                "Your profile is submitted for verification!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                "Next step, set your availability!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Button with specified width
              SizedBox(
                width: 285,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailabilityScreen() ,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff87e64c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Set Availability',
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
