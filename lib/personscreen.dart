import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/editprofile_screen.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'earningscreen.dart';

class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  int _selectedIndex = 4; // Profile tab selected by default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate screen based on the index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with actual HomeScreen widget
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvailabilityScreen()), // Replace with actual AvailabilityScreen widget
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionsScreen()), // Replace with actual SessionsScreen widget
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EarningsScreen()), // Your existing EarningsScreen widget
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonScreen()), // Profile screen (current screen)
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: ElevatedButton(
              onPressed: () {
                Get.find<SupabaseService>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe64b4b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/Ellipse 1.png'),
              ),
              const SizedBox(height: 10),
              // Profile Name
              const Text(
                'Aliyan Rizvi',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5), // Reduced space
              // Profile Incomplete Tag
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4), // Inner padding
                color: Colors.yellow,
                child: const Text(
                  '⚠ Profile is incomplete',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Edit Profile Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()), // Action for Edit Profile
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff87e64c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed type ensures white background
          backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff87e64c),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_front),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PersonScreen(),
  ));
}
