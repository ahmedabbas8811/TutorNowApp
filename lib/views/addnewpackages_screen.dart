import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/controllers/addpackage_controller.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/models/addpackage_model.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';

class AddNewPackagesScreen extends StatefulWidget {
  @override
  _AddNewPackagesScreenState createState() => _AddNewPackagesScreenState();
}

class _AddNewPackagesScreenState extends State<AddNewPackagesScreen> {
  final AddPackageController _controller = Get.put(AddPackageController());

  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _packageDescriptionController =
      TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _sessionsPerWeekController =
      TextEditingController();
  final TextEditingController _numberOfWeeksController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvailabilityScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SessionScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EarningsScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonScreen()),
        );
        break;
    }
  }

  Future<void> _savePackage() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      showCustomSnackBar(context, 'User not logged in.');
      return;
    }

    if (_packageNameController.text.isEmpty) {
      showCustomSnackBar(context, 'Package name cannot be empty.');
      return;
    }

    if (_packageDescriptionController.text.isEmpty) {
      showCustomSnackBar(context, 'Package description cannot be empty.');
      return;
    }
    if (_packageDescriptionController.text.length > 150) {
      showCustomSnackBar(
          context, 'Package description cannot exceed 150 characters.');
      return;
    }

    if (_hoursController.text.isEmpty || _minutesController.text.isEmpty) {
      showCustomSnackBar(context, 'Please specify both hours and minutes.');
      return;
    }

    int hours = int.tryParse(_hoursController.text) ?? -1;
    int minutes = int.tryParse(_minutesController.text) ?? -1;
    if (hours < 0 || minutes < 0) {
      showCustomSnackBar(
          context, 'Hours and minutes must be non-negative integers.');
      return;
    }

    if (minutes >= 60) {
      showCustomSnackBar(context, 'Minutes should be between 0 and 59.');
      return;
    }

    if (hours == 0 && minutes == 0) {
      showCustomSnackBar(
          context, 'The session duration must be greater than zero.');
      return;
    }

    if (_sessionsPerWeekController.text.isEmpty) {
      showCustomSnackBar(context, 'Sessions per week cannot be empty.');
      return;
    }

    int sessionsPerWeek = int.tryParse(_sessionsPerWeekController.text) ?? 0;
    if (sessionsPerWeek <= 0 || sessionsPerWeek > 6) {
      showCustomSnackBar(context, 'Sessions per week must be between 1 and 6.');
      return;
    }

    if (_numberOfWeeksController.text.isEmpty) {
      showCustomSnackBar(context, 'Number of weeks cannot be empty.');
      return;
    }

    int numberOfWeeks = int.tryParse(_numberOfWeeksController.text) ?? 0;
    if (numberOfWeeks <= 0) {
      showCustomSnackBar(context, 'Number of weeks must be greater than zero.');
      return;
    }

    if (_priceController.text.isEmpty) {
      showCustomSnackBar(context, 'Price cannot be empty.');
      return;
    }

    int price = int.tryParse(_priceController.text) ?? 0;
    if (price <= 0) {
      showCustomSnackBar(context, 'Price must be greater than zero.');
      return;
    }

    final package = AddPackageModel(
      packageName: _packageNameController.text,
      packageDescription: _packageDescriptionController.text,
      hoursPerSession: hours,
      minutesPerSession: minutes,
      sessionsPerWeek: sessionsPerWeek,
      numberOfWeeks: numberOfWeeks,
      price: price,
      userId: user.id,
    );

    int? packageId = await _controller.addPackage(package);
    if (packageId != null) {
      showCustomSnackBar(context, 'Package added successfully!');
    } else {
      showCustomSnackBar(context, 'Failed to add package.');
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff87e64c)),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const Text(
                'Add New Package',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Package Name',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _packageNameController,
                decoration: _inputDecoration('Basic package'),
              ),
              const SizedBox(height: 16),
              const Text('Package Description',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _packageDescriptionController,
                maxLines: 3,
                decoration: _inputDecoration(
                    'Tell students why they should purchase this package\n'
                    'Add key features of your sessions\n'),
              ),
              const SizedBox(height: 16),
              const Text('Duration Of Each Session',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('1 (Hours)'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('30 (Minutes)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Session Per Week',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _sessionsPerWeekController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('5'),
              ),
              const SizedBox(height: 16),
              const Text('Number of Weeks',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _numberOfWeeksController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('4'),
              ),
              const SizedBox(height: 16),
              const Text('Price',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('10,000-/PKR'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _savePackage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff87e64c),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          Obx(() => TutorBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              pendingBookingsCount:
                  profileController.pendingBookingsCount.value)),
        ],
      ),
    );
  }
}
