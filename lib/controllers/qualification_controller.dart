import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/qualification_model.dart';

class QualificationController extends GetxController {
  // Instance of QualificationModel
  final QualificationModel qualification = QualificationModel();

  // Function to check if the location step is already completed
  Future<bool> isQualificationCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        // Check if location is marked true in the profile_completion_steps table
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('qualification')
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null && response['qualification'] == true) {
          print("Qualification step is already completed.");
          return true; // Step is already completed
        } else {
          print("Qualification step is not completed.");
        }
      } catch (e) {
        print("Error checking location status: $e");
      }
    }
    return false; // Step is not completed
  }

  // Function to pick the qualification file (PDF)
  Future<void> pickQualificationFile(BuildContext context) async {
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
        

        qualification.qualificationFileName.value = result.files.single.name;
        qualification.qualificationFile.value = File(result.files.single.path!);
      }
    } else {
      showPermissionDeniedDialog();
    }
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true; // Access is already granted
    }

    if (await Permission.manageExternalStorage.isGranted) {
      return true; // For Android 11 and above
    }

    if (await Permission.storage.request().isGranted) {
      return true; // For Android 10 and below
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      return true; // Manage External Storage for Android 11 and above
    }

    return false; // Permission denied
  }

  // Show a dialog if permission is denied
  void showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text(
            "Storage permission is required to pick a file. Please enable it in the app settings."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              openAppSettings();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // Function to store qualification in Supabase
  Future<int?> storeQualification(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;

    print("User ID: ${user?.id}");
    print("Education Level: ${qualification.educationLevel.value}");
    print("Institute Name: ${qualification.instituteName.value}");

    if (user != null &&
        qualification.educationLevel.value.isNotEmpty &&
        qualification.instituteName.value.isNotEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('qualification')
            .insert({
          'education_level': qualification.educationLevel.value,
          'institute_name': qualification.instituteName.value,
          'user_id': user.id,
        }).select();

        if (response.isNotEmpty) {
          
          await Supabase.instance.client
              .from('profile_completion_steps')
              .update({'qualification': true}).eq('user_id', user.id);
          print("Qualification step updated successfully.");
          return response.first['id'] as int; // Return the inserted row ID

        }
        
      } catch (e) {
        print("Error storing qualification: $e");
        showCustomSnackBar( context, "Error Storing Qualification, Try Again");
      }
    } else {
      print("Please fill all fields.");
      showCustomSnackBar( context, "Please Fill All Feilds");
    }
    return null; // Return null if there's an error or missing fields
  }

  // Function to upload the file to Supabase storage
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

  // Function to update the qualification URL in the database
  Future<void> updateQualificationUrl(
      String fileUrl, int qualificationId) async {
    try {
      final response = await Supabase.instance.client
          .from('qualification')
          .update({
            'qualification_url': fileUrl,
          })
          .eq('id', qualificationId)
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
}
