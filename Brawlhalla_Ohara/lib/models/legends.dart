class Legend {
  final int legendId;
  final String legendNameKey;
  final String bioName;
  final String bioAka;
  final String weaponOne;
  final String weaponTwo;
  final int strength;
  final int dexterity;
  final int defense;
  final int speed;
  final String bioQuote;
  final String bioQuoteAboutAttrib;
  final String bioQuoteFrom;
  final String bioQuoteFromAttrib;
  final String bioText;
  final String botName;
  final String thumbnail;

  Legend({
    required this.legendId,
    required this.legendNameKey,
    required this.bioName,
    required this.bioAka,
    required this.weaponOne,
    required this.weaponTwo,
    required this.strength,
    required this.dexterity,
    required this.defense,
    required this.speed,
    required this.bioQuote,
    required this.bioQuoteAboutAttrib,
    required this.bioQuoteFrom,
    required this.bioQuoteFromAttrib,
    required this.bioText,
    required this.botName,
    required this.thumbnail,
  });

  factory Legend.fromJson(Map<String, dynamic> json) {
    return Legend(
      legendId: json['legend_id'],
      legendNameKey: json['legend_name_key'],
      bioName: json['bio_name'],
      bioAka: json['bio_aka'],
      weaponOne: json['weapon_one'],
      weaponTwo: json['weapon_two'],
      strength: int.parse(json['strength']),
      dexterity: int.parse(json['dexterity']),
      defense: int.parse(json['defense']),
      speed: int.parse(json['speed']),
      bioQuote: json['bio_quote'],
      bioQuoteAboutAttrib: json['bio_quote_about_attrib'],
      bioQuoteFrom: json['bio_quote_from'],
      bioQuoteFromAttrib: json['bio_quote_from_attrib'],
      bioText: json['bio_text'],
      botName: json['bot_name'],
      thumbnail: json['thumbnail'],
    );
  }
}
