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
            MaterialPageRoute(builder: (context) => StudentHomeScreen()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchResults()),
          );
          break;
        case 2:
          // Do nothing; already on this screen.
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentProfileScreen()),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pending Bookings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Your booking request has been sent to the tutor. Please wait for their confirmation!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              SizedBox(height: 8),
              BookingSwipeView(
                cards: [
                  BookingCard(
                    name: 'Shehdad Ali',
                    package: 'Package Name',
                    time: '90 Min / Session',
                    frequency: '3X / Week',
                    duration: '8 Weeks',
                    price: '5000/- PKR',
                    rating: '4.8',
                    statusColor: Colors.orange,
                  ),
                  BookingCard(
                    name: 'Ali Raza',
                    package: 'Package Name',
                    time: '60 Min / Session',
                    frequency: '2X / Week',
                    duration: '6 Weeks',
                    price: '3000/- PKR',
                    rating: '4.5',
                    statusColor: Colors.orange,
                  ),
                ],
              ),
              SizedBox(height:10 ,),
              Padding(
                padding: EdgeInsets.all(12.0),
                
                child: Text(
                  'Active Bookings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tap the booking card for more options!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              SizedBox(height: 10,),
              BookingSwipeView(
                cards: [
                  BookingCard(
                    name: 'Shehdad Ali',
                    package: 'Package Name',
                    time: '90 Min / Session',
                    frequency: '3X / Week',
                    duration: '8 Weeks',
                    price: '5000/- PKR',
                    rating: '4.8',
                    statusColor: Colors.green,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Declined Bookings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'These bookings were declined by the tutor.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              SizedBox(height: 10,),
              BookingSwipeView(
                cards: [
                  BookingCard(
                    name: 'Shehdad Ali',
                    package: 'Package Name',
                    time: '90 Min / Session',
                    frequency: '3X / Week',
                    duration: '8 Weeks',
                    price: '5000/- PKR',
                    rating: '4.8',
                    statusColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class BookingSwipeView extends StatelessWidget {
  final List<Widget> cards;

  const BookingSwipeView({required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190, // Match the card height
      child: PageView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: cards[index],
          );
        },
      ),
    );
  }
}


class BookingCard extends StatelessWidget {
  final String name;
  final String package;
  final String time;
  final String frequency;
  final String duration;
  final String price;
  final String rating;
  final Color statusColor;

  const BookingCard({
    required this.name,
    required this.package,
    required this.time,
    required this.frequency,
    required this.duration,
    required this.price,
    required this.rating,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffededed),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/Ellipse1.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Name and Rating in a Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        package,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(time),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.repeat, size: 18, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(frequency),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(duration),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 18, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(price),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
