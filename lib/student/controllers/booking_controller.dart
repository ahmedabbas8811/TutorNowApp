import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/student/models/booking_model.dart';

class BookingController extends GetxController {
  RxList<BookingModel> pendingBookings = <BookingModel>[].obs;
  RxList<BookingModel> activeBookings = <BookingModel>[].obs;
  RxList<BookingModel> rejectedBookings = <BookingModel>[].obs;
  RxList<BookingModel> completedBookings = <BookingModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading(true); // Set loading to true when fetch starts
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      print("No user is currently logged in.");
      isLoading(false); // Make sure to set loading to false even if no user
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('bookings')
          .select('id, user_id, package_id, tutor_id, time_slots, status')
          .or('user_id.eq.${user.id},parent_id.eq.${user.id}');

      if (response.isNotEmpty) {
        print("Bookings fetched successfully: $response");

        // Clear existing bookings
        activeBookings.clear();
        pendingBookings.clear();
        rejectedBookings.clear();
        completedBookings.clear();

        // Temporary lists to hold data before assigning
        List<BookingModel> active = [];
        List<BookingModel> pending = [];
        List<BookingModel> rejected = [];
        List<BookingModel> completed = [];

        // Process bookings in parallel for better performance
        await Future.wait(response.map((booking) async {
          BookingModel bookingData = BookingModel.fromJson(booking);

          // Fetch tutor info and update
          await fetchTutorInfo(bookingData);

          // Fetch package info and update
          await fetchPackageInfo(bookingData);

          // Categorize bookings based on status
          if (booking['status'] == 'active') {
            active.add(bookingData);
          } else if (booking['status'] == 'pending') {
            pending.add(bookingData);
          } else if (booking['status'] == 'rejected') {
            rejected.add(bookingData);
          } else if (booking['status'] == 'completed') {
            completed.add(bookingData);
          }
        }));

        // Assign all at once to minimize UI updates
        activeBookings.assignAll(active);
        pendingBookings.assignAll(pending);
        rejectedBookings.assignAll(rejected);
        completedBookings.assignAll(completed);

        print(
            "Active Bookings: ${activeBookings.length}, Pending Bookings: ${pendingBookings.length}, Rejected Bookings: ${rejectedBookings.length}, Completed Bookings: ${completedBookings.length}");
      } else {
        print("No bookings found for user_id: ${user.id}");
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading(false);
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

        final tutorImage = response['image_url'] ?? '';

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

  Future<void> submitFeedback({
    required int rating,
    required String review,
    required String tutorId,
    required String studentId,
  }) async {
    final supabase = Supabase.instance.client;

    if (rating <= 0 || review.trim().isEmpty) {
      throw Exception("Rating and review cannot be empty.");
    }

    try {
      await supabase.from('feedback').insert({
        'rating': rating,
        'review': review.trim(),
        'tutor_id': tutorId,
        'student_id': studentId,
      });
    } catch (e) {
      throw Exception("Failed to submit feedback: $e");
    }
  }
}
