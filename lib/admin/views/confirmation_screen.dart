import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'personal_information.dart';
import 'qualification_information.dart';
import 'experience_information.dart';

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
  String userLocation = '';
  String userCountry = '';
  String userState = '';
  String userCity = '';

  @override
  void initState() {
    super.initState();
    fetchTutorDetails();
  }

  Future<void> fetchTutorDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('users') // Replace with your actual table name
          .select('metadata, email',) // Fetch name and email
          .eq('id', widget.tutorId)
          .single(); // Ensure only one record is fetched

      setState(() {
        final metadata = response['metadata'] ?? {};
        tutorName = metadata['name'] ?? 'Unknown Tutor';
        userMail = response['email'] ?? 'No Email Found';
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
          .from('location') // Replace with your actual table name
          .select('country, state, city',) // Fetch name and email
          .eq('user_id', widget.tutorId)
          .single(); // Ensure only one record is fetched

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
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 1,
                    child: QualificationInformation(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 1,
                    child: ExperienceInformation(),
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
