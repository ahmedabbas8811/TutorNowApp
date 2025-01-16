import 'package:flutter/material.dart';
import 'package:newifchaly/student/views/search_results.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'package:newifchaly/student/views/student_profile.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomeScreen(),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResults(),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingsScreen(),
            ),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfileScreen(),
            ),
          );
          break;
      }
    }
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
              const SizedBox(height: 25),
              // Pending Bookings
              const Text(
                'Pending Bookings',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Your booking request has been sent to the tutor. Please wait for their confirmation!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 220,
                child: SwipeCardExample(
                  cards: const [
                    {
                      "name": "John Doe",
                      "package": "Pending Package",
                      "time": "45 Min / Session",
                      "frequency": "2X / Week",
                      "duration": "6 Weeks",
                      "price": "3000/- PKR",
                      "rating": "4.0",
                    },
                    {
                      "name": "Jane Smith",
                      "package": "Pending Package",
                      "time": "60 Min / Session",
                      "frequency": "3X / Week",
                      "duration": "8 Weeks",
                      "price": "4000/- PKR",
                      "rating": "4.3",
                    },
                  ],
                ),
              ),
             
              // Active Bookings
              const Text(
                'Active Bookings',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Tap the booking card for more options!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 220,
                child: SwipeCardExample(
                  cards: const [
                    {
                      "name": "Ali Raza",
                      "package": "Active Package",
                      "time": "60 Min / Session",
                      "frequency": "4X / Week",
                      "duration": "10 Weeks",
                      "price": "6000/- PKR",
                      "rating": "4.7",
                    },
                  ],
                ),
              ),
              // Declined Bookings
              const Text(
                'Declined Bookings',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const Text(
                'These bookings were declined by the tutor.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 220,
                child: SwipeCardExample(
                  cards: const [
                    {
                      "name": "Zain Ahmed",
                      "package": "Basic Package",
                      "time": "45 Min / Session",
                      "frequency": "2X / Week",
                      "duration": "6 Weeks",
                      "price": "3000/- PKR",
                      "rating": "4.5",
                    },
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedIndex: 2, onItemTapped: _onItemTapped),
    );
  }
}

class SwipeCardExample extends StatelessWidget {
  final List<Map<String, String>> cards;

  SwipeCardExample({
    this.cards = const [
      {
        "name": "Shehdad Ali",
        "package": "Package Name",
        "time": "90 Min / Session",
        "frequency": "3X / Week",
        "duration": "8 Weeks",
        "price": "5000/- PKR",
        "rating": "4.8",
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return Center(
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                color: const Color(0xfff7f7f7),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: 280,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with profile and rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('assets/Ellipse1.png'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cards[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                cards[index]['package']!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(
                                cards[index]['rating']!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(cards[index]['time']!),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.repeat, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(cards[index]['frequency']!),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(cards[index]['duration']!),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(cards[index]['price']!),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: index == 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
