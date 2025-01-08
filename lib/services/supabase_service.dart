import 'dart:developer';

import 'package:get/get.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/storage_service.dart';
import 'package:newifchaly/splashscreen.dart';
import 'package:newifchaly/utils/storage_constants.dart';
import 'package:newifchaly/utils/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  // Your existing onInit method
  @override
  void onInit() async {
    await Supabase.initialize(url: appUrl, anonKey: appKey);
    // Calling the listenAuthChange
    listenAuthChanges();
    super.onInit();
  }

  // * Supabase instance
  static final SupabaseClient supabase = Supabase.instance.client;

  // * To listen to auth events
  void listenAuthChanges() {
  supabase.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.signedIn) {
      // Store session as JSON in persistent storage
      if (data.session != null) {
        StorageService.box.write(StorageConstants.authKey, data.session!.toJson());
        log("Session saved after sign-in: ${data.session!.toJson()}");
      }

      // Navigate to SplashScreen for further redirection
      Get.offAll(() => SplashScreen());
    } else if (data.event == AuthChangeEvent.signedOut) {
      // Remove session from storage
      StorageService.box.remove(StorageConstants.authKey);
      log("Session removed after sign-out");

      // Navigate to LoginScreen
      Get.offAll(LoginScreen());
    } else if (data.event == AuthChangeEvent.tokenRefreshed) {
      // Update session in storage after token refresh
      if (data.session != null) {
        StorageService.box.write(StorageConstants.authKey, data.session!.toJson());
        log("Session updated after token refresh: ${data.session!.toJson()}");
      }
    }
  });
}


  // * Logout method
  void logout() async {
    // Remove session from storage
    StorageService.box.remove(StorageConstants.authKey);

    // Sign out from Supabase
    await supabase.auth.signOut();

    // Navigate to LoginScreen
    Get.offAll(LoginScreen());
  }
}
