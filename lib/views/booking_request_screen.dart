import 'package:flutter/material.dart';
import 'package:newifchaly/controllers/booking_controller.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';

class BookingRequestScreen extends StatefulWidget {
  final BookingModel booking; // Receive booking details

  const BookingRequestScreen({Key? key, required this.booking}) : super(key: key);

  @override
  _BookingRequestScreenState createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  final TutorBookingsController controller = TutorBookingsController();
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  Future<void> fetchBookingDetails() async {
    await controller.fetchStudentInfo(widget.booking);
    await controller.fetchPackageInfo(widget.booking);
    setState(() {}); // Refresh UI after fetching data
  }

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
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  ' Booking Request',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.booking.studentImage.isNotEmpty &&
                      Uri.tryParse(widget.booking.studentImage)?.hasAbsolutePath == true
                  ? NetworkImage(widget.booking.studentImage)
                  : const AssetImage('assets/Ellipse1.png') as ImageProvider,
            ),
            const SizedBox(height: 8),
            Text(
              widget.booking.studentName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.booking.packageName,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.booking.minutesPerSession} Min / Session",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.refresh),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.booking.sessionsPerWeek}X / Week",
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.booking.numberOfWeeks} Weeks",
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Monday ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('8:30 - 10', style: TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Tuesday ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('8:30 - 10', style: TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Wednesday ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('8:30 - 10', style: TextStyle(fontSize: 15))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff87e64c),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Accept',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available), label: 'Availability'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
