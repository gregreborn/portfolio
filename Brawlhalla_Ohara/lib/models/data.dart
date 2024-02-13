class Data {
  final List<Ranking> rankings;
  final MetaAnalysis metaAnalysis;

  Data({required this.rankings, required this.metaAnalysis});

// Assuming MetaAnalysis is another model that holds the results of your meta analysis
// This could include fields like mostPopularLegend and mostPopularWeapon
}

class Ranking {
  final String playerId;
  final String playerName;
  final int rank;
  final String legendIdUsed;
  final String weaponUsed;

  Ranking({
    required this.playerId,
    required this.playerName,
    required this.rank,
    required this.legendIdUsed,
    required this.weaponUsed,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      playerId: json['player_id'].toString(),
      playerName: json['player_name'],
      rank: json['rank'],
      legendIdUsed: json['legend_id_used'].toString(),
      weaponUsed: json['weapon_used'],
    );
  }
}

class MetaAnalysis {
  final String mostPopularLegend;
  final String mostPopularWeapon;

  MetaAnalysis({required this.mostPopularLegend, required this.mostPopularWeapon});

  factory MetaAnalysis.fromRankingList(List<Ranking> rankings) {
    // Logic to analyze rankings and determine the most popular legend and weapon
    // This is a simplified example. You'll need to aggregate and analyze the data accordingly.
    Map<String, int> legendCounts = {};
    Map<String, int> weaponCounts = {};

    for (var ranking in rankings) {
      legendCounts[ranking.legendIdUsed] = (legendCounts[ranking.legendIdUsed] ?? 0) + 1;
      weaponCounts[ranking.weaponUsed] = (weaponCounts[ranking.weaponUsed] ?? 0) + 1;
    }

    String mostPopularLegend = legendCounts.keys.reduce((a, b) => legendCounts[a]! > legendCounts[b]! ? a : b);
    String mostPopularWeapon = weaponCounts.keys.reduce((a, b) => weaponCounts[a]! > weaponCounts[b]! ? a : b);

    return MetaAnalysis(mostPopularLegend: mostPopularLegend, mostPopularWeapon: mostPopularWeapon);
  }
}
