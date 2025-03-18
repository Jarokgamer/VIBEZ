import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/game_difficulty.dart';
import 'package:party_game_app/screens/game_screen.dart';
import 'package:party_game_app/theme/app_theme.dart';

class DifficultySelectionScreen extends StatelessWidget {
  final Game game;

  const DifficultySelectionScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: game.primaryColor.withOpacity(0.8),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              game.primaryColor.withOpacity(0.7),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Selecciona la Dificultad',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: DifficultyOption.options.length,
                    itemBuilder: (context, index) {
                      final option = DifficultyOption.options[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    game: game,
                                    difficulty: option,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    option.color.withOpacity(0.8),
                                    option.color,
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    option.emoji,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _getDifficultyDescription(option.difficulty),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate(delay: (100 * index).ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: 0.2, duration: 400.ms);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDifficultyDescription(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.normal:
        return 'Preguntas y retos divertidos para todos';
      case GameDifficulty.spicy:
        return 'Un poco más picante y atrevido';
      case GameDifficulty.hot:
        return 'Solo para los más valientes 🔞';
    }
  }
}