

import 'package:flutter/material.dart';
import 'package:newifchaly/cnic_screen.dart';
import 'package:newifchaly/province_city_dropdown.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'location2_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _country;
  String? _state;
  String? _city;

  // Function to check if the location step is already completed
  Future<bool> _isLocationCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        // Check if location is marked true in the profile_completion_steps table
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('location')
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null && response['location'] == true) {
          print("Location step is already completed.");
          return true; // Step is already completed
        } else {
          print("Location step is not completed.");
        }
      } catch (e) {
        print("Error checking location status: $e");
      }
    }
    return false; // Step is not completed
  }

  Future<void> _storeLocation() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && _state != null && _city != null) {
      try {
        // Store location in the location table
        await Supabase.instance.client.from('location').insert({
          'state': _state,
          'city': _city,
          'user_id': user.id,
        });

        // Ensure entry exists in profile_completion_steps for this user
        final profileStep = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle(); // Changed to maybeSingle() to handle no rows found

        if (profileStep == null) {
          // Insert a new entry if none exists
          await Supabase.instance.client
              .from('profile_completion_steps')
              .insert({
            'user_id': user.id,
            'location': true, // Mark location as completed
          });
          print("Location step inserted successfully.");
        } else {
          // Update the location status if an entry exists
          await Supabase.instance.client
              .from('profile_completion_steps')
              .update({'location': true}).eq('user_id', user.id);
          print("Location step updated successfully.");
        }
      } catch (e) {
        print("Error storing location: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Check if location step is already completed and restrict access
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isLocationCompleted()) {
        // Navigate to the next screen if the step is already completed
//        Navigator.pushReplacement(
        //        context,
        //      MaterialPageRoute(builder: (context) => Location2Screen()),
        //  );
        final completionData =
            await ProfileCompletionHelper.fetchCompletionData();
        final incompleteSteps =
            ProfileCompletionHelper.getIncompleteSteps(completionData);
        ProfileCompletionHelper.navigateToNextScreen(context, incompleteSteps);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your location',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
                        // Province and City Dropdown
            ProvinceCityDropdown(
              onProvinceSelected: (province) {
                setState(() {
                  _state = province;
                });
              },
              onCitySelected: (city) {
                setState(() {
                  _city = city;
                });
              },
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 10),
            const Spacer(),
            SizedBox(
              width: 330,
              child: ElevatedButton(
                onPressed: () async {
                  if ( _state != null && _city != null) {
                    await _storeLocation(); // Store location and update status
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CnicScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:newifchaly/utils/profile_helper.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'location2_screen.dart';

// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   String? _state;
//   String? _city;

//   Future<bool> _isLocationCompleted() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user != null) {
//       try {
//         final response = await Supabase.instance.client
//             .from('profile_completion_steps')
//             .select('location')
//             .eq('user_id', user.id)
//             .maybeSingle();

//         if (response != null && response['location'] == true) {
//           print("Location step is already completed.");
//           return true;
//         } else {
//           print("Location step is not completed.");
//         }
//       } catch (e) {
//         print("Error checking location status: $e");
//       }
//     }
//     return false;
//   }

//   Future<void> _storeLocation() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user != null && _state != null && _city != null) {
//       try {
//         await Supabase.instance.client.from('location').insert({
//           'state': _state,
//           'city': _city,
//           'user_id': user.id,
//         });

//         final profileStep = await Supabase.instance.client
//             .from('profile_completion_steps')
//             .select('id')
//             .eq('user_id', user.id)
//             .maybeSingle();

//         if (profileStep == null) {
//           await Supabase.instance.client
//               .from('profile_completion_steps')
//               .insert({
//             'user_id': user.id,
//             'location': true,
//           });
//           print("Location step inserted successfully.");
//         } else {
//           await Supabase.instance.client
//               .from('profile_completion_steps')
//               .update({'location': true}).eq('user_id', user.id);
//           print("Location step updated successfully.");
//         }
//       } catch (e) {
//         print("Error storing location: $e");
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (await _isLocationCompleted()) {
//         final completionData =
//             await ProfileCompletionHelper.fetchCompletionData();
//         final incompleteSteps =
//             ProfileCompletionHelper.getIncompleteSteps(completionData);
//         ProfileCompletionHelper.navigateToNextScreen(context, incompleteSteps);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Select your location',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             // Province Dropdown
//             DropdownButtonFormField<String>(
//               hint: const Text('Select Province'),
//               value: _state,
//               onChanged: (value) {
//                 setState(() {
//                   _state = value;
//                 });
//               },
//               items: [
//                 'Province 1',
//                 'Province 2',
//                 'Province 3',
//               ].map((state) {
//                 return DropdownMenuItem(
//                   value: state,
//                   child: Text(state),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.grey), // Grey border
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.grey), // Grey border
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             // City Dropdown
//             DropdownButtonFormField<String>(
//               hint: const Text('Select City'),
//               value: _city,
//               onChanged: (value) {
//                 setState(() {
//                   _city = value;
//                 });
//               },
//               items: [
//                 'City 1',
//                 'City 2',
//                 'City 3',
//               ].map((city) {
//                 return DropdownMenuItem(
//                   value: city,
//                   child: Text(city),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.grey), // Grey border
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.grey), // Grey border
//                 ),
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: 330,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_state != null && _city != null) {
//                     await _storeLocation();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Location2Screen()),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff87e64c),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 12, horizontal: 100),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
