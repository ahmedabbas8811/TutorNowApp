import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_profile_model.dart';

class StudentProfileController extends GetxController {
  var isLoading = true.obs;
  var profile = Rxn<StudentProfile>();

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchStudentProfile();
  }

  Future<void> fetchStudentProfile() async {
  try {
    isLoading.value = true;
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Fetch user data
    final userResponse = await _supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    // Fetch location data
    final locationResponse = await _supabase
        .from('location')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    // Fetch student data (educational_level, subjects, learning_goals)
    final studentResponse = await _supabase
        .from('student')
        .select()
        .eq('student_id', user.id)
        .maybeSingle();

    // Combine all maps into profile
    profile.value = StudentProfile.fromMap(
      userResponse,
      locationResponse,
      studentResponse,
    );
  } catch (e) {
    print('Error fetching profile: $e');
  } finally {
    isLoading.value = false;
  }
}


Future<void> updateUserCity(String city) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    throw Exception("User not logged in");
  }

  // Check if an entry already exists for this user
  final existing = await supabase
      .from('location')
      .select('id')
      .eq('user_id', userId)
      .maybeSingle();

  if (existing != null) {
    // Update existing location
    await supabase
        .from('location')
        .update({'city': city})
        .eq('user_id', userId);
  } else {
    // Insert new location entry
    await supabase.from('location').insert({
      'city': city,
      'user_id': userId,
    });
  }
}
Future<void> updateStudentDetails({
  required String educationalLevel,
  required String subjects,
  required String learningGoals,
}) async {
  final userId = _supabase.auth.currentUser?.id;

  if (userId == null) {
    throw Exception("User not logged in");
  }

  // Check if student record already exists
  final existing = await _supabase
      .from('student')
      .select('id')
      .eq('student_id', userId)
      .maybeSingle();

  if (existing != null) {
    // Update existing student record
    await _supabase.from('student').update({
      'educational_level': educationalLevel,
      'subjects': subjects,
      'learning_goals': learningGoals,
    }).eq('student_id', userId);
  } else {
    // Insert new student record
    await _supabase.from('student').insert({
      'student_id': userId,
      'educational_level': educationalLevel,
      'subjects': subjects,
      'learning_goals': learningGoals,
    });
  }
}


}
