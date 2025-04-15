import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:newifchaly/admin/controllers/tutor_controller.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/storage_service.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'dart:developer';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    print("Starting splash sequence...");

    // Delay to show the splash screen for at least 3 seconds
    await Future.delayed(const Duration(seconds: 4));

    // Fetch the user type and handle redirection
    await _fetchUserTypeAndRedirect();
  }

  Future<void> _fetchUserTypeAndRedirect() async {
    try {
      print("Fetching session...");
      final session = StorageService.getUserSession;

      if (session == null || session.user == null || session.user!.id == null) {
        print("Session is null or invalid, redirecting to login...");
        Get.offAll(() => LoginScreen());
        return;
      }

      final userId = session.user!.id; // Retrieve userId from the session
      print("User ID: $userId");

      // Fetch user type from the database
      final user = await SupabaseService.supabase
          .from('users')
          .select('user_type')
          .eq('id', userId)
          .single();
      print("User data: $user");

      if (user != null && user['user_type'] != null) {
        final userType = user['user_type'];
        print("User type: $userType");

        // Redirect based on user type
        if (userType == 'Admin') {
          Get.lazyPut(() => TutorController()); // Initialize the controller
          Get.offAll(() => const HomeAdmin());
        } else if (userType == 'Student') {
          Get.offAll(() => StudentHomeScreen());
        } else if (userType == 'Tutor') {
          Get.offAll(() => ProfileScreen());
        } else {
          print("Unknown user type, redirecting to login...");
          Get.offAll(() => LoginScreen());
        }
      } else {
        print("User not found or user type is null, redirecting to login...");
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      log("Error fetching user type: $e");
      Get.snackbar("Error", "Failed to load user data.");
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animation2.json',
          repeat: true,
          animate: true,
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
