import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'personal_information.dart';
import 'qualification_information.dart';
import 'experience_information.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmationScreen extends StatelessWidget {
  final String tutorId;

  const ConfirmationScreen({super.key, required this.tutorId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            SideMenu(),
            Expanded(
              child: ConfirmationTutorsScreen(tutorId: tutorId),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/ali.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            color: const Color(0xfffafafa),
            child: const ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: Text('Home'),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            color: Colors.black,
            child: const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.white),
              title: Text(
                'Approve Tutors',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationTutorsScreen extends StatefulWidget {
  final String tutorId;

  const ConfirmationTutorsScreen({super.key, required this.tutorId});

  @override
  _ConfirmationTutorsScreenState createState() => _ConfirmationTutorsScreenState();
}

class _ConfirmationTutorsScreenState extends State<ConfirmationTutorsScreen> {
  String tutorName = '';
  String userMail = '';
  String userCnicUrl = '';
  String userLocation = '';
  String userCountry = '';
  String userState = '';
  String userCity = '';

  @override
  void initState() {
    super.initState();
    fetchTutorDetails();
  }

Future<void> updateTutorVerification() async {
  final rows = await Supabase.instance.client
    .from('users')
    .select('*')
    .eq('id', widget.tutorId);
print(rows);

  try {
    // Perform the update operation and fetch updated rows
    final response = await Supabase.instance.client
        .from('users') // Replace with your table name
        .update({'is_verified': true})
        .eq('id', widget.tutorId)
        .select(); // Fetch updated rows (if needed)

    // Check if the response is non-empty (indicating success)
    if (response.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutor successfully verified!')),
      );
    } else {
      // Handle case where no rows were updated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No matching tutor found.')),
      );
    }
  } catch (e) {
    // Handle any unexpected errors
    print('Error updating tutor verification: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error verifying tutor.')),
    );
  }
}

  Future<void> fetchTutorDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('users') // Replace with your actual table name
          .select('metadata, email, cnic_url',) // Fetch name and email
          .eq('id', widget.tutorId)
          .single(); // Ensure only one record is fetched

      setState(() {
        final metadata = response['metadata'] ?? {};
        tutorName = metadata['name'] ?? 'Unknown Tutor';
        userMail = response['email'] ?? 'No Email Found';
        userCnicUrl = response['cnic_url'] ?? 'No Cnic Found';
      });
    } catch (e) {
      print('Error fetching tutor details: $e');
      setState(() {
        tutorName = 'Error fetching name';
        userMail = 'Error fetching email';
      });
    }
     try {
      final response = await Supabase.instance.client
          .from('location') 
          .select('country, state, city',)  
          .eq('user_id', widget.tutorId)
          .single();  

      setState(() {
        userCountry = response['country'] ?? 'No country Found';
        userCity = response['city'] ?? 'No country Found';
        userState = response['state'] ?? 'No country Found';
        userLocation = '$userCity, $userState, $userCountry';
      });
    } catch (e) {
      print('Error fetching tutor details: $e');
      setState(() {
        userCountry= 'Error fetching country';
        userCity = 'Error fetching city';
        userState = 'Error fetching state';
      });
    }
  
  }


  Future<void> openCNIC() async {
    if (userCnicUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CNIC URL not available')),
      );
      return;
    }

    try {
      final bucketName = 'cnic'; // Replace with your bucket name
      final publicUrl = userCnicUrl;

      if (await canLaunchUrl(Uri.parse(publicUrl))) {
        await launchUrl(Uri.parse(publicUrl), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $publicUrl';
      }
    } catch (e) {
      print('Error opening CNIC: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening CNIC')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Approve Tutors',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: PersonalInformation(
                      userId: widget.tutorId,
                      userName: tutorName,
                      userMail: userMail,
                      userLocation: userLocation,
                      onDownloadPressed: openCNIC,
                      onApprovePressed: updateTutorVerification,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: QualificationInformation(tutorId: widget.tutorId),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: ExperienceInformation(tutorId: widget.tutorId),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
