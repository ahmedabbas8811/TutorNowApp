// controllers/profile_controller.dart
import 'package:get/get.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  // State variables
  var selectedIndex = 0.obs;

  // Profile data (Simulated for now)
  var profile = ProfileModel(
    name: "Bilal",
    isProfileComplete: false,
    upcomingBookings: [],
  ).obs;

  // Update the selected index
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  // Navigate to pages
  void navigateToPage(int index) {
    updateSelectedIndex(index);
    switch (index) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        Get.toNamed('/availability');
        break;
      case 2:
        Get.toNamed('/sessions');
        break;
      case 3:
        Get.toNamed('/earnings');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }
}
