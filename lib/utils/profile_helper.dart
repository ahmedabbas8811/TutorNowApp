import 'package:flutter/material.dart';
import 'package:newifchaly/Profile_Verification_screen.dart';
import 'package:newifchaly/bio_screen.dart';
import 'package:newifchaly/cnic_screen.dart';
import 'package:newifchaly/location2_screen.dart';
import 'package:newifchaly/location_screen.dart';
import 'package:newifchaly/qualification_screen.dart';
import 'package:newifchaly/teaching_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileCompletionHelper {
  // Fetch completion data from database
  static Future<Map<String, bool>> fetchCompletionData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('location,image,cnic,qualification,exp,bios')
            .eq('user_id', user.id)
            .maybeSingle();
        return response != null ? Map<String, bool>.from(response) : {};
      } catch (e) {
        print("Error fetching completion data: $e");
        return {};
      }
    }
    return {};
  }

  // Get incomplete steps
  static List<String> getIncompleteSteps(Map<String, bool> steps) {
    return steps.entries
        .where((entry) => entry.value == false)
        .map((entry) => entry.key)
        .toList();
  }

  static int getIncompleteStepsCount(Map<String, bool> steps) {
  return steps.entries.where((entry) => entry.value == false).length;
}
  static void navigateToNextScreen(
      BuildContext context, List<String> incompleteSteps) {
        
    print('In complete steps are: $incompleteSteps');
    if (incompleteSteps.isEmpty) {
      print("All steps completed!");
      // Navigate to the MessageScreen when all steps are completed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfileVerificationScreen()),
      );
      return; // Prevent further navigation.
    } 

    final nextStep = incompleteSteps.first;
    switch (nextStep) {
    

       case "bios":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BioScreen()));
        break;

          case "image":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => Location2Screen()));
        break;
      case "location":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LocationScreen()));
        break;

      case "cnic":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CnicScreen()));
        break;

      case "qualification":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => QualificationScreen()));
        break;
      

      default:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => TeachingDetail()));
    }
  }
}
