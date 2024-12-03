import 'package:flutter/material.dart';
import 'package:newifchaly/admin/views/personal_information.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'confirmation_screen.dart';

class ApproveTutorsScreen extends StatefulWidget {
  const ApproveTutorsScreen({super.key});

  @override
  _ApproveTutorsScreenState createState() => _ApproveTutorsScreenState();
}

class _ApproveTutorsScreenState extends State<ApproveTutorsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> tutors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTutors();
  }

  Future<void> fetchTutors() async {
    try {
      // Query to fetch tutors with user_type 'Tutor' and extract id and metadata
      final response = await supabase
          .from('users')
          .select('id, metadata, is_verified')
          .match({'user_type': 'Tutor', 'is_verified': false});

      if (response != null) {
        setState(() {
          tutors = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching tutors: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  child: ListTile(
                    leading: Image.asset(
                      'assets/ali.png', // Path to your image
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
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
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text(
                      'Approve Tutors',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: const Color.fromARGB(255, 243, 242, 242),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Tutor Name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Tutor ID',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 242, 242),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : tutors.isEmpty
                              ? const Center(child: Text('No tutors found.'))
                              : ListView.builder(
                                  itemCount: tutors.length,
                                  itemBuilder: (context, index) {
                                    final tutor = tutors[index];
                                    final name = tutor['metadata']?['name'] ??
                                        'Unknown Name';
                                    final id = tutor['id'] ?? 'Unknown ID';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              id,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff87e64c),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmationScreen(tutorId: id,)
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'View Details',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
