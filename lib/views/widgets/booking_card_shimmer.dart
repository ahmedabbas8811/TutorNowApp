import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(radius: 4, backgroundColor: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.timer, size: 18, color: Colors.white),
                    Container(
                      width: 50,
                      height: 14,
                      color: Colors.white,
                    ),
                  ]),
                  Row(children: [
                    Icon(Icons.refresh, size: 18, color: Colors.white),
                    Container(
                      width: 50,
                      height: 14,
                      color: Colors.white,
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.white),
                    Container(
                      width: 50,
                      height: 14,
                      color: Colors.white,
                    ),
                  ]),
                  Row(children: [
                    Icon(Icons.attach_money, size: 18, color: Colors.white),
                    Container(
                      width: 50,
                      height: 14,
                      color: Colors.white,
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}