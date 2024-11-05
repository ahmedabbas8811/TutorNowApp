import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // * Supabase service initialize
  await Get.putAsync<SupabaseService>(() async => SupabaseService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
