import 'package:flutter/material.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';

class AddNewPackagesScreen extends StatefulWidget {
  @override
  _AddNewPackagesScreenState createState() => _AddNewPackagesScreenState();
}

class _AddNewPackagesScreenState extends State<AddNewPackagesScreen> {
  int _selectedIndex = 3;

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
      
      body: const Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),
              Text(
                'Add New Package',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Package Name
              Text('Package Name', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Basic Package',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Package Description
              Text('Package Description', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: '',
                  hintText: 'Tell students why they should purchase this package\nAdd key features of your sessions',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Duration of Each Session
              Text('Duration Of Each Session', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Hours',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Session Per Week
              Text('Session Per Week', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '5',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Number of Weeks
              Text('Number of Weeks', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '4',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Price
              Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '10,000',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Save button at the bottom
          Padding(
            
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            
            child: ElevatedButton(
              
              onPressed: () {
                // Handle save action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff87e64c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
              ),
              child:const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          // Bottom Navigation Bar
          BottomNavigationBar(
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
        ],
      ),
    );
  }
}
