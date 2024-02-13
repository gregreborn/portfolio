import 'package:flutter/material.dart';

class LegendCard extends StatelessWidget {
  final String legendName;
  final String imageUrl;

  const LegendCard({
    Key? key,
    required this.legendName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(imageUrl),
          Text(legendName),
        ],
      ),
      // Customize further as necessary
    );
  }
}
