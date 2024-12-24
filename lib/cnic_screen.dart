// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'qualification_screen.dart';

// class CnicScreen extends StatefulWidget {
//   @override
//   _CnicScreenState createState() => _CnicScreenState();
// }

// class _CnicScreenState extends State<CnicScreen> {
//   String? _fileName;
//   File? _cnicFile;

//   Future<void> _pickFile() async {
//     // Check and request permissions
//     bool isGranted = await _requestStoragePermission();

//     if (isGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//       );

//       if (result != null) {
//         setState(() {
//           _fileName = result.files.single.name;
//           _cnicFile = File(result.files.single.path!);
//         });
//       }
//     } else {
//       _showPermissionDeniedDialog();
//     }
//   }

//   // Function to handle permission requests
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

//   // Show dialog if permission is denied
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
// // Function to upload cnic file on supabase
//   Future<void> uploadFileToSupabase(File file) async {
//     try {
//       // Upload the file to Supabase storage
//       final response = await Supabase.instance.client.storage
//           .from('cnic') // Replace with your actual bucket name
//           .upload('public/${file.path.split('/').last}', file);

//       // Get the public URL for the uploaded file
//       final fileUrl = Supabase.instance.client.storage
//           .from('cnic')
//           .getPublicUrl('public/${file.path.split('/').last}');

//       print("File uploaded successfully: $fileUrl"); // Log the file URL
//       await updateUserCnicUrl(fileUrl);
//     } catch (e) {
//       print("Error uploading file: $e"); // Handle errors
//     }
//   }
// // Function to update user cnic url in users table
//   Future<void> updateUserCnicUrl(String fileUrl) async {
//     try {
//       final userId = Supabase.instance.client.auth.currentUser?.id;

//       if (userId == null) {
//         print("User not logged in or user ID is null.");
//         return;
//       }

//       final response = await Supabase.instance.client
//           .from('users')
//           .update({'cnic_url': fileUrl})
//           .eq('id', userId)
//           .select();

//       if (response.isNotEmpty) {
//         print("CNIC URL updated successfully: $response");
//       } else {
//         print(userId);
//         print("No rows updated. Verify user ID or table setup.");
//       }
//     } catch (e) {
//       print("Error in updating user record: $e");
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
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Upload CNIC',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // Clickable Container with a dashed border
//             GestureDetector(
//               onTap: _pickFile,
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: _pickFile,
//                   child: Container(
//                     width: 350,
//                     height: 150,
//                     child: CustomPaint(
//                       painter: DashedBorderPainter(),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.upload,
//                             size: 40,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             _fileName ?? 'Tap to upload',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             _fileName == null
//                                 ? '*pdf accepted'
//                                 : 'Tap to upload another document',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),
//             const Spacer(),

//             SizedBox(
//               width: 330,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_cnicFile != null) {
//                     await uploadFileToSupabase(
//                         _cnicFile!); // Upload the file if it is selected
//                   }
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => QualificationScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff87e64c),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
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

//     // Top border
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, 0),
//         Offset(startX + dashWidth, 0),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }

//     double startY = 0.0;
//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(size.width, startY),
//         Offset(size.width, startY + dashWidth),
//         paint,
//       );
//       startY += dashWidth + dashSpace;
//     }

//     startX = 0.0;
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, size.height),
//         Offset(startX + dashWidth, size.height),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }

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
import 'qualification_screen.dart';

class CnicScreen extends StatefulWidget {
  @override
  _CnicScreenState createState() => _CnicScreenState();
}

class _CnicScreenState extends State<CnicScreen> {
  String? _fileName;
  File? _cnicFile;

  // Function to pick the CNIC file
  Future<void> _pickFile() async {
    // Request storage permission
    bool isGranted = await _requestStoragePermission();
    if (isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _cnicFile = File(result.files.single.path!);
        });
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }
    return false;
  }

  // Show dialog if permission is denied
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

  // Upload the CNIC file to Supabase
  Future<void> _uploadFile() async {
    if (_cnicFile == null) return;

    try {
      final file = _cnicFile!;
      final storageResponse = await Supabase.instance.client.storage
          .from('cnic') // CNIC bucket
          .upload('public/${file.path.split('/').last}', file);

      final fileUrl = Supabase.instance.client.storage
          .from('cnic')
          .getPublicUrl('public/${file.path.split('/').last}');
      await _updateUserCnicUrl(fileUrl);
      await _updateProfileCompletionSteps();
    } catch (e) {
      print("Error uploading file: $e");
    }
  }

  // Update CNIC URL in the user's table
  Future<void> _updateUserCnicUrl(String fileUrl) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print("User not logged in.");
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .update({'cnic_url': fileUrl})
          .eq('id', userId)
          .select();

      if (response.isNotEmpty) {
        print("CNIC URL updated successfully.");
      } else {
        print("No rows updated.");
      }
    } catch (e) {
      print("Error updating user record: $e");
    }
  }

  // Update the profile completion steps to mark the CNIC step as completed
  Future<void> _updateProfileCompletionSteps() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in.");
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profile_completion_steps')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        await Supabase.instance.client
            .from('profile_completion_steps')
            .update({'cnic': true}) // Mark CNIC step as completed
            .eq('user_id', userId);
        print("CNIC step updated successfully.");
      } else {
        await Supabase.instance.client.from('profile_completion_steps').insert({
          'user_id': userId,
          'cnic': true,
        });
        print("New row created with CNIC step completed.");
      }
    } catch (e) {
      print("Error updating profile completion steps: $e");
    }
  }

  // Function to check if the location step is already completed
  Future<bool> _isCnicCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('cnic')
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null && response['cnic'] == true) {
          print("Cnic step is already completed.");
          return true; // Step is already completed
        } else {
          print("Cnic step is not completed.");
        }
      } catch (e) {
        print("Error checking cnic status: $e");
      }
    }
    return false; // Step is not completed
  }


    @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isCnicCompleted()) {
       
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: const Text(
                    'Upload CNIC',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QualificationScreen(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.green.shade100;
                                }
                                return null; // Default behavior
                              },
                            ),
                          ),
                          child: const Text(
                            "Skip For Now",
                            style: TextStyle(
                                color: Colors.grey,
                                //  decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.underline),
                          ))
              ],
            ),
            const SizedBox(height: 20),

            // Clickable container for file upload
            GestureDetector(
              onTap: _pickFile,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _pickFile,
                  child: Container(
                    width: 350,
                    height: 150,
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.upload,
                            size: 40,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _fileName ?? 'Tap to upload',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _fileName == null
                                ? '*PDF accepted'
                                : 'Tap to upload another document',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Spacer(),

            SizedBox(
              width: 330,
              child: ElevatedButton(
                onPressed: () async {
                  await _uploadFile(); // Upload file if it is selected
                
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QualificationScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
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
  }
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

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

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
