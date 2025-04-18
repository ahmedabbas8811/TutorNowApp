import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/admin/controllers/dashboard_controller.dart';
import 'package:newifchaly/admin/models/dashboard_model.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/dashboard_cards.dart';
import 'package:newifchaly/admin/views/handle_reports.dart';
import 'package:newifchaly/admin/views/manageusers.dart';
import 'package:newifchaly/admin/views/qualification_chart.dart';
import 'package:newifchaly/admin/views/experience_chart.dart';
import 'package:newifchaly/admin/widgets/session_card.dart';
import 'package:newifchaly/admin/widgets/session_row.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String selectedTimeFrame = 'Past 24 Hours';
  final DashboardController _controller = DashboardController();
  List<Booking> _bookings = [];
  Map<String, int> _bookingCounts = {
    'Past 24 Hours': 0,
    'Past 7 Days': 0,
    'Past 15 Days': 0,
    'Past 30 Days': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

Future<void> _loadInitialData() async {
  if (mounted) setState(() => _isLoading = true);
  try {
    await Future.wait([
      _loadBookingCounts(),
      _loadRecentBookings(),
    ]);
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

Future<void> _loadBookingCounts() async {
  final counts = {
    'Past 24 Hours': await _controller.getBookingCount('Past 24 Hours'),
    'Past 7 Days': await _controller.getBookingCount('Past 7 Days'),
    'Past 15 Days': await _controller.getBookingCount('Past 15 Days'),
    'Past 30 Days': await _controller.getBookingCount('Past 30 Days'),
  };
  if (mounted) setState(() => _bookingCounts = counts);
}

Future<void> _loadRecentBookings() async {
  final bookings = await _controller.fetchRecentBookings(selectedTimeFrame);
  if (mounted) setState(() => _bookings = bookings);
}


  void _handleTimeFrameChange(String newTimeFrame) {
    setState(() {
      selectedTimeFrame = newTimeFrame;
      _loadRecentBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Sidebar (unchanged)
              Container(
                width: 200,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Image.asset(
                      'assets/ali.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xff87e64c),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const ListTile(
                        leading: Icon(Icons.home, color: Colors.black),
                        title: Text(
                          'Home',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xfffafafa),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.black),
                        title: const Text(
                          'Approve Tutors',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApproveTutorsScreen()),
                          );
                        },
                      ),
                    ),
                     const SizedBox(height: 8),
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xfffafafa),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.userTie, color: Colors.black),

                        title: const Text(
                          'Manage Users',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Manageusers()),
                          );
                        },
                      ),
                    ),
                       const SizedBox(height: 8),
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xfffafafa),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.insert_drive_file, color: Colors.black),

                        title: const Text(
                          'Reports',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HandleReports()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 5.0),
                              child: Text(
                                'Dashboard',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 5.0, right: 16.0),
                                child: Row(
                                  children: [
                                    DashboardCards.platformEngagementCard(),
                                    const SizedBox(width: 20),
                                    DashboardCards.profileRequestsCard(),
                                    const SizedBox(width: 20),
                                    DashboardCards.bookingRequestsCard(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const QualificationChart(),
                                        const SizedBox(width: 20),
                                        const ExperienceChart(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Recent Bookings',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              SessionCard(
                                                timeFrame: 'Past 24 Hours',
                                                count: _bookingCounts['Past 24 Hours']?.toString() ?? '0',
                                                isSelected: selectedTimeFrame == 'Past 24 Hours',
                                                onTap: () => _handleTimeFrameChange('Past 24 Hours'),
                                              ),
                                              SessionCard(
                                                timeFrame: 'Past 7 Days',
                                                count: _bookingCounts['Past 7 Days']?.toString() ?? '0',
                                                isSelected: selectedTimeFrame == 'Past 7 Days',
                                                onTap: () => _handleTimeFrameChange('Past 7 Days'),
                                              ),
                                              SessionCard(
                                                timeFrame: 'Past 15 Days',
                                                count: _bookingCounts['Past 15 Days']?.toString() ?? '0',
                                                isSelected: selectedTimeFrame == 'Past 15 Days',
                                                onTap: () => _handleTimeFrameChange('Past 15 Days'),
                                              ),
                                              SessionCard(
                                                timeFrame: 'Past 30 Days',
                                                count: _bookingCounts['Past 30 Days']?.toString() ?? '0',
                                                isSelected: selectedTimeFrame == 'Past 30 Days',
                                                onTap: () => _handleTimeFrameChange('Past 30 Days'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff87e64c),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text('Tutor Name', 
                                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text('Student Name', 
                                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                              ),
                                              Expanded(
                                                child: Text('Date', 
                                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                              ),
                                              Expanded(
                                                child: Text('Time', 
                                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (_bookings.isEmpty)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            child: Center(child: Text('No bookings found')),
                                          )
                                        else
                                          ..._bookings.map((booking) => SessionRow(
                                            tutorName: booking.tutorName,
                                            studentName: booking.studentName,
                                            date: booking.formattedDate,
                                            time: DateFormat.jm().format(booking.createdAt),
                                          )).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}