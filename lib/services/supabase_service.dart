import 'package:get/get.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/storage_service.dart';
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
        // Store session in persistent storage
        StorageService.box.write(StorageConstants.authKey, data.session);
        // Navigate to ProfileScreen
        Get.offAll(ProfileScreen());
      } else if (data.event == AuthChangeEvent.signedOut) {
        // Remove session from storage
        StorageService.box.remove(StorageConstants.authKey);
        // Navigate to LoginScreen
        Get.offAll(LoginScreen());
      } else if (data.event == AuthChangeEvent.tokenRefreshed) {
        // Optional: update the session in storage if needed
        StorageService.box.write(StorageConstants.authKey, data.session);
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
