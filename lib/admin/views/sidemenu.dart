import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/views/handle_reports.dart';
import 'package:newifchaly/admin/views/manageusers.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: const Color(0xfffafafa),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
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
              color: const Color(0xff87e64c), // Green BG
              borderRadius: BorderRadius.circular(30),
            ),
            child: const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.black),
              title: Text(
                'Approve Tutors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xfffafafa),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.userTie, color: Colors.black),

                        title: const Text(
                          'Manage Users',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Manageusers()),
                          );
                        },
                      ),
                    ),
                      const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file, color: Colors.black),
                    title: const Text('Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HandleReports()),
                          );
                        },
                  ),
                ),
        ],
      ),
    );
  }
}
