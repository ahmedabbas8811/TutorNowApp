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
      //remove duplicate users based on userid
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

      final uniqueTutors =
          {for (var tutor in tutors) tutor.userId: tutor}.values.toList();

      return uniqueTutors;
    } catch (e) {
      print('Error fetching tutors by Qualfication: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPackagesByPriceRange(
      int minPrice, int maxPrice) async {
    try {
      final response = await _supabase
          .from('packages')
          .select('*, users!inner(id, metadata, image_url)') //join users table
          .gte('price', minPrice)
          .lte('price', maxPrice);

      //convert response into a list of maps
      final packages = response.map((data) {
        final userMetadata = data['users']['metadata'] ?? {};
        return {
          'package': PackageModel.fromJson(data),
          'tutor_name': userMetadata['name'] ?? 'Unknown Tutor',
          'tutor_image': data['users']['image_url'] ?? '',
        };
      }).toList();

      return packages;
    } catch (e) {
      print('Error fetching packages by price range: $e');
      return [];
    }
  }
}
