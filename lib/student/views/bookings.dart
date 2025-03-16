import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/booking_controller.dart';
import 'package:newifchaly/student/views/progress_stu.dart';
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
  final BookingController bookingController = Get.put(BookingController());

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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pending Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Your booking request has been sent to the tutor. Please wait for their confirmation!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),

              // Dynamic Pending Bookings Section
              Obx(() {
                if (bookingController.pendingBookings.isEmpty) {
                  return const Center(child: Text("No pending bookings."));
                }

                return BookingSwipeView(
                  cards: bookingController.pendingBookings.map((booking) {
                    return BookingCard(
                      name: booking.tutorName,
                      tutorImage: booking.tutorImage,
                      package: booking.packageName,
                      time: "${booking.minutesPerSession} Min / Session",
                      frequency: "${booking.sessionsPerWeek}X / Week",
                      duration: "${booking.numberOfWeeks} Weeks",
                      price: "${booking.price}/- PKR",
                      rating: "4.8",
                      statusColor: Colors.orange,
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Active Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tap the booking card for more options!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (bookingController.activeBookings.isEmpty) {
                  return const Center(child: Text("No Active bookings."));
                }

                return BookingSwipeView(
                  cards: bookingController.activeBookings.map((booking) {
                    return BookingCard(
                      name: booking.tutorName,
                      tutorImage: booking.tutorImage,
                      package: booking.packageName,
                      time: "${booking.minutesPerSession} Min / Session",
                      frequency: "${booking.sessionsPerWeek}X / Week",
                      duration: "${booking.numberOfWeeks} Weeks",
                      price: "${booking.price}/- PKR",
                      rating: "4.8",
                      statusColor: Colors.orange,
                      onTap: () {
                        // Navigate to the progress screen with the selected booking
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgressScreen(booking: booking),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }),

              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Declined Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'These bookings were declined by the tutor.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              BookingSwipeView(
                cards: [
                  BookingCard(
                    name: 'Shehdad Ali',
                    package: 'Package Name',
                    tutorImage: 'assets/Ellipse1.png',
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
      height: 170, // Adjusted height to match the SessionScreen card height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
  final String tutorImage;
  final String time;
  final String frequency;
  final String duration;
  final String price;
  final String rating;
  final Color statusColor;
  final VoidCallback? onTap;

  const BookingCard({
    required this.name,
    required this.package,
    required this.tutorImage,
    required this.time,
    required this.frequency,
    required this.duration,
    required this.price,
    required this.rating,
    required this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 10),
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
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: tutorImage.isNotEmpty &&
                              Uri.tryParse(tutorImage)?.hasAbsolutePath == true
                          ? NetworkImage(tutorImage)
                          : const AssetImage('assets/Ellipse1.png') as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(package,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                    CircleAvatar(radius: 4, backgroundColor: statusColor),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.timer, size: 18),
                      Text(time)
                    ]),
                    Row(children: [
                      const Icon(Icons.refresh, size: 18),
                      Text(frequency)
                    ]),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.calendar_today, size: 18),
                      Text(duration)
                    ]),
                    Row(children: [
                      const Icon(Icons.attach_money, size: 18),
                      Text(price)
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}