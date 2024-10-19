import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ednruyxcytmxfounwodq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVkbnJ1eXhjeXRteGZvdW53b2RxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjkxMDMxMDMsImV4cCI6MjA0NDY3OTEwM30.qHxnt4-2XEEo6rlqzzvgDh5avvtLfR3owzjNqWyX5xY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
