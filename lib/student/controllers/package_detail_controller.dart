import 'package:get/get.dart';
import 'package:newifchaly/student/models/package_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PackageDetailController extends GetxController {
  var isLoading = true.obs; // observable loading indicator
  final int packageId; // required package id parameter

  PackageDetailController({required this.packageId});

  @override
  void onInit() {
    super.onInit();
    fetchPackageById(
        packageId); // fetch package when the controller is initialized
  }

  var package = PackageModel(
    id: 0,
    title: '',
    price: 0,
    description: '',
    hours: 0,
    minutes: 0,
    weeks: 0,
    sessions: 0,
  ).obs;

  void resetProfile() {
    package.value = PackageModel(
      id: 0,
      title: '',
      price: 0,
      description: '',
      hours: 0,
      minutes: 0,
      weeks: 0,
      sessions: 0,
    );
  }

  Future<void> fetchPackageById(int id) async {
    try {
      isLoading.value = true;
      final response = await Supabase.instance.client
          .from('packages')
          .select()
          .eq('id', id)
          .single();

      print("Response from packages table is $response");

      if (response != null) {
        package.value = PackageModel.fromJson(response);
      } else {
        print("No package found with the given ID.");
      }
    } catch (e) {
      print("Error fetching package: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
