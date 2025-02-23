import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/controllers/booking_controller.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';
import 'package:newifchaly/views/booking_request_screen.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
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

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final bookingsData = await controller.fetchTutorBookings();
    List<BookingModel> pending = bookingsData['pending']!;
    List<BookingModel> active = bookingsData['active']!;
    List<BookingModel> completed = bookingsData['completed']!;

    setState(() {
      pendingBookings = pending;
      activeBookings = active;
    });
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
        context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profilecontroller = Get.put(ProfileController());
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                const Text('My Bookings',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                buildBookingRequestsSection(),
                const SizedBox(height: 24),
                buildBookingActiveSection(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            pendingBookingsCount:
                profilecontroller.pendingBookingsCount.value)));
  }

  Widget buildBookingRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Booking Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Tap to see details',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: pendingBookings.isEmpty
              ? const Center(child: Text("No booking requests found."))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pendingBookings.length,
                  itemBuilder: (context, index) {
                    var booking = pendingBookings[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingRequestScreen(
                              booking: pendingBookings[index],
                            ),
                          ),
                        );
                      },
                      child: SwipeableSessionCard(
                        name: booking.studentName,
                        imageUrl: booking.studentImage,
                        package: booking.packageName,
                        time: "${booking.minutesPerSession} Min / Session",
                        frequency: "${booking.sessionsPerWeek}X / Week",
                        duration: "${booking.numberOfWeeks} Weeks",
                        price: "${booking.price}/- PKR",
                        statusColor: Colors.orange,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget buildBookingActiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Active',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Tap to see details',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: activeBookings.isEmpty
              ? const Center(child: Text("No booking requests found."))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: activeBookings.length,
                  itemBuilder: (context, index) {
                    var booking = activeBookings[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingRequestScreen(
                              booking: activeBookings[index],
                            ),
                          ),
                        );
                      },
                      child: SwipeableSessionCard(
                        name: booking.studentName,
                        imageUrl: booking.studentImage,
                        package: booking.packageName,
                        time: "${booking.minutesPerSession} Min / Session",
                        frequency: "${booking.sessionsPerWeek}X / Week",
                        duration: "${booking.numberOfWeeks} Weeks",
                        price: "${booking.price}/- PKR",
                        statusColor: Colors.orange,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget buildSection(String title, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              SwipeableSessionCard(
                name: 'Shehdad Ali',
                imageUrl: 'assets/Ellipse1.png',
                package: 'Package Name',
                time: '90 Min / Session',
                frequency: '3X / Week',
                duration: '8 Weeks',
                price: '5000/- PKR',
                statusColor: statusColor,
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
