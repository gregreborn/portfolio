import 'package:flutter/material.dart';

class PlayerStatTile extends StatelessWidget {
  final String statLabel;
  final String statValue;

  const PlayerStatTile({
    Key? key,
    required this.statLabel,
    required this.statValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(statLabel),
      trailing: Text(statValue),
      // Add additional styling or elements as required
    );
  }
}
