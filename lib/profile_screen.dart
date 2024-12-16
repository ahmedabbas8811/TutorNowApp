// views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'location_screen.dart';
import 'messagescreen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/ali.png',
                  height: screenHeight * 0.05,
                ),
                IconButton(
                  icon: const Icon(Icons.message_outlined, color: Colors.black),
                  onPressed: () => Get.to(() => MessageScreen()),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Obx(() => Text(
                  'Hello ${controller.profile.value.name}',
                  style: const TextStyle(
                      fontSize: 31, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              'Upcoming Bookings',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.01),
            Obx(() => Container(
                  width: screenWidth,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      controller.profile.value.upcomingBookings.isEmpty
                          ? 'Your upcoming sessions will be shown\nhere, once booked'
                          : controller.profile.value.upcomingBookings
                              .join("\n"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )),
            SizedBox(height: screenHeight * 0.1),
            Obx(() => Text(
                  controller.profile.value.isProfileComplete
                      ? 'Your profile is complete!'
                      : 'Your profile is not complete; incomplete profiles are not visible to students',
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                )),
            Obx(() => Text(
                  '${controller.profile.value.stepscount} Steps Remaining',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(height: screenHeight * 0.03),
            Obx(() {
              if (!controller.profile.value.isProfileComplete) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => LocationScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff87e64c),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Complete Profile',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
              type: BottomNavigationBarType.fixed, // Fixed type ensures white background
          backgroundColor: Colors.white,
            selectedItemColor: const Color(0xff87e64c),
            unselectedItemColor: Colors.black,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available),
                label: 'Availability',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_camera_front),
                label: 'Sessions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Earnings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) => controller.navigateToPage(context, index),
          )),
    );
  }
}
