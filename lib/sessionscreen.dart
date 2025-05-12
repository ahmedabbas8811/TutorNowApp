import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/aboutprogress.dart';
import 'package:newifchaly/controllers/booking_controller.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';
import 'package:newifchaly/views/booking_request_screen.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/views/setpakages_screen.dart';
import 'package:newifchaly/views/widgets/booking_card_shimmer.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final TutorBookingsController controller = TutorBookingsController();
  int _selectedIndex = 2;
  List<BookingModel> pendingBookings = [];
  List<BookingModel> activeBookings = [];
  List<BookingModel> cancelledBookings = [];
  List<BookingModel> completedBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final bookingsData = await controller.fetchTutorBookings();
    setState(() {
      pendingBookings = bookingsData['pending']!;
      activeBookings = bookingsData['active']!;
      cancelledBookings = bookingsData['cancelled']!;
      completedBookings = bookingsData['completed']!;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
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
        screen = SetpakagesScreen();
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
    final ProfileController profileController = Get.put(ProfileController());
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
              buildBookingRequestsSection(),
              const SizedBox(height: 24),
              buildBookingActiveSection(context),
              const SizedBox(height: 24),
              buildBookingCompletedSection(),
              const SizedBox(height: 24),
              buildBookingCancelledSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          pendingBookingsCount: profileController.pendingBookingsCount.value)),
    );
  }

  Widget buildBookingRequestsSection() {
    return buildBookingSection(
      title: 'Booking Requests',
      bookings: pendingBookings,
      onTap: (booking) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingRequestScreen(booking: booking),
          ),
        );
      },
      statusColor: Colors.orange,
    );
  }

  Widget buildBookingCompletedSection() {
    return buildBookingSection(
      title: 'Completed Bookings',
      bookings: completedBookings,
      onTap: (booking) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingRequestScreen(booking: booking),
          ),
        );
      },
      statusColor: const Color.fromARGB(0, 227, 227, 227),
    );
  }

  Widget buildBookingCancelledSection() {
    return buildBookingSection(
      title: 'Cancelled Bookings',
      bookings: cancelledBookings,
      onTap: (booking) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingRequestScreen(booking: booking),
          ),
        );
      },
      statusColor: const Color.fromARGB(0, 84, 84, 84),
    );
  }

  Widget buildBookingActiveSection(BuildContext context) {
    return buildBookingSection(
      title: 'Active',
      bookings: activeBookings,
      onTap: (booking) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutProgress(booking: booking),
          ),
        );
      },
      statusColor: Colors.green,
    );
  }

  Widget buildBookingSection({
    required String title,
    required List<BookingModel> bookings,
    required Function(BookingModel) onTap,
    required Color statusColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Tap to see details',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: _isLoading // Check if data is loading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // Number of shimmer cards to show
                  itemBuilder: (context, index) {
                    return BookingCardShimmer(); // Show shimmer effect
                  },
                )
              : bookings.isEmpty
                  ? Center(child: Text("No $title found."))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        var booking = bookings[index];
                        return GestureDetector(
                          onTap: () => onTap(booking),
                          child: SwipeableSessionCard(
                            name: booking.studentName,
                            imageUrl: booking.studentImage,
                            package: booking.packageName,
                            time: "${booking.minutesPerSession} Min / Session",
                            frequency: "${booking.sessionsPerWeek}X / Week",
                            duration: "${booking.numberOfWeeks} Weeks",
                            price: "${booking.price}/- PKR",
                            statusColor: statusColor,
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class SwipeableSessionCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String package;
  final String time;
  final String frequency;
  final String duration;
  final String price;
  final Color statusColor;

  const SwipeableSessionCard({
    required this.name,
    required this.imageUrl,
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
                    backgroundImage: imageUrl.isNotEmpty &&
                            Uri.tryParse(imageUrl)?.hasAbsolutePath == true
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/Ellipse1.png'),
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
    );
  }
}
