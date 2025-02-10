import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:newifchaly/changepassword_screen.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';
import '../controllers/person_controller.dart';

class PersonScreen extends StatefulWidget {
  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final PersonController controller =
      Get.put(PersonController()); // Inject controller
  int _selectedIndex = 4; // Default tab is Profile

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    controller.navigateTo(index); // Use controller for navigation
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profilecontroller = Get.put(ProfileController());
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
                      if (profile.isVerified)
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/verified.svg',
                              height: 28,
                              width: 28,
                            ),
                          ],
                        )
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (!profile.isVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      color: profile.isProfileComplete
                          ? const Color(0xfff2f2f2)
                          : Colors.yellow,
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
                  const SizedBox(height: 30),
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
                              padding: const EdgeInsets.all(16)),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      final qualifications =
                          controller.profile.value.qualifications;

                      if (qualifications.isEmpty) {
                        return const Center(
                          child: Text(
                            'No qualifications found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Qualification',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...qualifications.map((qualification) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    qualification.educationLevel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 1.36,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    qualification.instituteName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      height: 1.37,
                                      color: Color(0x99000000),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      final experiences = controller.profile.value.experiences;

                      if (experiences.isEmpty) {
                        return const Center(
                          child: Text(
                            'No experiences found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...experiences.map((experience) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    experience.studentEducationLevel,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600, // Matches 600 weight
                                      fontSize: 16, // Matches 16px
                                      height: 1.36, // Line height: 21.86px
                                      color: Colors.black, // Solid black color
                                    ),
                                  ),
                                  Text(
                                    experience.stillWorking
                                        ? 'Still Teaching'
                                        : '${experience.startDate} - ${experience.endDate}',
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w500, // Matches 500 weight
                                      fontSize: 12, // Matches 12px
                                      height: 1.37, // Line height: 16.39px
                                      color: Color(0x99000000), // 60% black
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
          ),
        ),
        bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            pendingBookingsCount:
                profilecontroller.pendingBookingsCount.value)));
  }
}
