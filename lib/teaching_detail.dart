import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> _storeExperiencen() async {
    final user = Supabase.instance.client.auth.currentUser;
    final educationLevel = _educationLevelController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final stillWorking = _switchValue;

    if (user != null &&
        _educationLevelController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty) {
      try {
        final response =
            await Supabase.instance.client.from('experience').insert({
          'student_education_level': educationLevel,
          'start_date': startDate,
          'end_date': endDate.isEmpty ? null : endDate,
          'user_id': user.id,
          'still_working': stillWorking,
        }).select();
      } catch (e) {
        print("Error storing experience: $e");
      }
    } else {
      print("Please fill all fields.");
    }
  }

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

  Future<void> uploadFileToSupabase(File file) async {
    try {
      // Upload the file to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('experience_docs') // Replace with your actual bucket name
          .upload('public/${file.path.split('/').last}', file);

      // Get the public URL for the uploaded file
      final fileUrl = Supabase.instance.client.storage
          .from('experience_docs')
          .getPublicUrl('public/${file.path.split('/').last}');

      print("File uploaded successfully: $fileUrl"); // Log the file URL
    } catch (e) {
      print("Error uploading file: $e"); // Handle errors
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
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Teaching Experience',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // TextField for Education level
                  TextField(
                    controller: _educationLevelController,
                    decoration: InputDecoration(
                      labelText: 'Education Level of Students',
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

                  // TextField for selecting start date
                  TextField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Select Start Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.grey),
                        onPressed: () =>
                            _selectDate(context, _startDateController),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                  const SizedBox(height: 20),

                  // TextField for selecting end date
                  TextField(
                    controller: _endDateController,
                    readOnly: true,
                    enabled:
                        !_switchValue, // Disable when "I Still Work Here" is active
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Select End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.grey),
                        onPressed: !_switchValue
                            ? () => _selectDate(context, _endDateController)
                            : null,
                      ),
                      filled: _switchValue,
                      fillColor: _switchValue
                          ? const Color(0xff87e64c).withOpacity(0.4)
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: TextStyle(
                      color: _switchValue
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
                            onTap: _pickQualificationFile,
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeachingDetail()),
                        );
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
                  const SizedBox(height: 5),

                  // "Submit For Verification"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // Inside `onPressed` function of 'Submit For Verification' button
                      onPressed: () async {
                        await uploadFileToSupabase(_teachingDetailFile!);
                        _storeExperiencen();
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
