import 'package:get/get.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/storage_service.dart';
import 'package:newifchaly/utils/storage_constants.dart';
import 'package:newifchaly/utils/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  @override
  void onInit() async {
    await Supabase.initialize(url: appUrl, anonKey: appKey);
    // * calling the listenAuthChange
    listenAuthChanges();

    super.onInit();
  }

  // * Supabase instance
  static final SupabaseClient supabase = Supabase.instance.client;

// * To listen auth Events

  void listenAuthChanges() {
    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        // Store session in persistent storage
        StorageService.box.write(StorageConstants.authKey, data.session);
        Get.offAll(ProfileScreen());
      } else if (data.event == AuthChangeEvent.signedOut) {
        // Remove session from storage
        StorageService.box.remove(StorageConstants.authKey);
        Get.offAll(LoginScreen());
      } else if (data.event == AuthChangeEvent.tokenRefreshed) {
        // Optional: update the session in storage if needed
        StorageService.box.write(StorageConstants.authKey, data.session);
      }
    });
  }
}
