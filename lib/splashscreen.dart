import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:newifchaly/admin/controllers/tutor_controller.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/blocked_account_screen.dart';
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

      final userId = session.user!.id;
      print("User ID: $userId");

      // Fetch both status and user_type in single query
      final userData = await SupabaseService.supabase
          .from('users')
          .select('status, user_type')
          .eq('id', userId)
          .single();

      // First check if user is blocked
      if (userData['status'] == 'blocked') {
        print("User is blocked, redirecting to blocked account screen...");
        Get.offAll(() => const BlockedAccountScreen());
        return;
      }

      // Then check user type if not blocked
      if (userData['user_type'] != null) {
        final userType = userData['user_type'];
        print("User type: $userType");

        if (userType == 'Admin') {
          Get.lazyPut(() => TutorController());
          Get.offAll(() => const HomeAdmin());
        } else if (userType == 'Student' || userType == 'Parent') {
          Get.offAll(() => StudentHomeScreen());
        } else if (userType == 'Tutor') {
          Get.offAll(() => ProfileScreen());
        } else {
          print("Unknown user type, redirecting to login...");
          Get.offAll(() => LoginScreen());
        }
      } else {
        print("User type is null, redirecting to login...");
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
