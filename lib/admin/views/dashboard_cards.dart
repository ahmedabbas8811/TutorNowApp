import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newifchaly/admin/controllers/tutor_controller.dart';
import 'package:newifchaly/admin/widgets/animated_percentage_bar.dart';
import '../widgets/engagement_card.dart';
import '../widgets/status_card.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_model.dart';

class DashboardCards {
  static Widget platformEngagementCard() {
    return PlatformEngagementCard();
  }

  static Widget profileRequestsCard() {
    return ProfileRequestsCard();
  }

  static Widget bookingRequestsCard() {
    return const BookingRequestsCard();
  }
}

class PlatformEngagementCard extends StatefulWidget {
  PlatformEngagementCard({super.key});

  @override
  State<PlatformEngagementCard> createState() => _PlatformEngagementCardState();
}

class _PlatformEngagementCardState extends State<PlatformEngagementCard> {
  final DashboardController _controller = DashboardController();
  late Future<DashboardStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _controller.fetchPlatformEngagement();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return FutureBuilder<DashboardStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        final stats = snapshot.data ?? DashboardStats.empty();
        
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: isSmallScreen ? double.infinity : 400),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Platform Engagement',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: EngagementCard(
                              icon: Icons.person,
                              circleColor: const Color(0xff87e64c),
                              iconColor: Colors.black,
                              value: stats.newUsers.toString(),
                              label: 'New User Sign Ups',
                            ),
                          ),
                          Flexible(
                            child: EngagementCard(
                              icon: Icons.check_circle,
                              circleColor: Colors.blue,
                              iconColor: Colors.white,
                              value: stats.completedSessions.toString(),
                              label: 'Feedbacks Recieved',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: EngagementCard(
                              icon: Icons.school,
                              circleColor: Colors.yellow,
                              iconColor: Colors.black,
                              value: stats.activeTutors.toString(),
                              label: 'Active Tutors',
                            ),
                          ),
                          Flexible(
                            child: EngagementCard(
                              icon: Icons.person_outline,
                              circleColor: Colors.purple,
                              iconColor: Colors.white,
                              value: stats.activeStudents.toString(),
                              label: 'Active Students',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileRequestsCard extends StatelessWidget {
  final TutorController controller = Get.find<TutorController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Obx(() => Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: isSmallScreen ? double.infinity : 400),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffebebeb)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Profile Requests',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${controller.reviewedPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 4),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profiles', style: TextStyle(fontSize: 10)),
                  Text('Reviewed', style: TextStyle(fontSize: 10))
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          AnimatedPercentageBar(
                            percentage: controller.pendingPercentage / 100,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${controller.pendingPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          AnimatedPercentageBar(
                            percentage: controller.approvedPercentage / 100,
                            color: const Color(0xff87e64c),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${controller.approvedPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          AnimatedPercentageBar(
                            percentage: controller.rejectedPercentage / 100,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${controller.rejectedPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: StatusCard(
                      color: Colors.orange,
                      icon: Icons.access_time,
                      value: controller.pendingCount.value.toString(),
                      label: 'Pending',
                    ),
                  ),
                  Flexible(
                    child: StatusCard(
                      color: const Color(0xff87e64c),
                      icon: Icons.check_circle,
                      value: controller.approvedCount.value.toString(),
                      label: 'Approved',
                    ),
                  ),
                  Flexible(
                    child: StatusCard(
                      color: Colors.red,
                      icon: Icons.cancel,
                      value: controller.rejectedCount.value.toString(),
                      label: 'Rejected',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ));
  }
}

class BookingRequestsCard extends StatefulWidget {
  const BookingRequestsCard({super.key});

  @override
  State<BookingRequestsCard> createState() => _BookingRequestsCardState();
}

class _BookingRequestsCardState extends State<BookingRequestsCard> {
  final DashboardController _controller = DashboardController();
  late Future<BookingStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _controller.fetchBookingStats();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return FutureBuilder<BookingStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        final stats = snapshot.data ?? BookingStats.empty();
        
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: isSmallScreen ? double.infinity : 400),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffebebeb)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Booking Requests',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      stats.totalRequests.toString(),
                      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Booking', style: TextStyle(fontSize: 10)),
                      Text('Requests', style: TextStyle(fontSize: 10))
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              AnimatedPercentageBar(
                                percentage: stats.inProgressPercentage,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${(stats.inProgressPercentage * 100).toStringAsFixed(0)}%', 
                                style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              AnimatedPercentageBar(
                                percentage: stats.completedPercentage,
                                color: const Color(0xff87e64c),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${(stats.completedPercentage * 100).toStringAsFixed(0)}%', 
                                style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              AnimatedPercentageBar(
                                percentage: stats.rejectedPercentage,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${(stats.rejectedPercentage * 100).toStringAsFixed(0)}%', 
                                style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: StatusCard(
                          color: Colors.orange,
                          icon: Icons.access_time,
                          value: stats.inProgress.toString(),
                          label: 'In Progress',
                        ),
                      ),
                      Flexible(
                        child: StatusCard(
                          color: const Color(0xff87e64c),
                          icon: Icons.check_circle,
                          value: stats.completed.toString(),
                          label: 'Completed',
                        ),
                      ),
                      Flexible(
                        child: StatusCard(
                          color: Colors.red,
                          icon: Icons.cancel,
                          value: stats.rejected.toString(),
                          label: 'Rejected',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}