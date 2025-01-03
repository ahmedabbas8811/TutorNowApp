import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/models/addpackage_model.dart';

class AddPackageController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Method to add a new package
  Future<int?> addPackage(AddPackageModel package) async {
    try {
      final response = await _supabase
          .from('packages') // Supabase table name
          .insert(package.toMap())
          .select(); // Returns the inserted row(s)

      if (response.isNotEmpty) {
        return response.first['id'] as int; // Return the inserted package ID
      } else {
        return null; // Indicate failure
      }
    } catch (e) {
      print('Error adding package: $e');
      return null;
    }
  }
}
