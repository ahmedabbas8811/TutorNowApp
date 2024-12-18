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
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final Map<String, bool> _availability = {
    for (var day in [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ])
      day: true,
  };

  final Map<String, List<List<TimeOfDay>>> _timeSlots = {
    for (var day in [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ])
      day: [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)],
      ],
  };

  int _selectedIndex = 1;

  Future<void> _selectTime(BuildContext context, String day, int slotIndex, int timeIndex) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _timeSlots[day]![slotIndex][timeIndex],
    );

    if (pickedTime != null) {
      setState(() {
        _timeSlots[day]![slotIndex][timeIndex] = pickedTime;
      });
    }
  }

  void _addTimeSlot(String day) {
    setState(() {
      _timeSlots[day]!.add([TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AvailabilityScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => SessionsScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => EarningsScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonScreen()));
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
            const SizedBox(height: 50),
            const Text(
              'Edit Availability',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  String day = _days[index];
                  bool isAvailable = _availability[day]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isAvailable ? Colors.black : Colors.grey,
                            ),
                          ),
                          Switch(
                            value: isAvailable,
                            activeColor: Colors.black,
                            activeTrackColor: const Color(0xff87e64c),
                            onChanged: (value) {
                              setState(() {
                                _availability[day] = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(_timeSlots[day]!.length, (slotIndex) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: isAvailable
                                        ? () => _selectTime(context, day, slotIndex, 0)
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: isAvailable ? Colors.black : Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _timeSlots[day]![slotIndex][0].format(context),
                                        style: TextStyle(color: isAvailable ? Colors.black : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('-'),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: isAvailable
                                        ? () => _selectTime(context, day, slotIndex, 1)
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: isAvailable ? Colors.black : Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _timeSlots[day]![slotIndex][1].format(context),
                                        style: TextStyle(color: isAvailable ? Colors.black : Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: isAvailable ? () => _addTimeSlot(day) : null,
                          child: Text(
                            'Add Availability +',
                            style: TextStyle(
                              color: isAvailable ? Colors.black : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Updated Availability: $_availability");
                  print("Updated Time Slots: $_timeSlots");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
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