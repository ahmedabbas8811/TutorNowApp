import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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

  Future<void> _pickFile() async {
    // Check and request permissions
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

  // Function to handle permission requests
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

  Future<void> uploadFileToSupabase(File file) async {
    try {
      // Upload the file to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('cnic') // Replace with your actual bucket name
          .upload('public/${file.path.split('/').last}', file);

      // Get the public URL for the uploaded file
      final fileUrl = Supabase.instance.client.storage
          .from('cnic')
          .getPublicUrl('public/${file.path.split('/').last}');

      print("File uploaded successfully: $fileUrl"); // Log the file URL
    } catch (e) {
      print("Error uploading file: $e"); // Handle errors
    }
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
            const Text(
              'Upload CNIC',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Clickable Container with a dashed border
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
                                ? '*pdf accepted'
                                : 'Tap to upload another document',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
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
                  if (_cnicFile != null) {
                    await uploadFileToSupabase(
                        _cnicFile!); // Upload the file if it is selected
                  }
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

    // Top border
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
