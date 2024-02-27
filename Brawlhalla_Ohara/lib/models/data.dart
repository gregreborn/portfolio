class Data {
  final List<Ranking> rankings;
  final MetaAnalysis metaAnalysis;

  Data({required this.rankings, required this.metaAnalysis});

// Assuming MetaAnalysis is another model that holds the results of your meta analysis
// This could include fields like mostPopularLegend and mostPopularWeapon
}

class Ranking {
  final int rank;
  final String name;
  final int brawlhallaId;
  final int rating;
  final String tier;
  final int games;
  final int wins;
  final String region;
  final int peakRating;

  Ranking({
    required this.rank,
    required this.name,
    required this.brawlhallaId,
    required this.rating,
    required this.tier,
    required this.games,
    required this.wins,
    required this.region,
    required this.peakRating,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      rank: json['rank'],
      name: json['name'],
      brawlhallaId: json['brawlhalla_id'],
      rating: json['rating'],
      tier: json['tier'],
      games: json['games'],
      wins: json['wins'],
      region: json['region'],
      peakRating: json['peak_rating'],
    );
  }
}

class Ranking2v2 {
  final int rank;
  final String teamName;
  final int brawlhallaIdOne;
  final int brawlhallaIdTwo;
  final int rating;
  final String tier;
  final int wins;
  final int games;
  final String region;
  final int peakRating;

  Ranking2v2({
    required this.rank,
    required this.teamName,
    required this.brawlhallaIdOne,
    required this.brawlhallaIdTwo,
    required this.rating,
    required this.tier,
    required this.wins,
    required this.games,
    required this.region,
    required this.peakRating,
  });

  factory Ranking2v2.fromJson(Map<String, dynamic> json) {
    return Ranking2v2(
      rank: json['rank'],
      teamName: json['teamname'],
      brawlhallaIdOne: json['brawlhalla_id_one'],
      brawlhallaIdTwo: json['brawlhalla_id_two'],
      rating: json['rating'],
      tier: json['tier'],
      wins: json['wins'],
      games: json['games'],
      region: json['region'],
      peakRating: json['peak_rating'],
    );
  }
}


class MetaAnalysis {
  final String mostPopularLegend;
  final String mostPopularWeapon;

  MetaAnalysis({required this.mostPopularLegend, required this.mostPopularWeapon});

  /*factory MetaAnalysis.fromRankingList(List<Ranking> rankings) {
    // Logic to analyze 1v1 rankings and determine the most popular legend and weapon
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

  factory MetaAnalysis.fromRankingList2v2(List<Ranking2v2> rankings) {
    // Logic to analyze 2v2 rankings and determine the most popular legend and weapon
    // This is a simplified example. You'll need to aggregate and analyze the data accordingly.
    Map<String, int> legendCounts = {};
    Map<String, int> weaponCounts = {};

    for (var ranking in rankings) {
      // Assuming each player in a team uses the same legend and weapon
      String legendKey = '${ranking.brawlhallaIdOne}-${ranking.brawlhallaIdTwo}';
      String weaponKey = '${ranking.brawlhallaIdOne}-${ranking.brawlhallaIdTwo}';

      legendCounts[legendKey] = (legendCounts[legendKey] ?? 0) + 1;
      weaponCounts[weaponKey] = (weaponCounts[weaponKey] ?? 0) + 1;
    }

    String mostPopularLegend = legendCounts.keys.reduce((a, b) => legendCounts[a]! > legendCounts[b]! ? a : b);
    String mostPopularWeapon = weaponCounts.keys.reduce((a, b) => weaponCounts[a]! > weaponCounts[b]! ? a : b);

    return MetaAnalysis(mostPopularLegend: mostPopularLegend, mostPopularWeapon: mostPopularWeapon);
  }*/
}

