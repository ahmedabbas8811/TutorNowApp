import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/student/models/booking_model.dart';

class BookingController extends GetxController {
  var bookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      print("No user is currently logged in.");
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('bookings')
          .select('id, user_id, package_id, tutor_id')
          .eq('user_id', user.id);

      if (response.isNotEmpty) {
        print("Bookings fetched successfully: $response");

        bookings.clear();
        for (var booking in response) {
          BookingModel bookingData = BookingModel.fromJson(booking);

          // fetch tutor info and update
          await fetchTutorInfo(bookingData);

          // fetch package info and update
          await fetchPackageInfo(bookingData);

          bookings.add(bookingData);
        }
      } else {
        print("No bookings found for user_id: ${user.id}");
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  Future<void> fetchTutorInfo(BookingModel booking) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('metadata, image_url')
          .eq('id', booking.tutorId)
          .single();

      if (response != null) {
        final tutorName =
            response['metadata'] != null && response['metadata']['name'] != null
                ? response['metadata']['name']
                : 'Unknown Tutor';

        final tutorImage =
            response['image_url'] ?? ''; 

        booking.updateTutorInfo(tutorName, tutorImage);

        print(
            "Fetched Tutor Info: ${booking.tutorName}, ${booking.tutorImage}");
      } else {
        print("No tutor found for tutor_id: ${booking.tutorId}");
      }
    } catch (e) {
      print("Error fetching tutor info: $e");
    }
  }

  Future<void> fetchPackageInfo(BookingModel booking) async {
    try {
      final response = await Supabase.instance.client
          .from('packages')
          .select(
              'package_name, hours_per_session, minutes_per_session, sessions_per_week, number_of_weeks, price')
          .eq('id', booking.packageId)
          .single();

      if (response != null) {
        // calculate minutes per session
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
