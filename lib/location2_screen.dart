import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newifchaly/location_screen.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cnic_screen.dart';

class Location2Screen extends StatefulWidget {
  @override
  _Location2ScreenState createState() => _Location2ScreenState();
}

class _Location2ScreenState extends State<Location2Screen> {
  File? _image;
  String? _imageUrl;

  // Function to check if the image step is already completed
  Future<bool> _isImageStepCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('image')
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null && response['image'] == true) {
          print("Image step is already completed.");
          return true;
        } else {
          print("Image step is not completed.");
        }
      } catch (e) {
        print("Error checking image step status: $e");
      }
    }
    return false;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File imageFile = File(image.path);

      // Check file size
      final int fileSize = await imageFile.length();
      const int maxFileSize = 1048576;

      if (fileSize > maxFileSize) {
        print(
            "The selected file is too large. Please choose a file smaller than 1 MB.");
        showCustomSnackBar(context,
            "The selected file is too large. Please choose a file smaller than 1 MB.");
      } else {
        setState(() {
          _image = imageFile;
        });
      }
    }
  }

  // Method to upload image and update database
  Future<bool> _uploadImage() async {
    if (_image == null) {
      showCustomSnackBar(context, "PLease select image");

      return false;
    }
    try {
      final file = _image!;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        print("User not logged in.");
        showCustomSnackBar(context, "User not logged in");

        return false;
      }
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '$timestamp-${file.path.split('/').last}';
      final id = user.id;

      final storageResponse = await Supabase.instance.client.storage
          .from('user_img')
          .upload('$id/$filename', file);

      final imageUrl = Supabase.instance.client.storage
          .from('user_img')
          .getPublicUrl('$id/$filename');

      setState(() {
        _imageUrl = imageUrl;
      });

      print("Image uploaded successfully: $_imageUrl");

      await _updateUserImageUrl(imageUrl);
      await _updateProfileCompletionSteps(user.id);
      return true;
    } catch (e) {
      print("Error uploading image: $e");
      showCustomSnackBar(
          context, "Technical error occured, please try after a while");
      return false;
    }
  }

  // Update the user's image URL in the users table
  Future<void> _updateUserImageUrl(String imageUrl) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print("User ID is null.");
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .update({'image_url': imageUrl})
          .eq('id', userId)
          .select();

      if (response.isNotEmpty) {
        print("Image URL updated successfully.");
      } else {
        print("No rows updated. Verify user ID or table setup.");
      }
    } catch (e) {
      print("Error updating user record: $e");
    }
  }

  // Update profile completion steps to mark image step as completed
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
        await Supabase.instance.client
            .from('profile_completion_steps')
            .update({'image': true}) // Mark the image column as true
            .eq('user_id', userId);
        print("Image step updated successfully for existing row.");
      } else {
        // Insert a new row if it doesn't exist
        await Supabase.instance.client.from('profile_completion_steps').insert({
          'user_id': userId,
          'image': true, // Mark image as completed
        });
        print("New row created with image step completed.");
      }
    } catch (e) {
      print("Error updating profile completion steps: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isImageStepCompleted()) {
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
                    'Upload your image',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
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
            Center(
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(100),
                child: Ink(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 165,
                            height: 165,
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 36,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to upload',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
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
                  bool isImageUploaded = await _uploadImage();
                  if (isImageUploaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationScreen()),
                    );
                  }
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
