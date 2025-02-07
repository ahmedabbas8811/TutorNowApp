import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';

class TutorBookingsController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<BookingModel>> fetchTutorBookings() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("No tutor is logged in.");
      return [];
    }

    final response = await supabase
        .from('bookings')
        .select('id, package_id, user_id, tutor_id') // Fetching booking ID
        .eq('tutor_id', user.id);

    if (response.isEmpty) {
      print("No bookings found for this tutor.");
      return [];
    }

    List<BookingModel> bookings = response.map((data) {
      BookingModel booking = BookingModel.fromJson(data);
      print(
          "Fetched Booking - Booking ID: ${booking.bookingId}, Package ID: ${booking.packageId}, Student ID: ${booking.userId}");
      return booking;
    }).toList();

    // Fetch details for each booking
    for (var booking in bookings) {
      await fetchStudentInfo(booking);
      await fetchPackageInfo(booking);
    }

    return bookings;
  }

  Future<void> fetchStudentInfo(BookingModel booking) async {
    try {
      final response = await supabase
          .from('users')
          .select('metadata, image_url')
          .eq('id', booking.userId)
          .single();

      if (response != null) {
        final studentName =
            response['metadata'] != null && response['metadata']['name'] != null
                ? response['metadata']['name']
                : 'Unknown Student';

        final studentImage = response['image_url'] ?? '';

        booking.updateStudentInfo(studentName, studentImage);

        print(
            "Fetched Student Info: ${booking.studentName}, Image URL: ${booking.studentImage}");
      } else {
        print("No student found for user_id: ${booking.userId}");
      }
    } catch (e) {
      print("Error fetching student info: $e");
    }
  }

  Future<void> fetchPackageInfo(BookingModel booking) async {
    try {
      final response = await supabase
          .from('packages')
          .select(
              'package_name, hours_per_session, minutes_per_session, sessions_per_week, number_of_weeks, price')
          .eq('id', booking.packageId)
          .single();

      if (response != null) {
        int hours = response['hours_per_session'] ?? 0;
        int minutes = response['minutes_per_session'] ?? 0;
        int totalMinutes = (hours * 60) + minutes;

        booking.updatePackageInfo(
          response['package_name'] ?? 'Unknown Package',
          totalMinutes.toString(),
          response['sessions_per_week'].toString(),
          response['number_of_weeks'].toString(),
          response['price'].toString(),
        );

        print(
            "Fetched Package Info: ${booking.packageName}, ${booking.minutesPerSession} Min, ${booking.sessionsPerWeek}X / Week, ${booking.numberOfWeeks} Weeks, ${booking.price} PKR");
      } else {
        print("No package found for package_id: ${booking.packageId}");
      }
    } catch (e) {
      print("Error fetching package info: $e");
    }
  }
}
