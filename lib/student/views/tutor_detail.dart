import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/package_controller.dart';
import 'package:newifchaly/student/controllers/student_home_controller.dart';
import 'package:newifchaly/student/controllers/tutor_detail_controller.dart';
import 'package:newifchaly/student/models/student_home_model.dart';
import 'package:newifchaly/student/views/chat_screen.dart';
import 'package:newifchaly/student/views/widgets/about_tutor.dart';
import 'package:newifchaly/student/views/widgets/packages.dart';
import 'package:newifchaly/student/views/widgets/reviews.dart';

class TutorDetailScreen extends StatelessWidget {
  final String userId;
  TutorDetailScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Ensure each tutor gets a unique controller instance using a tag
    final TutorDetailController _controller =
        Get.put(TutorDetailController(UserId: userId), tag: userId);

    final PackagesController _Packagescontroller =
        Get.put(PackagesController(UserId: userId), tag: userId);
    final StudentHomeController _homecontroller =
        Get.put(StudentHomeController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            Get.delete<TutorDetailController>(
                tag: userId); // Remove controller instance when back is pressed
            Get.delete<PackagesController>(tag: userId);
          },
        ),
        title: Text('Tutor Detail', style: TextStyle(fontSize: 16)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Obx(() {
                final profile = _controller.profile.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profile.profileImage.isNotEmpty
                              ? NetworkImage(profile.profileImage)
                              : null,
                          backgroundColor: Colors.grey[300],
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name.isNotEmpty
                                  ? profile.name
                                  : 'Loading...',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder<Location?>(
                              future:
                                  _homecontroller.fetchTutorLocation(userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('...');
                                } else if (snapshot.hasError) {
                                  return Text('Error loading location');
                                } else {
                                  return Text(snapshot.data!.location);
                                }
                              },
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Obx(() => Text(
                                      _controller.reviews.isNotEmpty
                                          ? _controller.averageRating
                                              .toStringAsFixed(1)
                                          : '0.0',
                                      style: const TextStyle(fontSize: 16),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                          3, (index) => _buildTabButton(index, _controller)),
                    ),
                    SizedBox(height: 16),
                    // Dynamic content based on selected tab
                    Obx(() {
                      switch (_controller.selectedTab.value) {
                        case 0:
                          return AboutTutor(
                            bio: profile.bio,
                            subjects: _controller.subs,
                            qualifications: profile.qualifications,
                            experiences: profile.experiences,
                          );
                        case 1:
                          return PackagesSection(
                            packages: _Packagescontroller.packages,
                            isLoading: _Packagescontroller.isLoading.value,
                            userId: userId,
                          );
                        case 2:
                          return ReviewsSection(tutorId: userId);
                        default:
                          return SizedBox();
                      }
                    }),
                  ],
                );
              }),
            ),
          ),
          // Chat with tutor button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final profileName = _controller.profile.value.name;
                    Get.to(() => ChatScreen(
                          receiverId: userId,
                          receiverName: profileName,
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.black, width: 1.25))),
                  child: Obx(() {
                    // Fetching tutor name
                    final profileName = _controller.profile.value.name;
                    return Text(
                      profileName.isNotEmpty
                          ? 'Chat With $profileName'
                          : 'Loading...',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for building tab buttons
  Widget _buildTabButton(int index, TutorDetailController controller) {
    return Obx(() {
      bool isSelected = controller.selectedTab.value == index;
      return ElevatedButton(
        onPressed: () {
          controller.selectedTab.value = index;
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor:
              isSelected ? Get.theme.primaryColor : Colors.grey[200],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: isSelected
                  ? BorderSide(color: Colors.black, width: 1.25)
                  : BorderSide.none),
          elevation: 0,
        ),
        child: Text(['About', 'Packages', 'Reviews'][index]),
      );
    });
  }
}
