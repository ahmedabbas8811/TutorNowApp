import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newifchaly/student/controllers/student_profile_controller.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/student/models/student_profile_model.dart';
import 'package:newifchaly/student/views/bookings.dart';
import 'package:newifchaly/student/views/search_results.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';

class EditTutorProfileScreen extends StatefulWidget {
  final StudentProfile profile;

  const EditTutorProfileScreen({super.key, required this.profile});

  @override
  _EditStudentProfileScreenState createState() => _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState extends State<EditTutorProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController cityController;

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _newImageUrl;
  bool _isImageDeleted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    cityController = TextEditingController(text: widget.profile.city);
    _newImageUrl = widget.profile.imageUrl;
  }

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomeScreen()));
          break;
        case 1:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchResults()));
          break;
        case 2:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingsScreen()));
          break;
        case 3:
          break;
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
          _isImageDeleted = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteImage() async {
    setState(() {
      _selectedImage = null;
      _newImageUrl = null;
      _isImageDeleted = true;
    });
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      if (_isImageDeleted) {
        await supabase.from('users').update({'image_url': null}).eq('id', userId);
        setState(() {
          _newImageUrl = null;
        });
      } else if (_selectedImage != null) {
        final fileExt = _selectedImage!.path.split('.').last;
        final fileName = 'profile_$userId.${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        final file = File(_selectedImage!.path);

        await supabase.storage.from('user_img').upload(fileName, file, fileOptions: FileOptions(upsert: true));

        final publicUrl = supabase.storage.from('user_img').getPublicUrl(fileName);
        await supabase.from('users').update({'image_url': publicUrl}).eq('id', userId);

        setState(() {
          _newImageUrl = publicUrl;
        });
      }

      final controller = Get.find<StudentProfileController>();
      await controller.updateUserCity(cityController.text.trim());

      showCustomSnackBar(context, 'Profile saved successfully');

    } catch (e) {
      showCustomSnackBar(context, 'Error saving profile: ${e.toString()}');
    } finally {
      setState(() => _isSaving = false);
    }

    final controller = Get.find<StudentProfileController>();
    await controller.fetchStudentProfile();
    Navigator.pop(context);
  }

  ImageProvider _getProfileImage() {
    if (_isImageDeleted) {
      return const AssetImage('assets/profile.jpg');
    }
    if (_selectedImage != null) {
      return FileImage(File(_selectedImage!.path));
    }
    if (_newImageUrl != null && _newImageUrl!.isNotEmpty) {
      return NetworkImage(_newImageUrl!);
    }
    if (widget.profile.imageUrl.isNotEmpty) {
      return NetworkImage(widget.profile.imageUrl);
    }
    return const AssetImage('assets/profile.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _getProfileImage(),
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF87E64B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.edit, color: Colors.black, size: 20),
                      ),
                    ),
                    const SizedBox(width: 0),
                    GestureDetector(
                      onTap: _deleteImage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.delete, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: buildTextField("Full Name", "Enter your full name", nameController, readOnly: true)),
                const SizedBox(width: 10),
                Expanded(child: buildTextField("City", "Enter your city", cityController)),
              ],
            ),
            const SizedBox(height: 20),
            buildTextField("Email", "Enter your email", emailController, readOnly: true),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF87E64B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      'Save',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
