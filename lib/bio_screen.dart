import 'package:flutter/material.dart';
import 'package:newifchaly/location2_screen.dart';
import 'package:newifchaly/location_screen.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BioScreen extends StatefulWidget {
  @override
  _BioScreenState createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  // Controller for the text field
  final TextEditingController _bioController = TextEditingController();
  
  bool _isLoading = false;
  String _message = '';

   @override
  void initState() {
    super.initState();

    // Check if location step is already completed and restrict access
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _isBioCompleted()) {
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

   Future<bool> _isBioCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        
        final response = await Supabase.instance.client
            .from('profile_completion_steps')
            .select('bios')
            .eq('user_id', user.id)
            .maybeSingle();
            print("Response: $response");


        if (response != null && response['bios'] == true) {
          print("Bio step is already completed.");
          return true; // Step is already completed
        } else {
          print("Bio step is not completed.");
        }
      } catch (e) {
        print("Error checking bio status: $e");
      }
    }
    return false; // Step is not completed
  }

  // Function to save bio to Supabase
  Future<void> _saveBio() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final String bio = _bioController.text.trim();
      final currentUser = Supabase.instance.client.auth.currentUser;

      if (bio.isEmpty) {
        throw Exception('Bio cannot be empty!');
      }

      // Replace 'bios' with your table name
      final response = await Supabase.instance.client
          .from('bios')
          .insert({'bio': bio, 'userid' : currentUser!.id });

       await Supabase.instance.client
              .from('profile_completion_steps')
              .update({'bios': true}).eq('user_id', currentUser.id);
          print("Bio step updated successfully.");
          Navigator.push(
            context, MaterialPageRoute(builder: (_) => Location2Screen()));

      setState(() {
        _message = 'Bio saved successfully!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    _bioController.dispose();
    super.dispose();
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
        Text(
          'Add Bio',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _bioController,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              borderSide: BorderSide(color: Colors.grey), // Purple border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 2), // Purple border on focus
            ),
            hintText: 'Explain yourself in 2-3 lines...',
          ),
        ),
        SizedBox(height: 30), // Space between TextField and Next button
        Center(
          child: SizedBox(
            width: 360, // Custom button width
            height: 50, // Custom button height
            child: ElevatedButton(
              onPressed: _saveBio,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff87e64c),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
  }
}