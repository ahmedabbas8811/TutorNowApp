import 'package:flutter/material.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';

class TutorBookingsController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, List<BookingModel>>> fetchTutorBookings() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("[DEBUG] No tutor is logged in.");
      return {'pending': [], 'active': [], 'completed': []};
    }

    print('[DEBUG] Fetching bookings for tutor ${user.id}');

    try {
      // Step 1: Fetch bookings
      final response = await supabase
          .from('bookings')
          .select(
              'id, package_id, user_id, tutor_id, time_slots, status, accepted_at')
          .eq('tutor_id', user.id);

      print('[DEBUG] Found ${response.length} bookings');

      if (response.isEmpty) {
        print("[DEBUG] No bookings found for this tutor.");
        return {'pending': [], 'active': [], 'completed': []};
      }

      // Step 2: Process each booking
      for (var data in response) {
        final bookingId = data['id'];
        print('[DEBUG] Processing booking $bookingId');

        try {
          final status = data['status'];
          final acceptedAt = DateTime.tryParse(data['accepted_at'] ?? '');
          final packageId = data['package_id'];

          if (status == 'active' && acceptedAt != null) {
            print('[DEBUG] Active booking with package $packageId');

            final packageResponse = await supabase
                .from('packages')
                .select('number_of_weeks')
                .eq('id', packageId)
                .single();

            final numberOfWeeks = packageResponse['number_of_weeks'] ?? 0;
            final weeksPassed =
                DateTime.now().difference(acceptedAt).inDays ~/ 7;

            if (weeksPassed >= numberOfWeeks) {
              print('[DEBUG] Marking booking $bookingId as completed');

              // final updateResult = await supabase
              //     .from('bookings')
              //     .update({'status': 'completed'})
              //     .eq('id', bookingId);

              // print('[DEBUG] Update status result: ${updateResult.status}');
              // data['status'] = 'completed';
            }
          }
        } catch (e) {
          print('[ERROR] Failed to process booking $bookingId: $e');
          print('[DEBUG] Booking data: ${data.toString()}');
        }
      }

      // Categorize bookings
      List<BookingModel> pendingBookings = [];
      List<BookingModel> activeBookings = [];
      List<BookingModel> completedBookings = [];

      for (var data in response) {
        try {
          final booking = BookingModel.fromJson(data);
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
        } catch (e) {
          print('[ERROR] Failed to categorize booking: $e');
        }
      }

      print('[DEBUG] Completed bookings: ${completedBookings.length}');

      // Enhanced booked_slots deletion with comprehensive debugging
      if (completedBookings.isNotEmpty) {
        final completedBookingIds =
            completedBookings.map((b) => b.bookingId).toList();
        print(
            '[DEBUG] Attempting to delete booked_slots for: $completedBookingIds');

        try {
          // Debug 1: Check if booking IDs exist in bookings table
          final bookingsCheck = await supabase
              .from('bookings')
              .select('id')
              .inFilter('id', completedBookingIds);
          print(
              '[DEBUG] Verified ${bookingsCheck.length} bookings exist in bookings table');

          // Debug 2: Check booked_slots table structure
          final slotsStructure =
              await supabase.from('booked_slots').select('*').limit(1);
          print(
              '[DEBUG] booked_slots table structure sample: ${slotsStructure.isNotEmpty ? slotsStructure[0].keys.join(', ') : 'empty'}');

          // Debug 3: Check for matching records with exact query we'll use
          final matchingSlots = await supabase
              .from('booked_slots')
              .select('booking_id, monday, tuesday, wednesday, thursday')
              .inFilter('booking_id', completedBookingIds);

          print(
              '[DEBUG] Found ${matchingSlots.length} matching booked_slots records');
          print(
              '[DEBUG] Sample matching record: ${matchingSlots.isNotEmpty ? matchingSlots[0] : 'none'}');

          if (matchingSlots.isNotEmpty) {
            print('[DEBUG] Deleting booked_slots records...');
            final deleteResult = await supabase
                .from('booked_slots')
                .delete()
                .inFilter('booking_id', completedBookingIds);

            print('[DEBUG] Delete operation completed');

            // Verify deletion
            final remainingSlots = await supabase
                .from('booked_slots')
                .select('booking_id')
                .inFilter('booking_id', completedBookingIds);

            if (remainingSlots.isEmpty) {
              print('[SUCCESS] All booked_slots deleted successfully');
            } else {
              print(
                  '[WARNING] ${remainingSlots.length} records remain after deletion');
            }
          } else {
            print('[INFO] No booked_slots records found for these booking IDs');

            // Additional debug: Check if time_slots exist for these bookings
            final bookingsWithSlots = await supabase
                .from('bookings')
                .select('id, time_slots')
                .inFilter('id', completedBookingIds)
                .neq('time_slots', 'null');

            print(
                '[DEBUG] ${bookingsWithSlots.length} completed bookings have time_slots but no booked_slots');
          }
        } catch (e) {
          print('[ERROR] Failed to delete booked_slots: $e');
          if (e is PostgrestException) {
            print('[SUPABASE ERROR] Details: ${e.message}');
            print('[SUPABASE ERROR] Hint: ${e.hint}');
          }
        }
      }

      // Fetch additional info
      print('[DEBUG] Fetching student and package info');
      final allBookings = [
        ...pendingBookings,
        ...activeBookings,
        ...completedBookings
      ];
      for (var booking in allBookings) {
        try {
          await fetchStudentInfo(booking);
          await fetchPackageInfo(booking);
        } catch (e) {
          print(
              '[ERROR] Failed to fetch info for booking ${booking.bookingId}: $e');
        }
      }

      return {
        'pending': pendingBookings,
        'active': activeBookings,
        'completed': completedBookings,
      };
    } catch (e) {
      print('[ERROR] Critical error in fetchTutorBookings: $e');
      return {'pending': [], 'active': [], 'completed': []};
    }
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
      // Step 1: Update booking status to active
      final response = await Supabase.instance.client
          .from('bookings')
          .update({
            'status': 'active',
            'accepted_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', bookingId)
          .select();

      if (response.isNotEmpty) {
        print("Booking status updated to active for booking ID: $bookingId");

        final booking = response.first;
        final timeSlots = booking['time_slots']; // JSONB format
        final tutorId = booking['tutor_id'];

        // Step 2: Parse time_slots and organize by day
        final Map<String, List<String>> daySlots = {
          'monday': [],
          'tuesday': [],
          'wednesday': [],
          'thursday': [],
          'friday': [],
          'saturday': [],
          'sunday': [],
        };

        if (timeSlots != null) {
          timeSlots.forEach((key, value) {
            final day = value['day']?.toString().toLowerCase();
            final time = value['time'];
            if (day != null && time != null && time.isNotEmpty) {
              daySlots[day]?.add(time);
            }
          });
        }

        // Step 3: Insert into booked_slots with booking_id
        final slotInsert = {
          'booking_id': bookingId, // <- ✅ Added this
          'tutor_id': tutorId,
          'monday': daySlots['monday'],
          'tuesday': daySlots['tuesday'],
          'wednesday': daySlots['wednesday'],
          'thursday': daySlots['thursday'],
          'friday': daySlots['friday'],
          'saturday': daySlots['saturday'],
          'sunday': daySlots['sunday'],
        };

        await Supabase.instance.client.from('booked_slots').insert(slotInsert);
        print("Slots saved in booked_slots with booking_id successfully.");

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
