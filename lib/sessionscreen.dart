import 'package:flutter/material.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:get/get.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:newifchaly/views/booking_request_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget screen;
    switch (index) {
      case 0:
        screen = ProfileScreen();
        break;
      case 1:
        screen = AvailabilityScreen();
        break;
      case 2:
        screen = SessionScreen();
        break;
      case 3:
        screen = EarningsScreen();
        break;
      case 4:
        screen = PersonScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              const Text('My Bookings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              buildSection('Booking Requests', Colors.orange),
              const SizedBox(height: 24),
              buildSection('Active Bookings', Colors.green),
            ],
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available), label: 'Availability'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildSection(String title, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Tap to see details',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to the new screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingRequestScreen(), 
                    ),
                  );
                },
                child: SwipeableSessionCard(
                  name: 'Shehdad Ali',
                  package: 'Package Name',
                  time: '90 Min / Session',
                  frequency: '3X / Week',
                  duration: '8 Weeks',
                  price: '5000/- PKR',
                  statusColor: statusColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to the new screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingRequestScreen(), 
                    ),
                  );
                },
                child: SwipeableSessionCard(
                  name: 'John Doe',
                  package: 'Another Package',
                  time: '60 Min / Session',
                  frequency: '2X / Week',
                  duration: '6 Weeks',
                  price: '4000/- PKR',
                  statusColor: statusColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SwipeableSessionCard extends StatelessWidget {
  final String name;
  final String package;
  final String time;
  final String frequency;
  final String duration;
  final String price;
  final Color statusColor;

  const SwipeableSessionCard({
    required this.name,
    required this.package,
    required this.time,
    required this.frequency,
    required this.duration,
    required this.price,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin:const  EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color(0xfff7f7f7), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1), 
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0, 
        color: Colors.transparent, 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                const   CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/Ellipse1.png'),
                  ),
                const  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(package,
                            style:const  TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                  CircleAvatar(radius: 4, backgroundColor: statusColor),
                ],
              ),
           const   SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [const Icon(Icons.timer, size: 18), const SizedBox(width: 4), Text(time)]),
                  Row(
                      children: [const Icon(Icons.refresh, size: 18), const SizedBox(width: 4), Text(frequency)]),
                ],
              ),
             const  SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [const Icon(Icons.calendar_today, size: 18), const SizedBox(width: 4), Text(duration)]),
                  Row(
                      children: [const Icon(Icons.attach_money, size: 18), const SizedBox(width: 4), Text(price)]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
