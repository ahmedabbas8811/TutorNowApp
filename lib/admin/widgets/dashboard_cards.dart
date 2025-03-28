import 'package:flutter/material.dart';
import 'engagement_card.dart';
import 'status_card.dart';

class DashboardCards {
  static Widget buildPlatformEngagementCard() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'Platform Engagement',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EngagementCard(
                icon: Icons.person,
                circleColor: Color(0xff87e64c),
                iconColor: Colors.black,
                value: '47',
                label: 'New User Sign Ups',
              ),
              EngagementCard(
                icon: Icons.check_circle,
                circleColor: Colors.blue,
                iconColor: Colors.white,
                value: '344',
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
                value: '132',
                label: 'Active Tutors',
              ),
              EngagementCard(
                icon: Icons.person_outline,
                circleColor: Colors.purple,
                iconColor: Colors.white,
                value: '285',
                label: 'Active Students',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildProfileRequestsCard() {
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
            'Profile Requests',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  '75%',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 1),
              Column(
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
                value: '12',
                label: 'Pending',
              ),
              StatusCard(
                color: Color(0xff87e64c),
                icon: Icons.check_circle,
                value: '16',
                label: 'Approved',
              ),
              StatusCard(
                color: Colors.red,
                icon: Icons.cancel,
                value: '8',
                label: 'Rejected',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildBookingRequestsCard() {
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