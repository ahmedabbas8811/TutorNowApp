import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        _buildCardList([
          {'title': 'Ali', 'subtitle': 'Great tutor, very helpful!'},
          {'title': 'Sara', 'subtitle': 'Explains concepts well.'},
        ]),
      ],
    );
  }

  Widget _buildCardList(List<Map<String, String>> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(items[index]['title']!),
            subtitle: Text(items[index]['subtitle']!),
          ),
        );
      },
    );
  }
}
