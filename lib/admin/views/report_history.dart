import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/admin/views/manageusers.dart';

class ReportHistory extends StatelessWidget {
  const ReportHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: Row(
        children: [
          // Sidebar 
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Image.asset('assets/ali.png', width: 50, height: 50),
                const SizedBox(height: 15),
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
                          spreadRadius: 1),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text('Home',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const HomeAdmin()));
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
                    leading:
                        const Icon(Icons.check_circle, color: Colors.black),
                    title: const Text('Approve Tutors',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApproveTutorsScreen()));
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
                    leading: const Icon(FontAwesomeIcons.userTie,
                        color: Colors.black),
                    title: const Text('Manage Users',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Manageusers()));
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xff87e64c),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file, color: Colors.black),
                    title: const Text('Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}