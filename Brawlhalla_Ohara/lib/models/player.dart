class Player {
  final int brawlhallaId;
  final String name;
  final int xp;
  final int level;
  final double xpPercentage;
  final int games;
  final int wins;
  final List<LegendStat> legends;
  final ClanInfo clan;
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
    return Player(
      brawlhallaId: json['brawlhalla_id'],
      name: json['name'],
      xp: json['xp'],
      level: json['level'],
      xpPercentage: json['xp_percentage'].toDouble(),
      games: json['games'],
      wins: json['wins'],
      legends: List<LegendStat>.from(json['legends'].map((x) => LegendStat.fromJson(x))),
      clan: ClanInfo.fromJson(json['clan']),
      rating: json['rating'],
      peakRating: json['peak_rating'],
      tier: json['tier'],
      teams2v2: List<Team>.from(json['2v2'].map((x) => Team.fromJson(x))),
      globalRank: json['global_rank'],
      regionRank: json['region_rank'],
      lastSynced: DateTime.fromMillisecondsSinceEpoch(json['lastSynced']),
    );
  }
}

class LegendStat {
  final int legendId;
  final String legendNameKey;
  final int xp;
  final int level;
  final int matchTime;
  final int games;
  final int wins;
  final int xpPercentage;

  LegendStat({
    required this.legendId,
    required this.legendNameKey,
    required this.xp,
    required this.level,
    required this.matchTime,
    required this.games,
    required this.wins,
    required this.xpPercentage,
  });

  factory LegendStat.fromJson(Map<String, dynamic> json) {
    return LegendStat(
      legendId: json['legend_id'],
      legendNameKey: json['legend_name_key'],
      xp: json['xp'],
      level: json['level'],
      matchTime: json['matchtime'],
      games: json['games'],
      wins: json['wins'],
      xpPercentage: json['xp_percentage'],
    );
  }
}


class ClanInfo {
  final String clanName;
  final int clanId;
  final String clanXp;
  final String personalXp;

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
