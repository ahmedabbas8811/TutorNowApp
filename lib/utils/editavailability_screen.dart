import 'package:flutter/material.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';

class EditAvailabilityScreen extends StatefulWidget {
  @override
  _EditAvailabilityScreenState createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  // Map to control switch states for each day
  final Map<String, bool> _availability = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': true,
  };

  // Time slots for each day
  final Map<String, List<TimeOfDay>> _timeSlots = {
    'Monday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
    'Tuesday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
    'Wednesday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
    'Thursday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
    'Friday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
    'Saturday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
    'Sunday': [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 0)],
  };

  int _selectedIndex = 1; // Set initial index to the Availability tab

  Future<void> _selectTime(BuildContext context, int slotIndex, String day) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _timeSlots[day]![slotIndex],
    );

    if (pickedTime != null) {
      setState(() {
        _timeSlots[day]![slotIndex] = pickedTime;
      });
    }
  }

 
  void _onItemTapped(int index) {
  if (_selectedIndex != index) {
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
            const SizedBox(height: 50),
            Text(
              'Edit Availability',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
             const SizedBox(height: 10),

            const Text(
              'Sessions that are already booked are not affected by changing availability',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 0),
            Expanded(
              child: ListView.builder(
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  String day = _days[index];
                  bool isAvailable = _availability[day]!;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Day Name
                          Expanded(
                            flex: 2,
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isAvailable ? FontWeight.bold : FontWeight.normal,
                                color: isAvailable ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                          // Switch
                          Switch(
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
                        ],
                      ),
                      // Time Slots
                      Row(
                        children: [
                          GestureDetector(
                            onTap: isAvailable ? () => _selectTime(context, 0, day) : null,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: isAvailable ? Colors.black : Colors.grey), // Set border color based on availability
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white, // Keep container white
                              ),
                              child: Text(
                                _timeSlots[day]![0].format(context),
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable ? Colors.black : Colors.grey, // Change text color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('-'),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: isAvailable ? () => _selectTime(context, 1, day) : null,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: isAvailable ? Colors.black : Colors.grey), // Set border color based on availability
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white, // Keep container white
                              ),
                              child: Text(
                                _timeSlots[day]![1].format(context),
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable ? Colors.black : Colors.grey, // Change text color
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
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
