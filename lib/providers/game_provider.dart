import 'package:flutter/material.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/theme/app_theme.dart';

class GameProvider extends ChangeNotifier {
  final List<Game> _games = [
    Game(
      id: 'truth_or_dare',
      name: 'Verdad o Reto',
      description: 'El clásico juego de verdad o reto para animar cualquier fiesta.',
      primaryColor: AppTheme.truthColor,
      icon: Icons.question_answer,
      type: GameType.truthOrDare,
    ),
    Game(
      id: 'spin_the_bottle',
      name: 'La Botella',
      description: 'El clásico juego de girar la botella. ¡Que el destino decida!',
      primaryColor: AppTheme.dareColor,
      icon: Icons.rotate_right,
      type: GameType.spinTheBottle,
    ),
    Game(
      id: 'would_you_rather',
      name: 'Qué Prefieres',
      description: 'Elige entre dos opciones difíciles y descubre las preferencias de tus amigos.',
      primaryColor: AppTheme.preferenceColor,
      icon: Icons.compare_arrows,
      type: GameType.wouldYouRather,
    ),
    Game(
      id: 'card_game',
      name: 'La Puta',
      description: 'Un juego de cartas con reglas divertidas para beber y socializar.',
      primaryColor: AppTheme.dareColor,
      icon: Icons.style,
      type: GameType.cardGame,
    ),
    Game(
      id: 'never_have_i_ever',
      name: 'Yo nunca nunca',
      description: 'Descubre los secretos más divertidos de tus amigos con este clásico juego de bebida.',
      primaryColor: AppTheme.preferenceColor,
      icon: Icons.local_bar,
      type: GameType.neverHaveIEver,
    ),
  ];

  List<Game> get games => _games;

  Game getGameById(String id) {
    return _games.firstWhere((game) => game.id == id);
  }

  List<Game> getGamesByType(GameType type) {
    return _games.where((game) => game.type == type).toList();
  }
}