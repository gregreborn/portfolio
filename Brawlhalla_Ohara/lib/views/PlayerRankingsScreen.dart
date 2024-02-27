import 'package:flutter/material.dart';
import '../models/player.dart';

class RankingsScreen extends StatelessWidget {
  final Player? rankedData;

  const RankingsScreen({Key? key, this.rankedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the highest 2v2 team based on rating
    final highest2v2 = rankedData?.teams2v2.reduce((current, next) => current.rating > next.rating ? current : next);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text('Rankings for ${rankedData?.name ?? "Unknown"}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
          ),
          _buildListTile(context, 'Player ID', '${rankedData?.brawlhallaId ?? "N/A"}'),
          _buildListTile(context, 'Global Rank', '${rankedData?.globalRank ?? "N/A"}'),
          _buildListTile(context, 'Region Rank', '${rankedData?.regionRank ?? "N/A"}'),
          if (highest2v2 != null) ListTile(
            title: Text('Highest 2v2 Team: ${highest2v2.teamName}', style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text('Rating: ${highest2v2.rating}, Peak Rating: ${highest2v2.peakRating}', style: Theme.of(context).textTheme.bodyMedium),
          ),
          _buildListTile(context, 'Rating', '${rankedData?.rating ?? "N/A"}'),
          _buildListTile(context, 'Peak Rating', '${rankedData?.peakRating ?? "N/A"}'),
          ListTile(
            title: Text('Tier: ${rankedData?.tier ?? "N/A"}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.secondary)), // Emphasize tier
          ),
          _buildListTile(context, 'Wins', '${rankedData?.wins ?? "N/A"}'),
          _buildListTile(context, 'Games', '${rankedData?.games ?? "N/A"}'),
          _buildListTile(context, 'Region', '${rankedData?.regionRank ?? "N/A"}'),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String title, String subtitle) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
