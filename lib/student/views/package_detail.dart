import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/package_detail_controller.dart';
import 'package:newifchaly/student/controllers/tutor_detail_controller.dart';

import 'package:newifchaly/student/views/tutor_avaialbility.dart';

class PackageDetailScreen extends StatelessWidget {
  final int packageId;
  final String userId;

  PackageDetailScreen({Key? key, required this.packageId, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PackageDetailController _controller =
        Get.put(PackageDetailController(packageId: packageId));

    final TutorDetailController tutorController =
        Get.put(TutorDetailController(UserId: userId), tag: userId);

    final profile = tutorController.profile.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final package = _controller.package.value;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: profile.profileImage != null &&
                          profile.profileImage.isNotEmpty
                      ? NetworkImage(profile.profileImage)
                      : null,
                  child: profile.profileImage == null ||
                          profile.profileImage.isEmpty
                      ? Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                SizedBox(height: 8),
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        tutorController.averageRating.value.toStringAsFixed(1),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(135, 230, 75, 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        package.description,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18),
                          SizedBox(width: 8),
                          Text(
                              '${package.hours} Hours : ${package.minutes} Minutes / Session'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.repeat, size: 18),
                          SizedBox(width: 8),
                          Text('${package.sessions}X / Week'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 8),
                          Text('${package.weeks} Weeks'),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          const BoxShadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_controller.isLoading.value) {
                            // Ensure data is loaded before accessing
                            int sessionsPerWeek = _controller.package.value
                                .sessions; // Get sessions per week

                            print(
                                "Passing Sessions Per Week: $sessionsPerWeek"); // Debugging log

                            Get.to(() => TutorAvailabilityScreen(
                                  packageId: packageId,
                                  sessions:
                                      sessionsPerWeek, // Pass sessionsPerWeek
                                ));
                          } else {
                            print("Data is still loading...");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 0),
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.black, width: 1.25),
                          ),
                        ),
                        child: Text(
                          'Continue (${_controller.package.value.price} PKR)', // Ensure dynamic price value
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
