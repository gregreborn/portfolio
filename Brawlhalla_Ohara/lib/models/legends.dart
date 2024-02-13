class Legend {
  final int legendId;
  final String name;
  final int strength;
  final int dexterity;
  final int defense;
  final int speed;

  Legend({required this.legendId,required this.name,required this.strength,required this.dexterity,required this.defense,required this.speed});

  factory Legend.fromJson(Map<String, dynamic> json) {
    return Legend(
      legendId: json['legend_id'],
      name: json['name'],
      strength: json['strength'],
      dexterity: json['dexterity'],
      defense: json['defense'],
      speed: json['speed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'legend_id': legendId,
    'name': name,
    'strength': strength,
    'dexterity': dexterity,
    'defense': defense,
    'speed': speed,
  };
}
