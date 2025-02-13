import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Number of placeholder items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                CircleAvatar(radius: 25, backgroundColor: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 12,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
