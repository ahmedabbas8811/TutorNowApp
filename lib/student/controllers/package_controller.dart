import 'package:get/get.dart';
import 'package:newifchaly/student/models/package_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PackagesController extends GetxController {
  var packages = <PackageModel>[].obs; // Observable list of packages
  var isLoading = true.obs; // Observable loading indicator
  final String? UserId;
  PackagesController({required this.UserId});

  @override
  void onInit() {
    super.onInit();
    fetchPackages(UserId!);
  }

  var profile = PackageModel(
          id: 0,
          title: '',
          price: 0,
          description: '',
          hours: 0,
          minutes: 0,
          weeks: 0,
          sessions: 0,
          user_id: '')
      .obs;
  void resetProfile() {
    profile.value = PackageModel(
        id: 0,
        title: '',
        price: 0,
        description: '',
        hours: 0,
        minutes: 0,
        weeks: 0,
        sessions: 0,
        user_id: '');
  }

  Future<void> fetchPackages(String userId) async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('packages')
          .select()
          .eq('user_id', userId);
      print("response from packages table is $response ");

      if (response.isNotEmpty) {
        packages.value = response.map<PackageModel>((item) {
          return PackageModel.fromJson(item);
        }).toList();
      } else {
        print("No packages found.");
      }
    } catch (e) {
      print("Error fetching packages: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
