import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newifchaly/login_screen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/storage_service.dart';
import 'package:newifchaly/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // * Init storage
  await GetStorage.init();

  // * Supabase service initialize
  await Get.putAsync<SupabaseService>(() async => SupabaseService());

  // Debugging: Print the session value
  print("User session: ${StorageService.getUserSession}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // Dynamically determine the initial route
      initialRoute: StorageService.getUserSession != null ? '/home' : '/login',
      // Define the routes
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => ProfileScreen(),
      },
    );
  }
}
