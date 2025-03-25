import 'package:flutter/material.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo Image
                Image.asset(
                  'assets/ali.png', // Make sure this image exists
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                // Home Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color:const Color(0xff87e64c),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                 
                  ),
                ),
                const SizedBox(height: 10),
                // Approve Tutors Button (Highlighted)
              Container(
  margin: const EdgeInsets.symmetric(horizontal: 3),
  padding: const EdgeInsets.symmetric(vertical: 3),
  decoration: BoxDecoration(
    color: const Color(0xfffafafa), // Green BG
    borderRadius: BorderRadius.circular(30),
  ),
  child: ListTile(
    leading: const Icon(Icons.home, color: Colors.black),
    title: const Text(
      'Approve Tutors',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ApproveTutorsScreen()),
      );
    },
  ),
),


              ],
            ),
          ),
        ],
      ),
      
    );
  }
}
