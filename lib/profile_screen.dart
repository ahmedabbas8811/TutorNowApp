import 'package:flutter/material.dart';
import 'location_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0; // Track the selected index for BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsiveness
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            SizedBox(height: screenHeight * 0.05), // Space at the top

            // Row for Logo and Message Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/ali.png',
                  height: screenHeight * 0.05, // Responsive height for logo
                ),
                IconButton(
                  icon: const Icon(Icons.message_outlined, color: Colors.black),
                  onPressed: () {
                    // Handle message icon press
                  },
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02), // Space below logo row

            const Text(
              'Hello Bilal',
              style: TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0), // Space below greeting text

            const Text(
              'Upcoming Bookings',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // Space below upcoming bookings text

            // Upcoming Bookings Box
            Container(
              width: screenWidth,
              height: screenHeight * 0.15, // Responsive height for bookings box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Your upcoming sessions will be shown\nhere, once booked',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.1), 

            // Incomplete Profile Warning
            const Text(
              'Your profile is not complete; incomplete profiles are not visible to students',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: screenHeight * 0.03), 

            // Complete Profile Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to LocationScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Complete Profile',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),

           const Spacer(), 
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff87e64c),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
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
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}