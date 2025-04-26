import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'package:newifchaly/student/views/bookings.dart';
import 'package:newifchaly/student/views/edit_studentprofile.dart';
import 'package:newifchaly/student/views/search_results.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';

class StudentProfileScreen extends StatefulWidget {
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
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
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        SupabaseService().logout();
                        Get.offAll(() => LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffe64b4b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              const  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                        
                      ),
                      
                      
                    ),
                  
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                      
                          Text(
                            'Aliyan Rizvi',
                            style: TextStyle(fontSize: 28, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Email address',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'aliyanrizvi123@gmail.com',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                children: [
                  buildProfileField('Education Level', '-'),
                  buildProfileField('City', '-'),
                  buildProfileField('Subjects I am weak at', '-'),
                  buildProfileField('Learning Goals', '-'),
                  const SizedBox(height: 3),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditStudentProfileScreen()),
  );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87E64B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 3,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildProfileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
