import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/package_detail_controller.dart';
import 'package:newifchaly/student/models/package_model.dart';
import 'package:newifchaly/student/views/package_detail.dart';

class PackagesSection extends StatelessWidget {
  final List<PackageModel> packages;
  final bool isLoading;
  final String userId;

  void _navigateToDetails(BuildContext context, int packageId) {
    Get.delete<PackageDetailController>();

    final PackageDetailController _packagesController =
        Get.put(PackageDetailController(packageId: packageId));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageDetailScreen(
          packageId: packageId,
          userId: userId,
        ),
      ),
    );
  }

  const PackagesSection({
    Key? key,
    required this.packages,
    required this.isLoading, required this.userId,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Packages', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else if (packages.isEmpty)
          Text('No packages available')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(package.title, style: TextStyle(fontSize: 14)), 
                        Text(
                          '${package.price}/- PKR',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), 
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today, size: 18), 
                          const SizedBox(width: 4),
                          Text('${package.weeks} Weeks', style: TextStyle(fontSize: 14)), 
                          const SizedBox(width: 16), 
                          const Icon(Icons.repeat, size: 18), 
                          const SizedBox(width: 4),
                          Text('${package.sessions}X / Week', style: TextStyle(fontSize: 14)), 
                        ],
                      ),
                    ),
                    onTap: () => _navigateToDetails(context, package.id),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

