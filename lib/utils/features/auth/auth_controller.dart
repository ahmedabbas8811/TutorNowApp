import 'dart:developer';

import 'package:get/get.dart';
import 'package:newifchaly/api/auth_api.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  late AuthApi authApi;
  RxBool loginLoading = false.obs;
  RxBool signupLoading = false.obs;

  @override
  void onInit() {
    authApi = AuthApi(SupabaseService.supabase);

    super.onInit();
  }

  // * login method
  void login(String email, String password) async {
    loginLoading.value = true;
    final AuthResponse response = await authApi.login(email, password);
    loginLoading.value = false;
    log("The login response is ${response.user?.toJson()}");
    final session = Supabase.instance.client.auth.currentSession;


  }

  // * signup method
  void signup(String name, email, String password) async {
    signupLoading.value = true;
    final AuthResponse response = await authApi.signup(name, email, password);
    signupLoading.value = false;
    log("The Sign Up response is ${response.user?.toJson()}");
  }

  

}

