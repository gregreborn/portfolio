class Data {
  final List<Ranking> rankings;

  Data({required this.rankings});


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




