import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bio_model.dart';

class BioController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var charCount = 0.obs;

  final int charLimit = 150;

  void updateCharCount(String text) {
    charCount.value = text.length;
     
  }

  Future<bool> isBioCompleted() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    try {
      final response = await _supabase
          .from('profile_completion_steps')
          .select('bios')
          .eq('user_id', userId)
          .maybeSingle();

      return response != null && response['bios'] == true;
    } catch (e) {
      print("Error checking bio status: $e");
      return false;
    }
  }

  Future<int?> saveBio(BioModel bioModel, BuildContext context) async {
   if(bioModel.bio.trim().isEmpty){
    showCustomSnackBar(context, "Please enter bio");
    return null;
   }

    try {
      final response = await _supabase.from('bios').insert({
        'bio': bioModel.bio,
        'userid': bioModel.userId,
      }).select();
     
      await _supabase
          .from('profile_completion_steps')
          .update({'bios': true}).eq('user_id', bioModel.userId);
          return response.first['id'] as int;

    } catch (e) {
      print('Failed to save bio: $e');
    } 
  }
}
