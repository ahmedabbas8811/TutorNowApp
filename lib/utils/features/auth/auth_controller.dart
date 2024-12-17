// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:newifchaly/api/auth_api.dart';
// import 'package:newifchaly/services/supabase_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthController extends GetxController {
//   late AuthApi authApi;
//   RxBool loginLoading = false.obs;
//   RxBool signupLoading = false.obs;

//   @override
//   void onInit() {
//     authApi = AuthApi(SupabaseService.supabase);

//     super.onInit();
//   }

//   // * login method
//   void login(String email, String password) async {
//     loginLoading.value = true;
//     final AuthResponse response = await authApi.login(email, password);
//     loginLoading.value = false;
//     log("The login response is ${response.user?.toJson()}");
//     final session = Supabase.instance.client.auth.currentSession;
//   }

//   // * signup method
//   void signup(String name, email, String password) async {
//     signupLoading.value = true;
//     final AuthResponse response = await authApi.signup(name, email, password);
//     signupLoading.value = false;
//     log("The Sign Up response is ${response.user?.toJson()}");
//   }
// }

import 'dart:developer';
import 'package:get/get.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/api/auth_api.dart';
import 'package:newifchaly/cnic_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  late AuthApi authApi;
  RxBool loginLoading = false.obs;
  RxBool signupLoading = false.obs;

  @override
  void onInit() {
    authApi = AuthApi(SupabaseService.supabase);
    super.onInit();
  }

  void login(String email, String password) async {
  loginLoading.value = true;

  try {
    final AuthResponse? response = await authApi.login(email, password);
    loginLoading.value = false;

    if (response != null && response.user != null) {
      log("The login response is ${response.user?.toJson()}");

      // Fetch the user details from the users table
      final userId = response.user!.id;
      final user = await SupabaseService.supabase
          .from('users')
          .select('user_type')
          .eq('id', userId)
          .single();

      if (user != null && user['user_type'] == 'Admin') {
        // Navigate to AdminScreen
        Get.offAll(() => ApproveTutorsScreen() );
      } else {
        // Navigate to ProfileScreen for regular users
        Get.offAll(() => ProfileScreen());
      }
    } else {
      Get.snackbar("Login Failed", "Invalid email or password.");
    }
  } catch (e) {
    loginLoading.value = false;
    Get.snackbar("Login Error", "An error occurred during login.");
    log("Login error: $e");
  }
}
  void signup(String name, String email, String password, String groupValue) async {
    signupLoading.value = true;

    try {
      // Create the user in Supabase Auth
      final AuthResponse response = await authApi.signup(name, email, password);

      if (response.user != null) {
        // Add user type to the "users" table
        final userId = response.user!.id;
        await SupabaseService.supabase
            .from('users')
            .upsert({
              'id': userId,
              'email': email, 
              'user_type': groupValue, // Add groupValue as user type
            });

        log("User type successfully added for user: \${response.user?.toJson()}");

        signupLoading.value = false;

        // Optionally navigate to a different screen after successful signup
        Get.snackbar("Signup Success", "Account created successfully.");
        // Get.offAll(() => ProfileScreen());
      } else {
        signupLoading.value = false;
        Get.snackbar("Signup Failed", "Could not create account.");
      }
    } catch (e) {
      signupLoading.value = false;
      Get.snackbar("Signup Error", "An error occurred during signup.");
      log("Signup error: $e");
    }}

    // Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await authApi.changePassword(currentPassword, newPassword);
    } catch (e) {
      throw Exception("Error changing password: $e");
    }
  }
}

