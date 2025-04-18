import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:newifchaly/admin/views/handle_reports.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/admin/views/manageusers.dart';
import '../controllers/tutor_controller.dart';
import 'confirmation_screen.dart';

class ApproveTutorsScreen extends StatelessWidget {
  final TutorController controller = Get.put(TutorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/ali.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeAdmin()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xff87e64c),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.black),
                    title: Text(
                      'Approve Tutors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xfffafafa),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.userTie, color: Colors.black),

                        title: const Text(
                          'Manage Users',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Manageusers()),
                          );
                        },
                      ),
                    ),
                     const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file, color: Colors.black),
                    title: const Text('Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HandleReports()),
                          );
                        },
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: const Color.fromARGB(255, 243, 242, 242),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Approve Tutors',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Header Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Tutor Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Qualification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  // Tutor List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.tutors.isEmpty) {
                        return const Center(child: Text('No tutors found.'));
                      }
                      return ListView.separated(
                        itemCount: controller.tutors.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        itemBuilder: (context, index) {
                          final tutor = controller.tutors[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tutor Name
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      tutor.name,
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // Qualifications
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    tutor.qualificationsString,
                                    style: const TextStyle(fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Status
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(tutor.status),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Text(
                                        tutor.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getTextColor(tutor
                                              .status), 
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // View Details Button
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff87e64c),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(() => ConfirmationScreen(
                                              tutorId: tutor.id,
                                            ));
                                      },
                                      child: const Text(
                                        'View Details',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Color(0xFF87E64B);
      case 'rejected':
        return Color(0xFFE64B4B);
      case 'pending':
        return Color(0xFFFC9B00);

      default:
        return Colors.grey;
    }
  }

  Color _getTextColor(String status) {
    if (status.toLowerCase() == 'rejected') {
      return Colors.white; // White text for green background
    } else {
      return Colors.black; // Black text for red and orange
    }
  }
}
