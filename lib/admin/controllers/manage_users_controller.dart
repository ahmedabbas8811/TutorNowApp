import 'package:newifchaly/admin/models/manage_users_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<UserModel>> fetchUsers() async {
    try {
      // Fetch all users except tutors first
      final nonTutorResponse = await _supabase
          .from('users')
          .select()
          .neq('user_type', 'Tutor')
          .order('created_at', ascending: false);

      // Fetch only verified tutors
      final tutorResponse = await _supabase
          .from('users')
          .select()
          .eq('user_type', 'Tutor')
          .eq('is_verified', true)
          .order('created_at', ascending: false);

      // Combine both lists
      final List<UserModel> users = [
        ...nonTutorResponse.map((user) => UserModel.fromJson(user)),
        ...tutorResponse.map((user) => UserModel.fromJson(user)),
      ];

      return users;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
  
  Future<void> updateUserStatus(String userId, bool isBlocked) async {
    try {
      await _supabase
          .from('users')
          .update({'status': isBlocked ? 'blocked' : 'unblocked'})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }
}