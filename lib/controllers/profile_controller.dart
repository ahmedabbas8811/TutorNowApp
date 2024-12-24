import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/controllers/person_controller.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  var selectedIndex = 0.obs;

  var profile = ProfileModel(
          name: "",
          isProfileComplete: false,
          upcomingBookings: [],
          stepscount: 2,
          isVerified: false)
      .obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    updateVerificationStatus();
    updateProfileStatus();
    fetchProfileCompletionData();
  }

  @override
  void onReady() {
    super.onReady();
    updateVerificationStatus();
    updateProfileStatus();
    fetchProfileCompletionData();
  }

  Future<void> updateProfileStatus() async {
    // Reference to your Supabase client
    final supabase = Supabase.instance.client;
    final user = Supabase.instance.client.auth.currentUser;

    try {
      // Query the profile table
      final response = await supabase
          .from(
              'profile_completion_steps') // Replace with your actual table name
          .select(
              'image, location,cnic,qualification,exp,bios') // Add other columns if necessary
          .eq('user_id', user!.id) // Filter by the user's ID or your condition
          .single(); // Fetch a single record

      if (response == null) {
        throw Exception("Profile not found");
      }

      // Check if all columns are true
      final data = response as Map<String, dynamic>;
      final areAllTrue = data.values.every((value) => value == true);
      if (response != null && areAllTrue) {
        profile.update((p) {
          p?.isProfileComplete = true;
        });
      }
    } catch (error) {
      print("Error checking columns: $error");
    }
  }

  Future<void> updateVerificationStatus() async {
    // Reference to your Supabase client
    final supabase = Supabase.instance.client;
    final user = Supabase.instance.client.auth.currentUser;

    try {
      // Query the profile table
      final response = await supabase
          .from('users') // Replace with your actual table name
          .select('is_verified') // Add other columns if necessary
          .eq('id', user!.id) // Filter by the user's ID or your condition
          .single(); // Fetch a single record

      if (response == null) {
        throw Exception("Profile not found");
      }

      // Check if all columns are true

      if (response != null && response['is_verified'] == true) {
        profile.update((p) {
          p?.isVerified = true;
        });
      }
    } catch (error) {
      print("Error checking columns: $error");
    }
  }

  // Fetch the user's name from the database
  Future<void> fetchUserName() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('metadata->>name') // Fetch the name from metadata
            .eq('id', user.id)
            .maybeSingle();

        if (response != null && response['name'] != null) {
          profile.update((p) {
            p?.name = response['name']; // Update the profile model
          });
        } else {
          print("Name not found in metadata.");
        }
      } catch (e) {
        print("Error fetching user name: $e");
      }
    }
  }

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

  Future<void> fetchProfileCompletionData() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        final completionData =
            await ProfileCompletionHelper.fetchCompletionData();

        // Get the count of incomplete steps using ProfileCompletionHelper
        final incompleteStepsCount =
            ProfileCompletionHelper.getIncompleteStepsCount(completionData);

        // Update the steps count in the profile model
        profile.update((p) {
          p?.stepscount = incompleteStepsCount;
        });
      } catch (e) {
        print("Error fetching profile completion data: $e");
      }
    }
  }
}
