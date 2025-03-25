import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
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
                // Logo Image
                Image.asset(
                  'assets/ali.png', // Make sure this image exists
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
               Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color:const Color(0xfffafafa),
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
    color: const Color(0xff87e64c), // Green BG
    borderRadius: BorderRadius.circular(30),
  ),
  child: ListTile(
    leading: const Icon(Icons.home, color: Colors.black),
    title: const Text(
      'Approve Tutors',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
   
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Tutor Name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                       
                         Expanded(
                          child: Text(
                            'Qualification',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.tutors.isEmpty) {
                        return const Center(child: Text('No tutors found.'));
                      }
                      return ListView.builder(
                        itemCount: controller.tutors.length,
                        itemBuilder: (context, index) {
                          final tutor = controller.tutors[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    tutor.name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tutor.qualification,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff87e64c),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => ConfirmationScreen(
                                          tutorId: tutor.id,
                                        ));
                                  },
                                  child: const Text(
                                    'View Details',
                                    style: TextStyle(color: Colors.black),
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
}
