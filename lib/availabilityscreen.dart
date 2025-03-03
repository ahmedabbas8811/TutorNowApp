import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/editavailability_screen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart'; 

class AvailabilityScreen extends StatefulWidget {
  @override
  _AvailabilityScreenState createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  int _selectedIndex = 1; 
  String _selectedDay = 'Monday';
  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  Future<List<Map<String, dynamic>>> _fetchAvailabilityData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final List<dynamic> data = await Supabase.instance.client
          .from('availability')
          .select('day, slots')
          .eq('is_available', true)
          .eq('user_id', user.id) 
          .eq('day', _selectedDay);

      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to fetch availability: $e');
    }
  }

  String _convertTo12HourFormat(String timeRange) {
    try {
      final times = timeRange.split('-');
      final start = DateFormat("HH:mm").parse(times[0].trim());
      final end = DateFormat("HH:mm").parse(times[1].trim());
      return '${DateFormat("hh:mm a").format(start)} - ${DateFormat("hh:mm a").format(end)}';
    } catch (e) {
      return 'Invalid Time Format';
    }
  }

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
    final ProfileController profileController = Get.put(ProfileController());
    final Color primaryGreen = Color(0xff87e64c);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set Availability',
                  style: TextStyle(
                    fontSize: 24, // Reduced font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            const Text(
              'Sessions that are already booked are not affected by changing availability',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 16),
            _buildDayScroll(primaryGreen),
            SizedBox(height: 16),
            Expanded(child: _buildAvailabilityList(primaryGreen)),
          ],
        ),
      ),
      // Floating Action Button for Edit Schedule
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditAvailabilityScreen()),
        ),
        backgroundColor: primaryGreen,
        child: Icon(Icons.edit, color: Colors.white),
      ),
      bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          pendingBookingsCount: profileController.pendingBookingsCount.value)),
    );
  }

  Widget _buildDayScroll(Color primaryGreen) {
    return Container(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _daysOfWeek.length,
        itemBuilder: (context, index) {
          final day = _daysOfWeek[index];
          final isSelected = day == _selectedDay;

          return GestureDetector(
            onTap: () => setState(() => _selectedDay = day),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? primaryGreen : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  day.substring(0, 3),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailabilityList(Color primaryGreen) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAvailabilityData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    title: Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                const Text(
                  'Failed to load availability',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No availability data found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final slots = snapshot.data!.expand((d) => d['slots'] ?? []).toList();
        if (slots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No availability for $_selectedDay',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final String timeRange = '${slot['start']} - ${slot['end']}';
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.access_time, color: primaryGreen),
                  title: Text(
                    _convertTo12HourFormat(timeRange),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.check_circle, color: primaryGreen),
                ),
              );
            },
          ),
        );
      },
    );
  }
}