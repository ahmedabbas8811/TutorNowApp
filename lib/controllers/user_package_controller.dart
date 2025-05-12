import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_package_model.dart';

class UserPackageController extends GetxController {
  var isLoading = true.obs;
  var packages = <UserPackageModel>[].obs;

  Future<void> fetchUserPackages() async {
    isLoading.value = true;

    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      isLoading.value = false;
      return;
    }

    final response = await Supabase.instance.client
        .from('packages')
        .select()
        .eq('user_id', userId)
        .order('id', ascending: false);

    packages.value = (response as List)
        .map((e) => UserPackageModel.fromJson(e))
        .toList();

    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchUserPackages();
    super.onInit();
  }
}
