import 'package:newifchaly/student/models/package_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FilterController {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Tutor>> getTutorsByEducationLevel(String level) async {
    try {
      final response = await _supabase
          .from('teachto')
          .select(
              'id, user_id, education_level, subject, users(metadata, image_url)')
          .eq('education_level', level);
      final tutors =
          response.map<Tutor>((data) => Tutor.fromMap(data)).toList();
      // Remove duplicate users based on user_id
      final uniqueTutors =
          {for (var tutor in tutors) tutor.userId: tutor}.values.toList();

      return uniqueTutors;
    } catch (e) {
      print('Error fetching tutors by education level: $e');
      return [];
    }
  }

  Future<List<Tutor>> getTutorsByQualification(String level) async {
    try {
      final response = await _supabase
          .from('qualification')
          .select('id, user_id, education_level,users(metadata, image_url)')
          .eq('education_level', level);
      final tutors =
          response.map<Tutor>((data) => Tutor.fromMap(data)).toList();

      // Remove duplicate users based on user_id
      final uniqueTutors =
          {for (var tutor in tutors) tutor.userId: tutor}.values.toList();

      return uniqueTutors;
    } catch (e) {
      print('Error fetching tutors by Qualfication: $e');
      return [];
    }
  }

  Future<List<PackageModel>> getPackagesByPriceRange(
      int minPrice, int maxPrice) async {
    try {
      // Fetch all packages within the given price range
      final response = await _supabase
          .from('packages')
          .select('*')
          .gte('price', minPrice) // Greater than or equal to minPrice
          .lte('price', maxPrice); // Less than or equal to maxPrice

      // Convert the response to a list of PackageModel
      final packages = response
          .map<PackageModel>((data) => PackageModel.fromJson(data))
          .toList();

      return packages;
    } catch (e) {
      print('Error fetching packages by price range: $e');
      return [];
    }
  }
}
