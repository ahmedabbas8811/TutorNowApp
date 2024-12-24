import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Import the intl package for time formatting.

class EditAvailabilityScreen extends StatefulWidget {
  @override
  _EditAvailabilityScreenState createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final Map<String, bool> _availability = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': true,
  };

  // Initial time slots for each day
  final Map<String, List<List<TimeOfDay>>> _timeSlots = {
    'Monday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
    'Tuesday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
    'Wednesday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
    'Thursday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
    'Friday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
    'Saturday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
    'Sunday': [
      [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchAvailability();
  }

  // Fetch availability from the database
  Future<void> _fetchAvailability() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    try {
      final response =
          await supabase.from('availability').select().eq('user_id', user.id);

      if (response.isNotEmpty) {
        for (var entry in response) {
          final day = entry['day'];
          final isAvailable = entry['is_available'];
          final slots = (entry['slots'] as List).map((slot) {
            final start = TimeOfDay(
              hour: int.parse(slot['start'].split(':')[0]),
              minute: int.parse(slot['start'].split(':')[1]),
            );
            final end = TimeOfDay(
              hour: int.parse(slot['end'].split(':')[0]),
              minute: int.parse(slot['end'].split(':')[1]),
            );
            return [start, end];
          }).toList();

          setState(() {
            _availability[day] = isAvailable;
            _timeSlots[day] = slots;
          });
        }
      }
    } catch (error) {
      print('Failed to fetch availability: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load availability: $error')));
    }
  }

  // Format TimeOfDay as AM/PM format
  String formatTime(TimeOfDay time) {
    final now = DateTime(0, 0, 0, time.hour, time.minute);
    final format = DateFormat.jm(); // AM/PM format
    return format.format(now);
  }

  // Update availability in the database
  Future<void> updateAvailability() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        // Prepare data for upsert
        final Map<String, List<Map<String, String>>> availabilityData =
            _timeSlots.map((day, slots) {
          return MapEntry(
            day,
            slots.map((slot) {
              return {
                'start': "${slot[0].hour}:${slot[0].minute}",
                'end': "${slot[1].hour}:${slot[1].minute}",
              };
            }).toList(),
          );
        });

        // Prepare data for upsert
        final List<Map<String, dynamic>> dataToUpsert =
            availabilityData.entries.map((entry) {
          return {
            'user_id': user.id, // User ID from authentication
            'day': entry.key, // Day (e.g., Monday, Tuesday)
            'slots': entry.value, // List of slots (start and end times)
            'is_available':
                _availability[entry.key]!, // True if switch is on for the day
          };
        }).toList();

        // Perform the upsert operation
        for (var data in dataToUpsert) {
          final day = data['day'];
          final response = await supabase
              .from('availability')
              .upsert(data, onConflict: 'user_id, day')
              .eq('day', day) // Filter records by 'day'
              .eq('user_id', user.id); // Filter records by 'user_id'

          // Check if response is not null and handle the error properly
          if (response != null && response.error != null) {
            print("Error: ${response.error!.message}");
          } else if (response != null) {
            print("Availability updated successfully for $day!");
          }
        }
      } catch (e) {
        print("Failed to update availability: $e");
      }
    } else {
      print("No user is logged in.");
    }
  }
 // Select a time for the time slot
Future<void> _selectTime(
    BuildContext context, String day, int slotIndex, int timeIndex) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: _timeSlots[day]![slotIndex][timeIndex],
  );

  if (pickedTime != null) {
    final TimeOfDay startTime = _timeSlots[day]![slotIndex][0];
    final TimeOfDay endTime = _timeSlots[day]![slotIndex][1];

    setState(() {
      if (timeIndex == 0) {
        // Validate start time
        if (pickedTime.hour > endTime.hour ||
            (pickedTime.hour == endTime.hour && pickedTime.minute < endTime.minute)) {
          _timeSlots[day]![slotIndex][timeIndex] = pickedTime;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Start time must be earlier than end time.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (timeIndex == 1) {
        // Validate end time
        if (pickedTime.hour > startTime.hour ||
            (pickedTime.hour == startTime.hour && pickedTime.minute > startTime.minute)) {
          _timeSlots[day]![slotIndex][timeIndex] = pickedTime;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('End time must be later than start time.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }
}


  // Add a new time slot for a day
  void _addTimeSlot(String day) {
    setState(() {
      _timeSlots[day]!
          .add([TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Edit Availability',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  String day = _days[index];
                  bool isAvailable = _availability[day]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isAvailable ? Colors.black : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children: List.generate(
                                  _timeSlots[day]!.length,
                                  (slotIndex) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: isAvailable
                                                ? () => _selectTime(
                                                    context, day, slotIndex, 0)
                                                : null,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: isAvailable
                                                        ? Colors.black
                                                        : Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                formatTime(
                                                    _timeSlots[day]![slotIndex]
                                                        [0]),
                                                style: TextStyle(
                                                  color: isAvailable
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('-'),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: isAvailable
                                                ? () => _selectTime(
                                                    context, day, slotIndex, 1)
                                                : null,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: isAvailable
                                                        ? Colors.black
                                                        : Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                formatTime(
                                                    _timeSlots[day]![slotIndex]
                                                        [1]),
                                                style: TextStyle(
                                                  color: isAvailable
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: isAvailable
                                      ? () => _addTimeSlot(day)
                                      : null,
                                  child: Text(
                                    'Add Availability +',
                                    style: TextStyle(
                                      color: isAvailable
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: _timeSlots[day]!.length * 60.0 +
                                  40.0, // Adjust dynamically
                              child: Center(
                                child: Switch(
                                  value: isAvailable,
                                  activeColor: Colors.black,
                                  activeTrackColor: const Color(0xff87e64c),
                                  onChanged: (value) {
                                    setState(() {
                                      _availability[day] = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: updateAvailability,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
