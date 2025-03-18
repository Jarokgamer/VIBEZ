import 'package:flutter/material.dart';

enum GameType {
  truthOrDare,
  spinTheBottle,
  challenges,
  wouldYouRather,
  cardGame,
  neverHaveIEver,
}

class Game {
  final String id;
  final String name;
  final String description;
  final Color primaryColor;
  final IconData icon;
  final GameType type;
  final int minPlayers;
  final int maxPlayers;
  final bool isLocked;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.icon,
    required this.type,
    this.minPlayers = 2,
    this.maxPlayers = 20,
    this.isLocked = false,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      primaryColor: Color(json['primaryColor']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      type: GameType.values.byName(json['type']),
      minPlayers: json['minPlayers'] ?? 2,
      maxPlayers: json['maxPlayers'] ?? 20,
      isLocked: json['isLocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'primaryColor': primaryColor.value,
      'icon': icon.codePoint,
      'type': type.name,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'isLocked': isLocked,
    };
  }
}