import 'package:get/get.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/models/person_model.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class PersonController extends GetxController {
    var profile = PersonModel(
    name: "",
    isProfileComplete: false,
    profileImage: "assets/Ellipse 1.png",
    isVerified: false
  ).obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName(); // Load profile data when the controller initializes
    updateVerificationStatus();
    fetchUserImg();
    updateProfileStatus();
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
    
    if (response != null && response['is_verified']==true){
       profile.update((p) {
            p?.isVerified= true;
          });

    }
  } catch (error) {
    print("Error checking columns: $error");
   
  }
}



Future<void> updateProfileStatus() async {
  // Reference to your Supabase client
  final supabase = Supabase.instance.client;
  final user = Supabase.instance.client.auth.currentUser;

  try {
    // Query the profile table
    final response = await supabase
        .from('profile_completion_steps') // Replace with your actual table name
        .select('image, location') // Add other columns if necessary
        .eq('user_id', user!.id) // Filter by the user's ID or your condition
        .single(); // Fetch a single record

    if (response == null) {
      throw Exception("Profile not found");
    }

    // Check if all columns are true
    final data = response as Map<String, dynamic>;
    final areAllTrue = data.values.every((value) => value == true);
    if (response != null && areAllTrue){
       profile.update((p) {
            p?.isProfileComplete = true;
          });

    }
  } catch (error) {
    print("Error checking columns: $error");
   
  }
}


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
 
   Future<void> fetchUserImg() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('image_url') // Fetch the name from metadata
            .eq('id', user.id)
            .maybeSingle();

        if (response != null && response['image_url'] != null) {
          profile.update((p) {
            p?.profileImage = response['image_url']; // Update the profile model
          });
        } else {
          print("Image url not found");
        }
      } catch (e) {
        print("Error fetching img url: $e");
      }
    }
  }
 

  // Logout the user
  void logout() {
    Get.find<SupabaseService>().logout();
  }

  // Navigate to another screen
  void navigateTo(int index) {
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
