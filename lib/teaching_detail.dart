// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'Profile_Verification_screen.dart';

// class TeachingDetail extends StatefulWidget {
//   @override
//   _TeachingDetailState createState() => _TeachingDetailState();
// }

// class _TeachingDetailState extends State<TeachingDetail> {
//   bool _switchValue = false; // Checks whether switch is on or off
//   TextEditingController _startDateController = TextEditingController();
//   TextEditingController _endDateController = TextEditingController();
//   TextEditingController _educationLevelController = TextEditingController();
//   String? _qualificationFileName;
//   File? _teachingDetailFile;

//   // Function to show a date picker and set the selected date in TextEditingController
//   Future<void> _selectDate(
//       BuildContext context, TextEditingController controller) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       // Format the picked date and set it in the controller
//       setState(() {
//         controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//       });
//     }
//   }

//   Future<int?> _storeExperience() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     final educationLevel = _educationLevelController.text;
//     final startDate = _startDateController.text;
//     final endDate = _endDateController.text;
//     final stillWorking = _switchValue;

//     if (user != null &&
//         _educationLevelController.text.isNotEmpty &&
//         _startDateController.text.isNotEmpty) {
//       try {
//         final response =
//             await Supabase.instance.client.from('experience').insert({
//           'student_education_level': educationLevel,
//           'start_date': startDate,
//           'end_date': endDate.isEmpty ? null : endDate,
//           'user_id': user.id,
//           'still_working': stillWorking,
//         }).select();

//         // Check if the response is not empty and return the inserted row's ID
//         if (response.isNotEmpty) {
//           final experienceId =
//               response[0]['id']; // Assuming 'id' is the primary key column
//           return experienceId;
//         }
//       } catch (e) {
//         print("Error storing experience: $e");
//       }
//     } else {
//       print("Please fill all fields.");
//     }
//     return null;
//   }

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
//           _teachingDetailFile = File(result.files.single.path!);
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

//   Future<void> uploadFileToSupabase(File file, int experienceId) async {
//     try {
//       // Upload the file to Supabase storage
//       final response = await Supabase.instance.client.storage
//           .from('experience_docs') // Replace with your actual bucket name
//           .upload('public/${file.path.split('/').last}', file);

//       // Get the public URL for the uploaded file
//       final fileUrl = Supabase.instance.client.storage
//           .from('experience_docs')
//           .getPublicUrl('public/${file.path.split('/').last}');

//       print("File uploaded successfully: $fileUrl"); // Log the file URL
//       await updateExperienceUrl(fileUrl, experienceId);
//     } catch (e) {
//       print("Error uploading file: $e"); // Handle errors
//     }
//   }

//   Future<void> updateExperienceUrl(String fileUrl, int experienceId) async {
//     try {
//       final response = await Supabase.instance.client
//           .from('experience') // Change table to 'experience'
//           .update({
//             'experience_url': fileUrl, // Update 'experience_url' column
//           })
//           .eq('id', experienceId) // Match the specific row by its ID
//           .select();

//       if (response.isNotEmpty) {
//         print("Experience URL updated successfully: $response");
//       } else {
//         print("No rows updated. Verify ID or table setup.");
//       }
//     } catch (e) {
//       print("Error in updating experience record: $e");
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose TextEditingControllers when this widget is destroyed
//     _startDateController.dispose();
//     _endDateController.dispose();
//     super.dispose();
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
//             Navigator.pop(context); // Go back to the previous screen
//           },
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Add Teaching Experience',
//                     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),

//                   // TextField for Education level
//                   TextField(
//                     controller: _educationLevelController,
//                     decoration: InputDecoration(
//                       labelText: 'Education Level of Students',
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

//                   // TextField for selecting start date
//                   TextField(
//                     controller: _startDateController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Start Date',
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       hintText: 'Select Start Date',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today,
//                             color: Colors.grey),
//                         onPressed: () =>
//                             _selectDate(context, _startDateController),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                     ),
//                     keyboardAppearance: Brightness.light,
//                   ),
//                   const SizedBox(height: 20),

//                   // TextField for selecting end date
//                   TextField(
//                     controller: _endDateController,
//                     readOnly: true,
//                     enabled:
//                         !_switchValue, // Disable when "I Still Work Here" is active
//                     decoration: InputDecoration(
//                       labelText: 'End Date',
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       hintText: 'Select End Date',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today,
//                             color: Colors.grey),
//                         onPressed: !_switchValue
//                             ? () => _selectDate(context, _endDateController)
//                             : null,
//                       ),
//                       filled: _switchValue,
//                       fillColor: _switchValue
//                           ? const Color(0xff87e64c).withOpacity(0.4)
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                     ),
//                     style: TextStyle(
//                       color: _switchValue
//                           ? Colors.grey.withOpacity(0.5)
//                           : Colors.black,
//                     ),
//                     keyboardAppearance: Brightness.light,
//                   ),
//                   const SizedBox(height: 5),

//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const Text("I Still Work Here",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         CupertinoSwitch(
//                           value: _switchValue,
//                           activeColor: const Color(0xff87e64c),
//                           onChanged: (value) {
//                             setState(() {
//                               _switchValue = value;
//                               if (value)
//                                 _endDateController
//                                     .clear(); // Clear end date if switch is on
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 2),

//                   // Container for uploading proof of qualification
//                   Container(
//                     width: 330,
//                     height: 210,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey, width: 1.0),
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

//                         // Inner container for upload PDF
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: InkWell(
//                             onTap: _pickQualificationFile,
//                             child: Container(
//                               width: double.infinity,
//                               height: 130,
//                               child: CustomPaint(
//                                 painter:
//                                     DashedBorderPainter(), // Custom painter for dashed border
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.cloud_upload,
//                                       size: 50,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(height: 16),
//                                     Text(
//                                       'Tap to upload',
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       '*pdf accepted',
//                                       style: TextStyle(
//                                           fontSize: 12, color: Colors.grey),
//                                     ),
//                                     if (_qualificationFileName != null)
//                                       Text(_qualificationFileName!,
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.green)),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // Store the experience data and get the ID of the inserted experience record
//                         final experienceId = await _storeExperience();

//                         if (experienceId != null &&
//                             _teachingDetailFile != null) {
//                           // Upload the file to Supabase storage and associate it with the experience
//                           await uploadFileToSupabase(
//                               _teachingDetailFile!, experienceId);
//                         }

//                         // Clear the fields after adding the experience
//                         _startDateController.clear();
//                         _endDateController.clear();
//                         _educationLevelController.clear();

//                         setState(() {
//                           _qualificationFileName = null;
//                           _teachingDetailFile = null;
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

//                   const SizedBox(height: 5),

//                   // "Submit For Verification"
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       // Inside `onPressed` function of 'Submit For Verification' button
//                       onPressed: () async {
//                         final experienceId =
//                             await _storeExperience(); // Store experience and get the row ID

//                         if (experienceId != null &&
//                             _teachingDetailFile != null) {
//                           await uploadFileToSupabase(_teachingDetailFile!,
//                               experienceId); // Upload the file for this specific experience
//                         }

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ProfileVerificationScreen(),
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
//                         'Submit For Verification',
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

// // Custom painter class for creating a dashed border
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
//     return false; // No repainting needed as border properties are static
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newifchaly/Profile_Verification_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeachingDetail extends StatefulWidget {
  @override
  _TeachingDetailState createState() => _TeachingDetailState();
}

class _TeachingDetailState extends State<TeachingDetail> {
  bool _switchValue = false; // Checks whether switch is on or off
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _educationLevelController = TextEditingController();
  String? _qualificationFileName;
  File? _teachingDetailFile;
  String? _selectedEducationLevel;

  // Function to show a date picker and set the selected date in TextEditingController
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Format the picked date and set it in the controller
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<int?> _storeTeachingExperience() async {
    final user = Supabase.instance.client.auth.currentUser;
    final educationLevel = _selectedEducationLevel;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final stillWorking = _switchValue;

    if (user != null && _teachingDetailFile!=null &&
        _startDateController.text.isNotEmpty && _selectedEducationLevel != null
        && (_endDateController.text.isNotEmpty || _switchValue )
        ) {
      try {
        final response =
            await Supabase.instance.client.from('experience').insert({
          'student_education_level': educationLevel,
          'start_date': startDate,
          'end_date': endDate.isEmpty ? null : endDate,
          'user_id': user.id,
          'still_working': stillWorking,
        }).select();

        // Check if the response is not empty and return the inserted row's ID
        if (response.isNotEmpty) {
          final teachingExperienceId =
              response[0]['id']; // Assuming 'id' is the primary key column
          return teachingExperienceId;
        }
      } catch (e) {
        print("Error storing teaching experience: $e");
        showCustomSnackBar(context, "Server error occured, try after a while");
      }
    } else {
      if(_selectedEducationLevel == null){
        showCustomSnackBar(context, "Please select student education level");
        return null;
      }
      else if(_startDateController.text.isEmpty){
         showCustomSnackBar(context, "Please enter start date");
        return null;
      }
      else if (_endDateController.text.isEmpty && !stillWorking){
        showCustomSnackBar(context, "Either enter end date or mark as still working");
        return null;
      }
      print("Please upload proof of qualification");
      showCustomSnackBar(context, "Please upload proof of qualification");
    }
    return null;
  }

  // Function to pick the qualification file (PDF)
  Future<void> _pickTeachingFile() async {
    bool isGranted = await _requestStoragePermission();

    if (isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
         final fileSize = result!.files.single.size ;
    const maxFileSize = 5242880;
        if(fileSize>maxFileSize){
          
          showCustomSnackBar(context, "Max file size is 5mb");
          print("size is greater then 5 mb");
          return;
        }
        setState(() {
          _qualificationFileName = result.files.single.name;
          _teachingDetailFile = File(result.files.single.path!);
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

  Future<void> _uploadTeachingFileToSupabase(File file, int teachingId) async {
    try {
      final id = Supabase.instance.client.auth.currentUser!.id;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '$timestamp-${file.path.split('/').last}';
      // Upload the file to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('experience_docs') // Replace with your actual bucket name
          .upload('$id/$filename', file);

      // Get the public URL for the uploaded file
      final fileUrl = Supabase.instance.client.storage
          .from('experience_docs')
          .getPublicUrl('$id/$filename');

      print("File uploaded successfully: $fileUrl"); // Log the file URL
      await _updateTeachingExperienceUrl(fileUrl, teachingId);
    } catch (e) {
      print("Error uploading file: $e"); // Handle errors
    }
  }

  Future<void> _updateTeachingExperienceUrl(
      String fileUrl, int teachingId) async {
    try {
      final response = await Supabase.instance.client
          .from('experience') // Change table to 'experience'
          .update({
            'experience_url': fileUrl, // Update 'teaching_url' column
          })
          .eq('id', teachingId) // Match the specific row by its ID
          .select();

      if (response.isNotEmpty) {
        print("Teaching URL updated successfully: $response");
      } else {
        print("No rows updated. Verify ID or table setup.");
      }
    } catch (e) {
      print("Error in updating teaching record: $e");
    }
  }

  Future<bool> _isTeachingStepCompleted() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('exp')
            .eq('user_id', user.id)
            .maybeSingle();

        return response != null && response['exp'] == true;
      }
    } catch (e) {
      print("Error checking teaching step completion: $e");
    }
    return false;
  }

  Future<void> _updateProfileCompletionSteps(String userId) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('profile_completion_steps').update({
          'exp': true,
        }).eq('user_id', user.id);
        print("Profile steps updated successfully.");
      }
    } catch (e) {
      print("Error updating profile completion steps: $e");
    }
  }

  @override
  void dispose() {
    // Dispose TextEditingControllers when this widget is destroyed
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Check if location step is already completed and restrict access
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isTeachingStepCompleted()) {
        // Navigate to the next screen if the step is already completed
//        Navigator.pushReplacement(
        //        context,
        //      MaterialPageRoute(builder: (context) => Location2Screen()),
        //  );
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
    
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25,),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: const Text(
                          'Add Teaching Experience',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
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
                  const SizedBox(height: 15),

                  // TextField for Education level
                 // Education Level Input
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Education Level Of Students',
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: 'Ex. Under Matric',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        ),
                        dropdownColor: Colors.grey[100],
                        
                        value:
                            _selectedEducationLevel,
                        items: [
                          'Under Matric',
                          'Matric',
                          'Intermediate',
                          'Bachelors',
                          'Masters',
                          'PhD'
                        ].map((level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _selectedEducationLevel = value;
                          }
                        },
                      ),
                    ),
                  ),


const SizedBox(height: 15),


                  // TextField for selecting start date
                TextField(
  controller: _startDateController,
  readOnly: true,
  decoration: InputDecoration(
    labelText: 'Start Date',
    labelStyle: const TextStyle(color: Colors.grey),
    hintText: 'Select Start Date',
    suffixIcon: IconButton(
      icon: const Icon(Icons.calendar_today, color: Colors.grey),
      onPressed: () => _selectDate(context, _startDateController),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),  // Grey border when enabled
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),  // Grey border when focused
    ),
  ),
  keyboardAppearance: Brightness.light,
),
const SizedBox(height: 20),


                  // TextField for selecting end date
                TextField(
  controller: _endDateController,
  readOnly: true,
  enabled: !_switchValue, // Disable when "I Still Work Here" is active
  decoration: InputDecoration(
    labelText: 'End Date',
    labelStyle: const TextStyle(color: Colors.grey),
    hintText: 'Select End Date',
    suffixIcon: IconButton(
      icon: const Icon(Icons.calendar_today, color: Colors.grey),
      onPressed: !_switchValue
          ? () => _selectDate(context, _endDateController)
          : null,
    ),
    filled: _switchValue,
    fillColor: _switchValue
        // ignore: deprecated_member_use
        ? const Color(0xff87e64c).withOpacity(0.4)
        : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey), // Grey border when enabled
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey), // Grey border when focused
    ),
  ),
  style: TextStyle(
    color: _switchValue
        // ignore: deprecated_member_use
        ? Colors.grey.withOpacity(0.5)
        : Colors.black,
  ),
  keyboardAppearance: Brightness.light,
),
const SizedBox(height: 5),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("I Still Work Here",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        CupertinoSwitch(
                          value: _switchValue,
                          activeColor: const Color(0xff87e64c),
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value;
                              if (value)
                                _endDateController
                                    .clear(); // Clear end date if switch is on
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Container for uploading proof of qualification
                  Container(
                    width: 330,
                    height: 210,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
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

                        // Inner container for upload PDF
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: _pickTeachingFile,
                            child: Container(
                              width: double.infinity,
                              height: 130,
                              child: CustomPaint(
                                painter:
                                    DashedBorderPainter(), // Custom painter for dashed border
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Tap to upload',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '*pdf accepted',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    if (_qualificationFileName != null)
                                      Text(_qualificationFileName!,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Store the experience data and get the ID of the inserted experience record
                        final experienceId = await _storeTeachingExperience();

                        if (experienceId != null &&
                            _teachingDetailFile != null) {
                          // Upload the file to Supabase storage and associate it with the experience
                          await _uploadTeachingFileToSupabase(
                              _teachingDetailFile!, experienceId);

                          final userId =
                              Supabase.instance.client.auth.currentUser?.id;

                          if (userId != null) {
                            // Update profile completion steps for this user
                            await _updateProfileCompletionSteps(userId);

                            // Check if the teaching step is marked as complete for the user
                            final isTeachingStepCompleted =
                                await _isTeachingStepCompleted();

                            if (isTeachingStepCompleted) {
                              // Teaching detail is completed
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Teaching detail added successfully.")),
                              );
                            }
                          }
                        }

                        // Clear the fields after adding the experience
                        _startDateController.clear();
                        _endDateController.clear();
                        _educationLevelController.clear();

                        setState(() {
                          _qualificationFileName = null;
                          _teachingDetailFile = null;
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
                        // Store the experience data and get the ID of the inserted experience record
                        final experienceId = await _storeTeachingExperience();

                        if (experienceId != null &&
                            _teachingDetailFile != null) {
                          // Upload the file to Supabase storage and associate it with the experience
                          await _uploadTeachingFileToSupabase(
                              _teachingDetailFile!, experienceId);

                          final userId =
                              Supabase.instance.client.auth.currentUser?.id;

                          if (userId != null) {
                            // Update profile completion steps for this user
                            await _updateProfileCompletionSteps(userId);

                            // Ensure the teaching step is completed before navigating
                            final isTeachingStepCompleted =
                                await _isTeachingStepCompleted();

                            if (isTeachingStepCompleted) {
                              // Navigate to the next screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileVerificationScreen(),
                                ),
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
                        'Submit For Verification',
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

// Custom painter class for creating a dashed border
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
    return false; // No repainting needed as border properties are static
  }
}
