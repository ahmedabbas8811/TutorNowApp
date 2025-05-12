import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_model.dart';

class DashboardController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<DashboardStats> fetchPlatformEngagement() async {
    try {
      // Fetch all users
      final response =
          await supabase.from('users').select('id, user_type, is_verified');
      if (response == null || response.isEmpty) {
        return DashboardStats.empty();
      }

      int newUsers = response.length;
      int activeTutors = response
          .where((user) =>
              user['user_type'] == 'Tutor' && user['is_verified'] == true)
          .length;
      int activeStudents =
          response.where((user) => user['user_type'] == 'Student').length;
      int completedSessions = 99;

      return DashboardStats(
        newUsers: newUsers,
        completedSessions: completedSessions,
        activeTutors: activeTutors,
        activeStudents: activeStudents,
      );
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return DashboardStats.empty();
    }
  }

  Future<TutorQualifications> fetchTutorQualifications() async {
    try {
      // Join 'qualification' with 'users' and filter where users.is_verified is true
      final response = await supabase
          .from('qualification')
          .select('education_level, users!inner(is_verified)')
          .eq('users.is_verified', true);

      if (response == null || response.isEmpty) {
        return TutorQualifications.empty();
      }

      // Initialize counters
      int underMatric = 0;
      int matric = 0;
      int fsc = 0;
      int bachelors = 0;
      int masters = 0;
      int phd = 0;

      // Count each education level from verified tutors only
      for (var record in response) {
        final level = record['education_level']?.toString().toLowerCase() ?? '';

        if (level.contains('under matric')) {
          underMatric++;
        } else if (level.contains('matric')) {
          matric++;
        } else if (level.contains('fsc') || level.contains('intermediate')) {
          fsc++;
        } else if (level.contains('bachelor')) {
          bachelors++;
        } else if (level.contains('master')) {
          masters++;
        } else if (level.contains('phd') || level.contains('doctorate')) {
          phd++;
        }
      }

      return TutorQualifications(
        underMatric: underMatric,
        matric: matric,
        fsc: fsc,
        bachelors: bachelors,
        masters: masters,
        phd: phd,
      );
    } catch (e) {
      print('Error fetching qualifications: $e');
      return TutorQualifications.empty();
    }
  }

  Future<TutorExperience> fetchTutorExperience() async {
    try {
      // Join 'experience' with 'users' and filter where users.is_verified is true
      final response = await supabase
          .from('experience')
          .select('start_date, end_date, users!inner(is_verified)')
          .eq('users.is_verified', true);

      if (response == null || response.isEmpty) {
        return TutorExperience.empty();
      }

      // Initialize counters for each experience range
      int zeroToTwo = 0;
      int threeToFour = 0;
      int fiveToSix = 0;
      int sevenToEight = 0;
      int nineToTen = 0;
      int underFifteen = 0;
      int underTwenty = 0;
      int overTwentyFive = 0;

      // Calculate experience for each tutor
      for (var record in response) {
        final startDateStr = record['start_date']?.toString() ?? '';
        final endDateStr = record['end_date']?.toString() ?? '';

        if (startDateStr.isEmpty || endDateStr.isEmpty) continue;

        try {
          // Parse dates (assuming format is DD/MM/YYYY)
          final startParts = startDateStr.split('/');
          final endParts = endDateStr.split('/');

          if (startParts.length != 3 || endParts.length != 3) continue;

          final startDate = DateTime(
            int.parse(startParts[2]),
            int.parse(startParts[1]),
            int.parse(startParts[0]),
          );
          final endDate = DateTime(
            int.parse(endParts[2]),
            int.parse(endParts[1]),
            int.parse(endParts[0]),
          );

          // Calculate difference in years
          final difference = endDate.difference(startDate);
          final years = difference.inDays / 365;

          // Categorize the experience
          if (years <= 2) {
            zeroToTwo++;
          } else if (years <= 4) {
            threeToFour++;
          } else if (years <= 6) {
            fiveToSix++;
          } else if (years <= 8) {
            sevenToEight++;
          } else if (years <= 10) {
            nineToTen++;
          } else if (years <= 15) {
            underFifteen++;
          } else if (years <= 20) {
            underTwenty++;
          } else {
            overTwentyFive++;
          }
        } catch (e) {
          print('Error parsing date: $e');
          continue;
        }
      }

      return TutorExperience(
        zeroToTwo: zeroToTwo,
        threeToFour: threeToFour,
        fiveToSix: fiveToSix,
        sevenToEight: sevenToEight,
        nineToTen: nineToTen,
        underFifteen: underFifteen,
        underTwenty: underTwenty,
        overTwentyFive: overTwentyFive,
      );
    } catch (e) {
      print('Error fetching experience: $e');
      return TutorExperience.empty();
    }
  }

  Future<int> getBookingCount(String timeFrame) async {
    try {
      final now = DateTime.now().toUtc();
      final filterDate = _getFilterDate(now, timeFrame);

      final response = await supabase
          .from('bookings')
          .select('id')
          .gte('created_at', filterDate.toIso8601String());

      return response.length;
    } catch (e) {
      print('Error getting booking count: $e');
      return 0;
    }
  }

  Future<List<Booking>> fetchRecentBookings(String timeFrame) async {
    try {
      final now = DateTime.now().toUtc();
      final filterDate = _getFilterDate(now, timeFrame);

      // 1. First fetch the bookings with tutor and student IDs
      final bookingsResponse = await supabase
          .from('bookings')
          .select('created_at, tutor_id, user_id')
          .gte('created_at', filterDate.toIso8601String())
          .order('created_at', ascending: false);

      if (bookingsResponse.isEmpty) return [];

      // 2. Get all unique user IDs (both tutors and students)
      final allUserIds = [
        ...bookingsResponse.map((b) => b['tutor_id'] as String),
        ...bookingsResponse.map((b) => b['user_id'] as String)
      ].toSet().toList();

      // 3. Fetch user names using proper IN clause
      final usersResponse = await supabase
          .from('users')
          .select('id, metadata')
          .inFilter('id', allUserIds);

      // 4. Create name lookup map
      final userNames = <String, String>{};
      for (final user in usersResponse) {
        final name = (user['metadata'] as Map<String, dynamic>?)?['name'];
        if (name != null) {
          userNames[user['id'] as String] = name;
        }
      }

      // 5. Combine the data
      return bookingsResponse.map<Booking>((booking) {
        return Booking(
          tutorName:
              userNames[booking['tutor_id'] as String] ?? 'Unknown Tutor',
          studentName:
              userNames[booking['user_id'] as String] ?? 'Unknown Student',
          createdAt: DateTime.parse(booking['created_at'] as String).toLocal(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  DateTime _getFilterDate(DateTime now, String timeFrame) {
    switch (timeFrame) {
      case 'Past 24 Hours':
        return now.subtract(const Duration(days: 1));
      case 'Past 7 Days':
        return now.subtract(const Duration(days: 7));
      case 'Past 15 Days':
        return now.subtract(const Duration(days: 15));
      case 'Past 30 Days':
        return now.subtract(const Duration(days: 30));
      default:
        return now.subtract(const Duration(days: 1));
    }
  }

  Future<BookingStats> fetchBookingStats() async {
    try {
      final response = await supabase.from('bookings').select('status');

      if (response == null || response.isEmpty) {
        return BookingStats.empty();
      }
      print(response);

      // Total requests is simply the count of all booking records
      int totalRequests = response.length;

      // Count each status type
      int pending = response.where((b) => b['status'] == 'pending').length;
      int inProgress = response.where((b) => b['status'] == 'active').length;
      int completed = response.where((b) => b['status'] == 'completed').length;
      int rejected = response.where((b) => b['status'] == 'declined').length;
      int cancelled = response.where((b) => b['status'] == 'cancelled').length;

      // Verify that sum of all statuses equals total (for debugging)
      assert(
          (pending + inProgress + completed + rejected + cancelled) ==
              totalRequests,
          'Status counts don\'t match total bookings');

      return BookingStats(
        totalRequests: totalRequests,
        inProgress: inProgress,
        completed: completed,
        rejected: rejected,
      );
    } catch (e) {
      print('Error fetching booking stats: $e');
      return BookingStats.empty();
    }
  }
}
