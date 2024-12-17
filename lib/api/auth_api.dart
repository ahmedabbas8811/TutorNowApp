import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApi {
  final SupabaseClient supabaseClient;
  AuthApi(this.supabaseClient);

  // * Login
  Future<AuthResponse> login(String email, String password) async {
    final AuthResponse response = await supabaseClient.auth
        .signInWithPassword(email: email, password: password);

    return response;
  }

  // * Sign up
  Future<AuthResponse> signup(
      String name, String email, String password ) async {
    final AuthResponse response = await supabaseClient.auth
        .signUp(email: email, password: password, data: {"name": name});

    return response;
  }

  // * Change Password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    // Re-authenticate the user using their current password
    final email = supabaseClient.auth.currentUser?.email;

    if (email == null) throw Exception("User not logged in");

    await supabaseClient.auth.signInWithPassword(
      email: email,
      password: currentPassword,
    );

    // Update the password after successful re-authentication
    await supabaseClient.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}




