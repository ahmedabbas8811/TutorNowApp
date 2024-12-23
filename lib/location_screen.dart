

import 'package:flutter/material.dart';
import 'package:newifchaly/cnic_screen.dart';
import 'package:newifchaly/province_city_dropdown.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
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

  Future<bool> _storeLocation() async {
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
        return true;
      } catch (e) {
        print("Error storing location: $e");
        return false;
      }
    }
    else if(_state ==null){
    showCustomSnackBar(context, "Please select a province");
    return false;
    }
    else if(_city == null){
      showCustomSnackBar(context, "Please select a city");
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    // Check if location step is already completed and restrict access
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isLocationCompleted()) {
   
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
                    bool isLocationStored = await _storeLocation(); // Store location and update status
                    if (isLocationStored==true){
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