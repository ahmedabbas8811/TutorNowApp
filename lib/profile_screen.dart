import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/bio_screen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/splashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/profile_controller.dart';
import 'location_screen.dart';
import 'messagescreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0; // Set initial selected index to Home (0)
  bool _isLoading = true; // Loader state
  final id = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Stop loading after 2 seconds
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to a new page based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AvailabilityScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SessionsScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EarningsScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PersonScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Trigger data fetching on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateProfileStatus();
      controller.updateVerificationStatus();
      controller.fetchProfileCompletionData();
      controller.fetchUserName();
    
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(const Color(0xff87e64c)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  // Top Row with Logo and Messages Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/ali.png',
                        height: screenHeight * 0.05,
                      ),
                      IconButton(
                        icon: const Icon(Icons.message_outlined,
                            color: Colors.black),
                        onPressed: () => Get.to(() => const MessageScreen()),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Welcome Text
                  Obx(() => Text(
                        'Hello ${controller.profile.value.name}',
                        style: const TextStyle(
                            fontSize: 31, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: screenHeight * 0.02),

                  // Upcoming Bookings Section
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

                  // Profile Completion Section
                  Obx(() {
                    if (controller.profile.value.isVerified) {
                      // If profile is verified, show nothing
                      return SizedBox.shrink();
                    } else if (!controller.profile.value.isProfileComplete) {
                      // If profile is NOT complete
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Incomplete Message
                          Text(
                            'Your profile is not complete; incomplete profiles are not visible to students',
                            style: const TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          // Steps Remaining
                          Text(
                            '${controller.profile.value.stepscount} Steps Remaining',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Complete Profile Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () => Get.to(() => BioScreen()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff87e64c),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Complete Profile',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    // If profile is complete but not verified
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16)),
                      padding: EdgeInsetsDirectional.all(16),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/confetti.svg',
                            height: 36,
                            width: 36,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'You Completed Your Profile!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const Text(
                            'Wait until your profile gets verified by our admin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      )),
                    );
                  }),

                  const Spacer(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex, // The selected index now starts at 0 (Home)
        type: BottomNavigationBarType
            .fixed, // Fixed type ensures white background
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
        onTap: _onItemTapped,
      ),
    );
  }
}
