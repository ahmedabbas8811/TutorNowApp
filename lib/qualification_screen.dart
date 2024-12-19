// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'teaching_detail.dart';

// class QualificationScreen extends StatefulWidget {
//   @override
//   _QualificationScreenState createState() => _QualificationScreenState();
// }

// class _QualificationScreenState extends State<QualificationScreen> {
//   final TextEditingController educationLevelController =
//       TextEditingController();
//   final TextEditingController instituteNameController = TextEditingController();
//   String? _qualificationFileName;
//   File? _qualificationFile;

//   // Function to pick the qualification file (PDF)
//   Future<void> _pickQualificationFile() async {
//     bool isGranted = await _requestStoragePermission();

//     if (isGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//       );

//       if (result != null) {
//         setState(() {
//           _qualificationFileName = result.files.single.name;
//           _qualificationFile = File(result.files.single.path!);
//         });
//       }
//     } else {
//       _showPermissionDeniedDialog();
//     }
//   }

//   // Request storage permission
//   Future<bool> _requestStoragePermission() async {
//     if (await Permission.storage.isGranted) {
//       return true; // Access is already granted
//     }

//     // Handle for Android 11 and above
//     if (await Permission.manageExternalStorage.isGranted) {
//       return true;
//     }

//     // For Android 10 and below
//     if (await Permission.storage.request().isGranted) {
//       return true;
//     }

//     // Handle Manage External Storage for Android 11 and above
//     if (await Permission.manageExternalStorage.request().isGranted) {
//       return true;
//     }

//     return false; // Permission denied
//   }

//   // Show a dialog if permission is denied
//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Permission Denied"),
//         content: Text(
//             "Storage permission is required to pick a file. Please enable it in the app settings."),
//         actions: [
//           TextButton(
//             child: Text("Cancel"),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: Text("Open Settings"),
//             onPressed: () {
//               openAppSettings();
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<int?> _storeQualification() async {
//     final user = Supabase.instance.client.auth.currentUser;

//     print("User ID: ${user?.id}");
//     print("Education Level: ${educationLevelController.text}");
//     print("Institute Name: ${instituteNameController.text}");

//     if (user != null &&
//         educationLevelController.text.isNotEmpty &&
//         instituteNameController.text.isNotEmpty) {
//       try {
//         final response =
//             await Supabase.instance.client.from('qualification').insert({
//           'education_level': educationLevelController.text,
//           'institute_name': instituteNameController.text,
//           'user_id': user.id,
//         }).select(); // Use `select` to fetch the inserted row's data.

//         if (response.isNotEmpty) {
//           // Return the ID of the inserted row
//           return response.first['id'] as int;
//         }
//       } catch (e) {
//         print("Error storing qualification: $e");
//       }
//     } else {
//       print("Please fill all fields.");
//     }
//     return null; // Return null if there's an error or missing fields
//   }

//   Future<void> uploadFileToSupabase(File file, int qualificationId) async {
//     try {
//       // Upload the file to Supabase storage
//       final response = await Supabase.instance.client.storage
//           .from('qualification_docs') // Replace with your actual bucket name
//           .upload('public/${file.path.split('/').last}', file);

//       // Get the public URL for the uploaded file
//       final fileUrl = Supabase.instance.client.storage
//           .from('qualification_docs')
//           .getPublicUrl('public/${file.path.split('/').last}');

//       print("File uploaded successfully: $fileUrl"); // Log the file URL
//       await updateQualificationUrl(fileUrl, qualificationId);
//     } catch (e) {
//       print("Error uploading file: $e"); // Handle errors
//     }
//   }

//   Future<void> updateQualificationUrl(
//       String fileUrl, int qualificationId) async {
//     try {
//       final response = await Supabase.instance.client
//           .from('qualification') // Change table to 'qualification'
//           .update({
//             'qualification_url': fileUrl
//           }) // Update 'qualification_url' column
//           .eq('id', qualificationId) // Match the specific row by its ID
//           .select();

//       if (response.isNotEmpty) {
//         print("Qualification URL updated successfully: $response");
//       } else {
//         print("No rows updated. Verify ID or table setup.");
//       }
//     } catch (e) {
//       print("Error in updating qualification record: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double screenWidth = constraints.maxWidth;

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Add Qualification',
//                     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),

//                   // Education Level label
//                   TextField(
//                     controller: educationLevelController,
//                     decoration: InputDecoration(
//                       labelText: 'Education Level',
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       hintText: 'Ex. Matric',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                     ),
//                     keyboardAppearance: Brightness.light,
//                   ),
//                   const SizedBox(height: 15),

//                   // Institute Name label
//                   TextField(
//                     controller: instituteNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Institute Name',
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       hintText: 'Ex. IMCB',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                     ),
//                     keyboardAppearance: Brightness.light,
//                   ),
//                   const SizedBox(height: 40),

//                   // Upload Proof Of Qualification Section
//                   Container(
//                     width: 330,
//                     height: 210,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.grey,
//                         width: 1.0,
//                       ),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(3.0),
//                           child: Text(
//                             'Upload Proof Of Qualification',
//                             style: TextStyle(
//                                 fontSize: 22, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 3.0),
//                           child: Text(
//                             'Degree/Marksheet/Certificate',
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         ),
//                         const SizedBox(height: 7),

//                         // Inside container
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: InkWell(
//                             onTap: _pickQualificationFile,
//                             child: Container(
//                               width: double.infinity,
//                               height: 130,
//                               child: CustomPaint(
//                                 painter: DashedBorderPainter(),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Icon(
//                                       Icons.cloud_upload,
//                                       size: 50,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(height: 16),
//                                     Text(
//                                       _qualificationFileName ?? 'Tap to upload',
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       _qualificationFileName == null
//                                           ? '*pdf accepted'
//                                           : 'Tap to upload another document',
//                                       style: TextStyle(
//                                           fontSize: 12, color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 70),

//                   // Another Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // Store the qualification data and get the ID of the inserted qualification record
//                         final qualificationId = await _storeQualification();

//                         if (qualificationId != null &&
//                             _qualificationFile != null) {
//                           // Upload the file to Supabase storage and get the URL
//                           await uploadFileToSupabase(
//                               _qualificationFile!, qualificationId);
//                         }

//                         // Clear the fields after adding the qualification
//                         educationLevelController.clear();
//                         instituteNameController.clear();
//                         setState(() {
//                           _qualificationFileName = null;
//                           _qualificationFile = null;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         'Add Another +',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Next Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         final qualificationId =
//                             await _storeQualification(); // Store qualification and get the row ID

//                         if (qualificationId != null &&
//                             _qualificationFile != null) {
//                           await uploadFileToSupabase(_qualificationFile!,
//                               qualificationId); // Upload the file for this specific qualification
//                         }

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TeachingDetail(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xff87e64c),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         'Next',
//                         style: TextStyle(fontSize: 18, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// extension on PostgrestList {
//   get error => null;
// }

// class DashedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     const dashWidth = 7.0;
//     const dashSpace = 4.0;
//     double startX = 0.0;

//     // Draw top border
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, 0),
//         Offset(startX + dashWidth, 0),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }

//     // Draw right border
//     double startY = 0.0;
//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(size.width, startY),
//         Offset(size.width, startY + dashWidth),
//         paint,
//       );
//       startY += dashWidth + dashSpace;
//     }

//     // Draw bottom border
//     startX = 0.0;
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, size.height),
//         Offset(startX + dashWidth, size.height),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }

//     // Draw left border
//     startY = 0.0;
//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(0, startY),
//         Offset(0, startY + dashWidth),
//         paint,
//       );
//       startY += dashWidth + dashSpace;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'teaching_detail.dart';

class QualificationScreen extends StatefulWidget {
  @override
  _QualificationScreenState createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  final TextEditingController educationLevelController =
      TextEditingController();
  final TextEditingController instituteNameController = TextEditingController();
  String? _qualificationFileName;
  File? _qualificationFile;

  // Function to pick the qualification file (PDF)
  Future<void> _pickQualificationFile() async {
    bool isGranted = await _requestStoragePermission();

    if (isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _qualificationFileName = result.files.single.name;
          _qualificationFile = File(result.files.single.path!);
        });
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true; // Access is already granted
    }

    // Handle for Android 11 and above
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // For Android 10 and below
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    // Handle Manage External Storage for Android 11 and above
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }

    return false; // Permission denied
  }

  // Show a dialog if permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text(
            "Storage permission is required to pick a file. Please enable it in the app settings."),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Open Settings"),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Function to check if the qualification step is already completed
  Future<bool> _isQualificationStepCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('qualification')
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null && response['qualification'] == true) {
          print("Qualification step is already completed.");
          return true;
        } else {
          print("Qualification step is not completed.");
        }
      } catch (e) {
        print("Error checking qualification step status: $e");
      }
    }
    return false;
  }

  // Store the qualification details in Supabase
  Future<int?> _storeQualification() async {
    final user = Supabase.instance.client.auth.currentUser;

    print("User ID: ${user?.id}");
    print("Education Level: ${educationLevelController.text}");
    print("Institute Name: ${instituteNameController.text}");

    if (user != null &&
        educationLevelController.text.isNotEmpty &&
        instituteNameController.text.isNotEmpty) {
      try {
        final response =
            await Supabase.instance.client.from('qualification').insert({
          'education_level': educationLevelController.text,
          'institute_name': instituteNameController.text,
          'user_id': user.id,
        }).select(); // Use `select` to fetch the inserted row's data.

        if (response.isNotEmpty) {
          // Return the ID of the inserted row
          return response.first['id'] as int;
        }
      } catch (e) {
        print("Error storing qualification: $e");
      }
    } else {
      print("Please fill all fields.");
    }
    return null; // Return null if there's an error or missing fields
  }

  // Upload the qualification document to Supabase
  Future<void> uploadFileToSupabase(File file, int qualificationId) async {
    try {
      // Upload the file to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('qualification_docs') // Replace with your actual bucket name
          .upload('public/${file.path.split('/').last}', file);

      // Get the public URL for the uploaded file
      final fileUrl = Supabase.instance.client.storage
          .from('qualification_docs')
          .getPublicUrl('public/${file.path.split('/').last}');

      print("File uploaded successfully: $fileUrl"); // Log the file URL
      await updateQualificationUrl(fileUrl, qualificationId);
    } catch (e) {
      print("Error uploading file: $e"); // Handle errors
    }
  }

  // Update the qualification URL in the Supabase qualification table
  Future<void> updateQualificationUrl(
      String fileUrl, int qualificationId) async {
    try {
      final response = await Supabase.instance.client
          .from('qualification') // Change table to 'qualification'
          .update({
            'qualification_url': fileUrl
          }) // Update 'qualification_url' column
          .eq('id', qualificationId) // Match the specific row by its ID
          .select();

      if (response.isNotEmpty) {
        print("Qualification URL updated successfully: $response");
      } else {
        print("No rows updated. Verify ID or table setup.");
      }
    } catch (e) {
      print("Error in updating qualification record: $e");
    }
  }

  // Update profile completion steps to mark qualification step as completed
  Future<void> _updateProfileCompletionSteps(String userId) async {
    try {
      // Check if a row already exists for the user
      final response = await Supabase.instance.client
          .from('profile_completion_steps')
          .select()
          .eq('user_id', userId)
          .maybeSingle(); // Fetch a single row if it exists

      if (response != null) {
        // Update the existing row
        await Supabase.instance.client.from('profile_completion_steps').update({
          'qualification': true
        }) // Mark the qualification column as true
            .eq('user_id', userId);
        print("Qualification step updated successfully for existing row.");
      } else {
        // Insert a new row if it doesn't exist
        await Supabase.instance.client.from('profile_completion_steps').insert({
          'user_id': userId,
          'qualification': true, // Mark qualification as completed
        });
        print("New row created with qualification step completed.");
      }
    } catch (e) {
      print("Error updating profile completion steps: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Check if location step is already completed and restrict access
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isQualificationStepCompleted()) {
        final completionData =
            await ProfileCompletionHelper.fetchCompletionData();
        final incompleteSteps =
            ProfileCompletionHelper.getIncompleteSteps(completionData);
        ProfileCompletionHelper.navigateToNextScreen(context, incompleteSteps);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Qualification',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Education Level label
                  TextField(
                    controller: educationLevelController,
                    decoration: InputDecoration(
                      labelText: 'Education Level',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Ex. Matric',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                  const SizedBox(height: 15),

                  // Institute Name label
                  TextField(
                    controller: instituteNameController,
                    decoration: InputDecoration(
                      labelText: 'Institute Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Ex. IMCB',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                  const SizedBox(height: 40),

                  // Upload Proof Of Qualification Section
                  Container(
                    width: 330,
                    height: 210,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            'Upload Proof Of Qualification',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            'Degree/Marksheet/Certificate',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 7),

                        // Inside container
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: _pickQualificationFile,
                            child: Container(
                              width: double.infinity,
                              height: 130,
                              child: CustomPaint(
                                painter: DashedBorderPainter(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      _qualificationFileName ?? 'Tap to upload',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _qualificationFileName == null
                                          ? '*pdf accepted'
                                          : 'Tap to upload another document',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),

                  // Another Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Store the qualification data and get the ID of the inserted qualification record
                        final qualificationId = await _storeQualification();

                        if (qualificationId != null &&
                            _qualificationFile != null) {
                          // Upload the file to Supabase storage and get the URL
                          await uploadFileToSupabase(
                              _qualificationFile!, qualificationId);

                          final userId =
                              Supabase.instance.client.auth.currentUser?.id;

                          if (userId != null) {
                            // Update profile completion steps for this user
                            await _updateProfileCompletionSteps(userId);

                            // Check if the qualification step is marked as complete for the user
                            final isQualificationCompleted =
                                await _isQualificationStepCompleted();

                            if (isQualificationCompleted) {
                              // Qualification is completed, you can show a confirmation or just keep adding
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Qualification added successfully.")),
                              );
                            }
                          }
                        }

                        // Clear the fields after adding the qualification
                        educationLevelController.clear();
                        instituteNameController.clear();
                        setState(() {
                          _qualificationFileName = null;
                          _qualificationFile = null;
                        });
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add Another +',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final qualificationId =
                            await _storeQualification(); // Store qualification and get the row ID

                        if (qualificationId != null &&
                            _qualificationFile != null) {
                          // Upload the file for this specific qualification
                          await uploadFileToSupabase(
                              _qualificationFile!, qualificationId);

                          final userId =
                              Supabase.instance.client.auth.currentUser?.id;

                          if (userId != null) {
                            // Only update profile completion steps when the user explicitly presses the button
                            await _updateProfileCompletionSteps(userId);

                            // Ensure that the qualification step is completed before navigating
                            final isQualificationCompleted =
                                await _isQualificationStepCompleted();

                            // Check if the qualification step is truly completed, and navigate if so
                            if (isQualificationCompleted) {
                              // Navigate to the next screen after updating the profile
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeachingDetail()),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff87e64c),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on PostgrestList {
  get error => null;
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 7.0;
    const dashSpace = 4.0;
    double startX = 0.0;

    // Draw top border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw right border
    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw bottom border
    startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw left border
    startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
