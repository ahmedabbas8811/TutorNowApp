import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newifchaly/admin/controllers/tutor_controller.dart';
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
    return FutureBuilder<DashboardStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        final stats = snapshot.data ?? DashboardStats.empty();
        
        return Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Platform Engagement',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EngagementCard(
                    icon: Icons.person,
                    circleColor: const Color(0xff87e64c),
                    iconColor: Colors.black,
                    value: stats.newUsers.toString(),
                    label: 'New User Sign Ups',
                  ),
                  EngagementCard(
                    icon: Icons.check_circle,
                    circleColor: Colors.blue,
                    iconColor: Colors.white,
                    value: stats.completedSessions.toString(),
                    label: 'Session done',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EngagementCard(
                    icon: Icons.school,
                    circleColor: Colors.yellow,
                    iconColor: Colors.black,
                    value: stats.activeTutors.toString(),
                    label: 'Active Tutors',
                  ),
                  EngagementCard(
                    icon: Icons.person_outline,
                    circleColor: Colors.purple,
                    iconColor: Colors.white,
                    value: stats.activeStudents.toString(),
                    label: 'Active Students',
                  ),
                ],
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
    return Obx(() => Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffebebeb)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Profile Requests',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  '${controller.reviewedPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 1),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${controller.pendingPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff87e64c),
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${controller.approvedPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${controller.rejectedPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatusCard(
                color: Colors.orange,
                icon: Icons.access_time,
                value: controller.pendingCount.value.toString(),
                label: 'Pending',
              ),
              StatusCard(
                color: const Color(0xff87e64c),
                icon: Icons.check_circle,
                value: controller.approvedCount.value.toString(),
                label: 'Approved',
              ),
              StatusCard(
                color: Colors.red,
                icon: Icons.cancel,
                value: controller.rejectedCount.value.toString(),
                label: 'Rejected',
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class BookingRequestsCard extends StatelessWidget {
  const BookingRequestsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffebebeb)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Booking Requests',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  '192',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Booking', style: TextStyle(fontSize: 10)),
                  Text('Requests', style: TextStyle(fontSize: 10))
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('32%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff87e64c),
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('41%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('24%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatusCard(
                color: Colors.orange,
                icon: Icons.access_time,
                value: '76',
                label: 'In Progress',
              ),
              StatusCard(
                color: Color(0xff87e64c),
                icon: Icons.check_circle,
                value: '104',
                label: 'Completed',
              ),
              StatusCard(
                color: Colors.red,
                icon: Icons.cancel,
                value: '2',
                label: 'Rejected',
              ),
            ],
          ),
        ],
      ),
    );
  }
}