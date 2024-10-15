import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vgmozfdlyvgbrbmyxtae.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZnbW96ZmRseXZnYnJibXl4dGFlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg5MzQ3MzEsImV4cCI6MjA0NDUxMDczMX0.PswuUCQPndx4h6J-Xn78xe-lmV44eyUd7es8O8uhLUU',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
