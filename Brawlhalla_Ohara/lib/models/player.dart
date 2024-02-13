class Player {
  final String brawlhallaId;
  final String name;
  final int level;
  final int xp;
  final int games;
  final int wins;

  Player({required this.brawlhallaId, required this.name, required this.level, required this.xp, required this.games, required this.wins});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      brawlhallaId: json['brawlhalla_id'].toString(),
      name: json['name'],
      level: json['level'],
      xp: json['xp'],
      games: json['games'],
      wins: json['wins'],
    );
  }

  Map<String, dynamic> toJson() => {
    'brawlhalla_id': brawlhallaId,
    'name': name,
    'level': level,
    'xp': xp,
    'games': games,
    'wins': wins,
  };
}
