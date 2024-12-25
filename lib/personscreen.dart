
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:newifchaly/changepassword_screen.dart';
import 'package:newifchaly/editprofile_screen.dart';
import '../controllers/person_controller.dart';

class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final PersonController controller = Get.put(PersonController()); // Inject controller
  int _selectedIndex = 4; // Default tab is Profile

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    controller.navigateTo(index); // Use controller for navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: ElevatedButton(
              onPressed: controller.logout, // Logout using controller
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe64b4b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Obx(() {
            // Observe changes in profile data
            final profile = controller.profile.value;
            if (profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profile.profileImage),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  if(profile.isVerified)
                  Row(
                    children: [
                      SizedBox(width: 8,),
                      SvgPicture.asset('assets/verified.svg',
                      height: 28,
                      width: 28,),
                    ],
                  )
                  ],
                ),
                const SizedBox(height: 5),
                if (!profile.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    color: profile.isProfileComplete ? const Color(0xfff2f2f2) : Colors.yellow,
                    child: Text(
                      profile.isProfileComplete
                          ? 'Profile is under verification'
                          : '⚠ Profile is incomplete',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => ChangePasswordScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff87e64c),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16)
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed layout for white background
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
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
