import 'package:get/get.dart';
import 'package:newifchaly/utils/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  @override
  void onInit() async {
    await Supabase.initialize(url: appUrl, anonKey: appKey);

    super.onInit();
  }

  // * Supabase instance
  static final SupabaseClient supabase = Supabase.instance.client;
}
