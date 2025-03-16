import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:newifchaly/controllers/booking_controller.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';

class BookingRequestScreen extends StatefulWidget {
  final BookingModel booking;

  const BookingRequestScreen({Key? key, required this.booking})
      : super(key: key);

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
    setState(() {});
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
  final ProfileController profileController = Get.put(ProfileController());
  return Scaffold(
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
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
                          Uri.tryParse(widget.booking.studentImage)
                                  ?.hasAbsolutePath == true
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

                // Package details
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

                // Time slots
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.booking.timeSlots.entries.map((entry) {
                      final slot = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text('${slot['day']} ',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text('${slot['time']}',
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Accept and delete buttons
                ElevatedButton(
                  onPressed: () async {
                    print("Activating booking with ID: ${widget.booking.bookingId}");
                    await controller.activateBooking(widget.booking.bookingId, context);
                    setState(() {}); // Refresh UI after activation
                  },
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
                  onPressed: () {}, // Provide delete functionality
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          pendingBookingsCount: profileController.pendingBookingsCount.value)),
  );
}
}