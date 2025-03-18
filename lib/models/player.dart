class Player {
  final String id;
  final String name;
  String? avatarPath;
  int score;
  bool isActive;

  Player({
    required this.id,
    required this.name,
    this.avatarPath,
    this.score = 0,
    this.isActive = true,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      avatarPath: json['avatarPath'],
      score: json['score'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarPath': avatarPath,
      'score': score,
      'isActive': isActive,
    };
  }

  Player copyWith({
    String? id,
    String? name,
    String? avatarPath,
    int? score,
    bool? isActive,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      score: score ?? this.score,
      isActive: isActive ?? this.isActive,
    );
  }
}