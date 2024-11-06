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
import 'package:newifchaly/api/auth_api.dart';
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

  // * login method
void login(String email, String password) async {
  loginLoading.value = true;

  try {
    final AuthResponse? response = await authApi.login(email, password);
    loginLoading.value = false;

    if (response != null && response.user != null) {
      log("The login response is ${response.user?.toJson()}");

      // Navigate to ProfileScreen after successful login
      Get.offAll(() => ProfileScreen());
    } else {
      Get.snackbar("Login Failed", "Invalid email or password.");
    }
  } catch (e) {
    loginLoading.value = false;
    Get.snackbar("Login Error", "An error occurred during login.");
    log("Login error: $e");
  }
}


  // * signup method
  void signup(String name, email, String password) async {
    signupLoading.value = true;

    try {
      final AuthResponse response = await authApi.signup(name, email, password);
      signupLoading.value = false;

      if (response.user != null) {
        log("The Sign Up response is ${response.user?.toJson()}");

        // Optionally, navigate to ProfileScreen or login screen after signup
        // For example:
        // Get.offAll(() => ProfileScreen());
      } else {
        Get.snackbar("Signup Failed", "Could not create account.");
      }
    } catch (e) {
      signupLoading.value = false;
      Get.snackbar("Signup Error", "An error occurred during signup.");
      log("Signup error: $e");
    }
  }
}
