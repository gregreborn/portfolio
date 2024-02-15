class Player {
  final int brawlhallaId;
  final String name;
  final int xp;
  final int level;
  final double xpPercentage;
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
      if (clanData is Map<String, dynamic>) {
        clanInfo = ClanInfo.fromJson(clanData);
      }
    }

    List<Team> teams2v2 = [];
    if (data['2v2'] != null && data['2v2'] is List) {
      teams2v2 = List.from(data['2v2']).map((x) => Team.fromJson(x as Map<String, dynamic>)).toList();
    }

    return Player(
      brawlhallaId: data['brawlhalla_id'],
      name: data['name'],
      xp: data['xp'],
      level: data['level'],
      xpPercentage: (data['xp_percentage'] as num).toDouble(),
      games: data['games'],
      wins: data['wins'],
      legends: List<LegendStat>.from(data['legends'].map((x) => LegendStat.fromJson(x))),
      clan: clanInfo,
      rating: data['rating'],
      peakRating: data['peak_rating'],
      tier: data['tier'],
      teams2v2: teams2v2,
      globalRank: data['global_rank'],
      regionRank: data['region_rank'],
      lastSynced: DateTime.now(), // Placeholder for actual logic
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
  final double xpPercentage;

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
      xpPercentage: (json['xp_percentage'] as num).toDouble(),
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
