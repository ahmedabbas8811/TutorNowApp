import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  var selectedIndex = 0.obs;

  // Simulate profile data
  var profile = ProfileModel(
    name: "Bilal",
    isProfileComplete: false,
    upcomingBookings: [],
  ).obs;

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void navigateToPage(BuildContext context, int index) {
    updateSelectedIndex(index);

    switch (index) {
      case 0:
        Get.to(() => ProfileScreen());
        break;
      case 1:
        Get.to(() => AvailabilityScreen());
        break;
      case 2:
        Get.to(() => SessionsScreen());
        break;
      case 3:
        Get.to(() => EarningsScreen());
        break;
      case 4:
        Get.to(() => PersonScreen());
        break;
    }
  }
}
