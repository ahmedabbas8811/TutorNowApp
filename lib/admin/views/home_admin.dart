import 'package:flutter/material.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/widgets/dashboard_cards.dart';
import 'package:newifchaly/admin/widgets/qualification_chart.dart';
import 'package:newifchaly/admin/widgets/experience_chart.dart';
import 'package:newifchaly/admin/widgets/session_card.dart';
import 'package:newifchaly/admin/widgets/session_row.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String selectedTimeFrame = 'In 24 Hours';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Sidebar
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
                        leading: const Icon(Icons.home, color: Colors.black),
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
                            MaterialPageRoute(builder: (context) => ApproveTutorsScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 5.0),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 5.0, right: 16.0),
                          child: Row(
                            children: [
                              DashboardCards.buildPlatformEngagementCard(),
                              const SizedBox(width: 20),
                              DashboardCards.buildProfileRequestsCard(),
                              const SizedBox(width: 20),
                              DashboardCards.buildBookingRequestsCard(),
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
                                    'Upcoming Sessions',
                                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        SessionCard(
                                          timeFrame: 'In 24 Hours',
                                          count: '3',
                                          isSelected: selectedTimeFrame == 'In 24 Hours',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 24 Hours'),
                                        ),
                                        SessionCard(
                                          timeFrame: 'In 7 Days',
                                          count: '16',
                                          isSelected: selectedTimeFrame == 'In 7 Days',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 7 Days'),
                                        ),
                                        SessionCard(
                                          timeFrame: 'In 15 Days',
                                          count: '25',
                                          isSelected: selectedTimeFrame == 'In 15 Days',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 15 Days'),
                                        ),
                                        SessionCard(
                                          timeFrame: 'In 30 Days',
                                          count: '45',
                                          isSelected: selectedTimeFrame == 'In 30 Days',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 30 Days'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const SessionRow(
                                    tutorName: 'Muhammad Ali',
                                    studentName: 'Bilal Jan',
                                    date: '24-05-2025',
                                    time: '1:00 PM',
                                  ),
                                  const SessionRow(
                                    tutorName: 'Kashif Sarwar',
                                    studentName: 'Hanzala Khan',
                                    date: '24-5-2025',
                                    time: '3:00 PM',
                                  ),
                                  const SessionRow(
                                    tutorName: 'Sami Ullah',
                                    studentName: 'Akif Imtiaz',
                                    date: '25-5-2025',
                                    time: '9:00 PM',
                                  ),
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
