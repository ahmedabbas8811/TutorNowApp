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
}