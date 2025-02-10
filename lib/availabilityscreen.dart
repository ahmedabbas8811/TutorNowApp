import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/editavailability_screen.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AvailabilityScreen extends StatefulWidget {
  @override
  _AvailabilityScreenState createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  int _selectedIndex = 1; // Default index for "Availability"

  // Fetch availability data where is_available is true
  Future<List<Map<String, dynamic>>> _fetchAvailabilityData() async {
    try {
      // Fetch only the rows where `is_available` is true
      final List<dynamic> data = await Supabase.instance.client
          .from('availability')
          .select('day, slots')
          .eq('is_available', true); // Filter rows where is_available is true

      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to fetch availability: $e');
    }
  }

  // Convert time from 24-hour to 12-hour format
  String _convertTo12HourFormat(String timeRange) {
    final times = timeRange.split('-'); // Split start and end times
    final start = DateFormat("HH:mm").parse(times[0].trim());
    final end = DateFormat("HH:mm").parse(times[1].trim());

    final formattedStart = DateFormat("hh:mm a").format(start);
    final formattedEnd = DateFormat("hh:mm a").format(end);

    return '$formattedStart - $formattedEnd';
  }

  // Handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => ProfileScreen(), binding: BindingsBuilder(() {
          if (!Get.isRegistered<ProfileController>()) {
            Get.put(ProfileController());
          }
        }));
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvailabilityScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EarningsScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profilecontroller = Get.put(ProfileController());

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Set Availability',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sessions that are already booked are not affected by changing availability',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to EditAvailabilityScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAvailabilityScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Schedule',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchAvailabilityData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No availability data found'),
                      );
                    }

                    final availabilityData = snapshot.data!;
                    return ListView.builder(
                      itemCount: availabilityData.length,
                      itemBuilder: (context, index) {
                        final dayData = availabilityData[index];
                        final day = dayData['day'] as String;
                        final slots = dayData['slots'] as List<dynamic>;

                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 3.0),
                          title: Text(
                            day,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: slots.map((slot) {
                              if (slot is Map<String, dynamic>) {
                                final startTime = slot['start'] ?? '';
                                final endTime = slot['end'] ?? '';
                                return Text(
                                  _convertTo12HourFormat('$startTime-$endTime'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              } else if (slot is String) {
                                return Text(
                                  _convertTo12HourFormat(slot),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return const Text(
                                  'Invalid slot format',
                                  style: TextStyle(color: Colors.red),
                                );
                              }
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            pendingBookingsCount:
                profilecontroller.pendingBookingsCount.value)));
  }
}
