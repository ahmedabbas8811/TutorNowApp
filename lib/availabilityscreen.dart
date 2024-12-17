import 'package:flutter/material.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';

import 'package:newifchaly/utils/editavailability_screen.dart'; 

class AvailabilityScreen extends StatefulWidget {
  @override
  _AvailabilityScreenState createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  int _selectedIndex = 1; // Set default index to "Availability"

  // Track the switch states for each day
  final Map<String, bool> _availability = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': false,
  };

  // Corresponding time slots for each day
  final Map<String, String> _timeSlots = {
    'Monday': '08:00 - 12:00',
    'Tuesday': '12:00 - 16:00',
    'Wednesday': '16:00 - 20:00',
    'Thursday': '20:00 - 00:00',
    'Friday': '00:00 - 04:00',
    'Saturday': '04:00 - 08:00',
    'Sunday': '08:00 - 12:00',
  };

  // Handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to a new page based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvailabilityScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionsScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EarningsScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Adjusted spacing here
            const Text(
              'Set Availability',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4), // Less space between texts
            const Text(
              'Sessions that are already booked are not affected by changing availability',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4), // Less space before "Edit Schedule"
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Navigate to EditAvailabilityScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAvailabilityScreen()),
                  );
                },
                child: const Text(
                  'Edit Schedule',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _availability.length,
                itemBuilder: (context, index) {
                  String day = _availability.keys.elementAt(index);
                  bool isAvailable = _availability[day]!;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 3.0),
                    title: Text(
                      day,
                      style: TextStyle(
                        fontWeight:
                            isAvailable ? FontWeight.bold : FontWeight.normal,
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      _timeSlots[day]!,
                      style: TextStyle(
                        fontWeight:
                            isAvailable ? FontWeight.bold : FontWeight.normal,
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                    trailing: Switch(
                      value: isAvailable,
                      activeColor: Colors.black,
                      activeTrackColor: const Color(0xff87e64c),
                      inactiveThumbColor: Colors.grey,
                      onChanged: (bool value) {
                        setState(() {
                          _availability[day] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
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