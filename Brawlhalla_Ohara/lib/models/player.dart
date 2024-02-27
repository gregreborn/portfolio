class Player {
  final int brawlhallaId;
  final String name;
  final int? xp;
  final int? level;
  final double? xpPercentage;
  final int games;
  final int wins;
  final List<LegendStat> legends;
  final ClanInfo? clan;
  final int? rating;
  final int? peakRating;
  final String? tier;
  final List<Team> teams2v2;
  final int? globalRank;
  final int? regionRank;
  final DateTime lastSynced;

  Player({
    required this.brawlhallaId,
    required this.name,
    required this.xp,
    required this.level,
    required this.xpPercentage,
    required this.games,
    required this.wins,
    required this.legends,
    required this.clan,
    this.rating,
    this.peakRating,
    this.tier,
    required this.teams2v2,
    this.globalRank,
    this.regionRank,
    required this.lastSynced,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    var data = json['data'];

    ClanInfo? clanInfo;
    if (data['clan'] != null) {
      var clanData = data['clan'];
      clanInfo = ClanInfo.fromJson(clanData);
    }

    // Handle potential absence of '2v2' and 'legends' lists
    List<Team> teams2v2 = data['2v2'] != null
        ? List.from(data['2v2']).map((x) => Team.fromJson(x)).toList()
        : [];
    List<LegendStat> legends = data['legends'] != null
        ? List<LegendStat>.from(data['legends'].map((x) => LegendStat.fromJson(x)))
        : [];

    return Player(
      brawlhallaId: data['brawlhalla_id'],
      name: data['name'],
      xp: data.containsKey('xp') ? data['xp'] : null,
      level: data.containsKey('level') ? data['level'] : null,
      xpPercentage: data.containsKey('xp_percentage') ? (data['xp_percentage'] as num).toDouble() : null,
      games: data['games'] ?? 0, // Provide default value if missing
      wins: data['wins'] ?? 0, // Provide default value if missing
      legends: legends,
      clan: clanInfo,
      rating: data['rating'],
      peakRating: data['peak_rating'],
      tier: data['tier'],
      teams2v2: teams2v2,
      globalRank: data['global_rank'],
      regionRank: data['region_rank'],
      lastSynced: DateTime.now(), // Consider parsing from 'lastSynced' if it's provided and important
    );
  }



}

class LegendStat {
  final int legendId;
  final String legendNameKey;
  final int? xp; // Make optional
  final int? level; // Make optional
  final int? matchTime; // Make optional
  final int games;
  final int wins;
  final double? xpPercentage; // Make optional
  // New fields for ranked data
  final int? rating;
  final int? peakRating;
  final String? tier;

  LegendStat({
    required this.legendId,
    required this.legendNameKey,
    this.xp,
    this.level,
    this.matchTime,
    required this.games,
    required this.wins,
    this.xpPercentage,
    this.rating,
    this.peakRating,
    this.tier,
  });

  factory LegendStat.fromJson(Map<String, dynamic> json) {
    // Determine if the JSON is for player stats or ranked data based on the presence of certain fields
    bool isRankedData = json.containsKey('rating') && json.containsKey('tier');

    return LegendStat(
      legendId: json['legend_id'],
      legendNameKey: json['legend_name_key'],
      xp: isRankedData ? null : json['xp'],
      level: isRankedData ? null : json['level'],
      matchTime: isRankedData ? null : json['matchtime'],
      games: json['games'] ?? 0,
      wins: json['wins'] ?? 0,
      xpPercentage: isRankedData ? null : json.containsKey('xp_percentage') ? (json['xp_percentage'] as num).toDouble() : null,
      // Parse ranked data fields
      rating: json['rating'],
      peakRating: json['peak_rating'],
      tier: json['tier'],
    );
  }
}



class ClanInfo {
  final String clanName;
  final int clanId;
  final String clanXp;
  final int personalXp;

  ClanInfo({
    required this.clanName,
    required this.clanId,
    required this.clanXp,
    required this.personalXp,
  });

  factory ClanInfo.fromJson(Map<String, dynamic> json) {
    return ClanInfo(
      clanName: json['clan_name'],
      clanId: json['clan_id'],
      clanXp: json['clan_xp'],
      personalXp: json['personal_xp'],
    );
  }
}

class Team {
  final int brawlhallaIdOne;
  final int brawlhallaIdTwo;
  final String teamName;
  final int rating;
  final int peakRating;
  final String tier;

  Team({
    required this.brawlhallaIdOne,
    required this.brawlhallaIdTwo,
    required this.teamName,
    required this.rating,
    required this.peakRating,
    required this.tier,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      brawlhallaIdOne: json['brawlhalla_id_one'],
      brawlhallaIdTwo: json['brawlhalla_id_two'],
      teamName: json['teamname'],
      rating: json['rating'],
      peakRating: json['peak_rating'],
      tier: json['tier'],
    );
  }
}
