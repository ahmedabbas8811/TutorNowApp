import 'package:newifchaly/admin/models/reports_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ReportController {
  Future<List<Report>> fetchAllReports() async {
  try {
    final response = await supabase
        .from('reports')
        .select('''
          id, 
          reported_user_id, 
          reporter_id,
          comments, 
          created_at, 
          status,
          images,
          reported_user:reported_user_id (metadata),
          reporter:reporter_id (metadata)
        ''')
        .order('created_at', ascending: true);

    if (response == null) return [];

    return response.map<Report>((report) {
      return Report.fromJson({
        ...report,
        'reported_user_metadata': report['reported_user']?['metadata'] ?? {},
        'reporter_metadata': report['reporter']?['metadata'] ?? {},
      });
    }).toList();
  } catch (e) {
    throw Exception('Failed to fetch reports: ${e.toString()}');
  }
}


Future<List<Report>> fetchUserReportHistory(String userId, {int? excludeReportId}) async {
    try {
      final response = await supabase
          .from('reports')
          .select('''
            id, 
            reported_user_id, 
            reporter_id,
            comments, 
            created_at, 
            status,
            images,
            reported_user:reported_user_id (metadata),
            reporter:reporter_id (metadata)
          ''')
          .eq('reported_user_id', userId)
          .order('created_at', ascending: false);

      if (response == null || response.isEmpty) return [];

      final filtered = excludeReportId != null
          ? response.where((report) => report['id'] != excludeReportId).toList()
          : response;

      return filtered.map<Report>((report) {
        return Report.fromJson({
          ...report,
          'reported_user_metadata': report['reported_user']?['metadata'] ?? {},
          'reporter_metadata': report['reporter']?['metadata'] ?? {},
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch report history: ${e.toString()}');
    }
  }

  Future<int> countReportsForUser(String userId, {int? excludeReportId}) async {
    try {
      final reports = await fetchUserReportHistory(userId, excludeReportId: excludeReportId);
      return reports.length;
    } catch (e) {
      throw Exception('Failed to count reports: ${e.toString()}');
    }
  }
  
  Future<void> updateReportStatus(int reportId, String status) async {
  try {
    await supabase
        .from('reports')
        .update({'status': status})
        .eq('id', reportId);
  } catch (e) {
    throw Exception('Failed to update report status: ${e.toString()}');
  }
}
}



