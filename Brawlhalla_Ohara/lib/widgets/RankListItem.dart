// RankListItem.dart
import 'package:flutter/material.dart';

class RankListItem extends StatelessWidget {
  final int rank;
  final String playerName;
  final String winLoss;
  final int seasonRating;


  const RankListItem({
    Key? key,
    required this.rank,
    required this.playerName,
    required this.winLoss,
    required this.seasonRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Text('#$rank', style: theme.textTheme.titleLarge),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(playerName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4.0),
                  Text('Wins: $winLoss', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Season Rating: $seasonRating', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 4.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
