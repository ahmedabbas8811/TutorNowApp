import 'package:flutter/material.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';

class TutorBookingsController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, List<BookingModel>>> fetchTutorBookings() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("No tutor is logged in.");
      return {'pending': [], 'active': [], 'completed': []};
    }

    final response = await supabase
        .from('bookings')
        .select('id, package_id, user_id, tutor_id, time_slots, status')
        .eq('tutor_id', user.id);

    if (response.isEmpty) {
      print("No bookings found for this tutor.");
      return {'pending': [], 'active': [], 'completed': []};
    }

    List<BookingModel> pendingBookings = [];
    List<BookingModel> activeBookings = [];
    List<BookingModel> completedBookings = [];

    response.forEach((data) {
      BookingModel booking = BookingModel.fromJson(data);
      print(
          "Fetched Booking - Booking ID: ${booking.bookingId}, Package ID: ${booking.packageId}, Student ID: ${booking.userId}, Status: ${data['status']}");

      //categorize bookings based on status
      switch (data['status']) {
        case 'pending':
          pendingBookings.add(booking);
          break;
        case 'active':
          activeBookings.add(booking);
          break;
        case 'completed':
          completedBookings.add(booking);
          break;
      }
    });

    //fetch details for each booking
    for (var booking in [
      ...pendingBookings,
      ...activeBookings,
      ...completedBookings
    ]) {
      await fetchStudentInfo(booking);
      await fetchPackageInfo(booking);
    }

    return {
      'pending': pendingBookings,
      'active': activeBookings,
      'completed': completedBookings,
    };
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

  Future<void> activateBooking(String bookingId, BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      print("No user is currently logged in.");
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('bookings')
          .update({'status': 'active'})
          .eq('id', bookingId)
          .select();

      print(response);

      if (response.isNotEmpty) {
        print("Booking status updated to active for booking ID: $bookingId");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking Accepted')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SessionScreen()),
        );
      } else {
        print("No booking found with the provided ID or user mismatch.");
      }
    } catch (e) {
      print("Error updating booking status: $e");
    }
  }
}
