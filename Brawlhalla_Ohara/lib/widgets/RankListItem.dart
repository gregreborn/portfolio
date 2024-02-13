import 'package:flutter/material.dart';

class RankListItem extends StatelessWidget {
  final int rank;
  final String playerName;
  final String playerScore;

  const RankListItem({
    Key? key,
    required this.rank,
    required this.playerName,
    required this.playerScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('#$rank'),
        SizedBox(width: 8.0),
        Text(playerName),
        Spacer(),
        Text(playerScore),
      ],
      // Add any custom styling or interactivity
    );
  }
}
