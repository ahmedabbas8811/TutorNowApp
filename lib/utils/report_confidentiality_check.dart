import 'package:newifchaly/student/models/progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressReportUtils {
  final SupabaseClient supabase = Supabase.instance.client;

  // Check if the current user is a student
  Future<bool> isCurrentUserStudent() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await supabase
          .from('users')
          .select('user_type')
          .eq('id', userId)
          .single();
      print("user type is ${response['user_type']}");
      return response['user_type'] == 'Student';
    } catch (e) {
      return false;
    }
  }

  Future<bool> shouldHideComments(ProgressReportModel report) async {
    // Debug logs
    print('Checking confidentiality for week ${report.week}');
    print('isConfidential: ${report.isConfidential}');

    if (!report.isConfidential) {
      print('Report is not confidential - showing comments');
      return false;
    }

    final isStudent = await isCurrentUserStudent();
    print('User is student: $isStudent');

    if (isStudent) {
      print('Hiding comments from student');
      return true;
    }

    print('Showing comments to non-student');
    return false;
  }
}
