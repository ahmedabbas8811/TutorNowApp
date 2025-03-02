import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/filter_controller.dart';
import 'package:newifchaly/student/models/package_model.dart';
import 'package:newifchaly/student/models/search_model.dart';
import 'package:newifchaly/student/views/tutor_detail.dart';

class FilteredTutor extends StatefulWidget {
  final String? level;
  final String filter_name;
  final int? minPrice;
  final int? maxPrice;

  const FilteredTutor({
    super.key,
    this.level,
    required this.filter_name,
    this.minPrice,
    this.maxPrice,
  });

  @override
  State<FilteredTutor> createState() => _FilteredTutorState();
}

class _FilteredTutorState extends State<FilteredTutor> {
  final FilterController _filterController = FilterController();
  late Future<List<dynamic>> _itemsFuture;

  void _navigateToTutorDetail(String tutorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorDetailScreen(
          userId: tutorId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //check the filter type and fetch data accordingly
    if (widget.filter_name == "level_pref") {
      _itemsFuture = _filterController.getTutorsByEducationLevel(widget.level!);
    } else if (widget.filter_name == "qualification") {
      _itemsFuture = _filterController.getTutorsByQualification(widget.level!);
    } else if (widget.filter_name == "price_range") {
      _itemsFuture = _filterController.getPackagesByPriceRange(
          widget.minPrice!, widget.maxPrice!);
    } else {
      _itemsFuture = Future.value([]); //default empty list
    }
  }

  String _getAppBarTitle() {
    switch (widget.filter_name) {
      case "level_pref":
        return "Tutors by Education Level: ${widget.level}";
      case "qualification":
        return "Tutors by Qualification: ${widget.level}";
      case "price_range":
        return "Packages from ${widget.minPrice} to ${widget.maxPrice} PKR";
      default:
        return "Filtered Results";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: const TextStyle(fontSize: 18)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (widget.filter_name == "price_range") {
                final packageData = item['package'] as PackageModel;
                final tutorName = item['tutor_name'];
                final tutorImage = item['tutor_image'];

                return ListTile(
                  onTap: () => _navigateToTutorDetail(packageData.user_id),
                  leading: CircleAvatar(
                    backgroundImage: tutorImage.isNotEmpty
                        ? NetworkImage(tutorImage)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                  ),
                  title: Text(tutorName),
                  subtitle: Text(
                      "Package: ${packageData.title} - Price: ${packageData.price} PKR"),
                );
              } else {
                //display Tutors
                return ListTile(
                  onTap: () => _navigateToTutorDetail(item.userId),
                  leading: CircleAvatar(
                    backgroundImage: item.imgurl.isNotEmpty
                        ? NetworkImage(item.imgurl)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                  ),
                  title: Text(item.name),
                  subtitle: Text('User ID: ${item.userId}'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
