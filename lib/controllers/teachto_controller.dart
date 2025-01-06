import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/models/teachto_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../views/widgets/snackbar.dart';

class TeachToController extends GetxController {
  final TeachToModel teachto = TeachToModel(); // Instance of model
  final user = Supabase.instance.client.auth.currentUser;

  Future<bool> isTeachToCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('teachto')
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null && response['teachto'] == true) {
          print("Teach To step is already completed.");
          return true; // Step is already completed
        } else {
          print("Teach To step is not completed.");
        }
      } catch (e) {
        print("Error checking teach to status: $e");
      }
    }
    return false; // Step is not completed
  }

  // Store qualification in Supabase
  Future<int?> storeteachto(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;

    print("User ID: ${user?.id}");
    print("Education Level: ${teachto.educationLevel.value}");
    print("Institute Name: ${teachto.subject.value}");

    if (user != null &&
        teachto.educationLevel.value.isNotEmpty &&
        teachto.subject.value.isNotEmpty) {
      try {
        final response = await Supabase.instance.client.from('teachto').insert({
          'education_level': teachto.educationLevel.value,
          'subject': teachto.subject.value,
          'user_id': user.id,
        }).select();

        if (response.isNotEmpty) {
          await Supabase.instance.client
              .from('profile_completion_steps')
              .update({'teachto': true}).eq('user_id', user.id);
          print("Teach To step updated successfully.");
          return response.first['id'] as int; // Return the inserted row ID
        }
      } catch (e) {
        print("Error storing Teach to details: $e");
        showCustomSnackBar(
            context, "Error storing teach to details, try again");
      }
    } else {
      print("Please fill all fields.");
      showCustomSnackBar(context, "Please fill all fields");
    }
    return null;
  }
}
