import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/player.dart';
import 'package:party_game_app/models/game_difficulty.dart';
import 'package:party_game_app/providers/player_provider.dart';
import 'package:party_game_app/theme/app_theme.dart';
import 'package:party_game_app/screens/spin_bottle_screen.dart';
import 'package:party_game_app/screens/card_game_screen.dart';
import 'package:party_game_app/screens/never_have_i_ever_screen.dart';
import 'package:party_game_app/screens/difficulty_selection_screen.dart';

class GameScreen extends StatefulWidget {
  final Game game;
  final DifficultyOption? difficulty;

  const GameScreen({super.key, required this.game, this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Player currentPlayer;
  String? currentPrompt;
  bool isLoading = false;
  bool hasSelectedChoice = false;
  String? selectedChoice;
  DifficultyOption? selectedDifficulty;

  @override
  void initState() {
    super.initState();
    selectedDifficulty = widget.difficulty;
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    setState(() {
      isLoading = true;
    });

    // Get current player from provider
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    currentPlayer = playerProvider.currentPlayer!;

    setState(() {
      isLoading = false;
      hasSelectedChoice = false;
      selectedChoice = null;
      currentPrompt = null;
    });
  }

  void _generatePrompt(String choice) {
    setState(() {
      if (selectedDifficulty != null) {
        final prompts = choice == 'Verdad'
            ? selectedDifficulty!.truthPrompts
            : selectedDifficulty!.darePrompts;
        currentPrompt = prompts[DateTime.now().millisecond % prompts.length];
      } else {
        if (choice == 'Verdad') {
          final prompts = [
            '¿Cuál es tu mayor secreto?',
            '¿Alguna vez has mentido a tu mejor amigo?',
            '¿Cuál es tu mayor miedo?',
            '¿Cuál ha sido tu momento más vergonzoso?',
            '¿Qué es lo más loco que has hecho por amor?',
          ];
          currentPrompt = prompts[DateTime.now().millisecond % prompts.length];
        } else {
          final prompts = [
            'Haz 10 flexiones ahora mismo',
            'Llama a la quinta persona de tu lista de contactos y canta una canción',
            'Imita a la persona a tu derecha durante 2 minutos',
            'Baila tu canción favorita sin música',
            'Haz 20 sentadillas ahora mismo',
          ];
          currentPrompt = prompts[DateTime.now().millisecond % prompts.length];
        }
      }
      hasSelectedChoice = true;
      selectedChoice = choice;
    });
  }

  void _nextTurn() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final players = playerProvider.players;
    
    // Find current player index
    final currentIndex = players.indexWhere((p) => p.id == currentPlayer.id);
    
    // Get next player (circular)
    final nextIndex = (currentIndex + 1) % players.length;
    final nextPlayer = players[nextIndex];
    
    // Update current player
    playerProvider.setCurrentPlayer(nextPlayer.id);
    setState(() {
      currentPlayer = nextPlayer;
      hasSelectedChoice = false;
      selectedChoice = null;
      currentPrompt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.game.type == GameType.spinTheBottle) {
      return SpinBottleScreen(game: widget.game);
    } else if (widget.game.type == GameType.cardGame) {
      return CardGameScreen(game: widget.game);
    } else if (widget.game.type == GameType.neverHaveIEver) {
      return NeverHaveIEverScreen(game: widget.game);
    } else if (widget.game.type == GameType.truthOrDare && widget.difficulty == null) {
      return DifficultySelectionScreen(game: widget.game);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: widget.game.primaryColor.withOpacity(0.8),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.game.primaryColor.withOpacity(0.7),
                    AppTheme.backgroundColor,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Current player card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: widget.game.primaryColor,
                                    radius: 24,
                                    child: Text(
                                      currentPlayer.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Turno de',
                                          style: TextStyle(
                                            color: AppTheme.textSecondaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          currentPlayer.name,
                                          style: const TextStyle(
                                            color: AppTheme.textPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Puntos: ${currentPlayer.score}',
                                          style: TextStyle(
                                            color: currentPlayer.score >= 5 ? Colors.red : AppTheme.textSecondaryColor,
                                            fontSize: 14,
                                            fontWeight: currentPlayer.score >= 5 ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (selectedChoice != null) ...[  // Show choice indicator
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selectedChoice == 'Reto' 
                                        ? Colors.red.withOpacity(0.2) 
                                        : Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    selectedChoice!,
                                    style: TextStyle(
                                      color: selectedChoice == 'Reto' 
                                          ? Colors.red 
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, duration: 500.ms),
                        
                        SizedBox(height: 20),
                        
                        if (!hasSelectedChoice) ...[  // Truth or Dare selection buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _generatePrompt('Verdad'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'VERDAD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _generatePrompt('Reto'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'RETO',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                        ] else ...[  // Game prompt card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: selectedChoice == 'Reto' 
                                  ? Colors.red.withOpacity(0.9) 
                                  : Colors.blue.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (selectedChoice == 'Reto' ? Colors.red : Colors.blue).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  selectedChoice == 'Reto' ? Icons.local_fire_department : Icons.question_answer,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 48,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  currentPrompt ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 800.ms).scale(begin: const Offset(0.9, 0.9), duration: 800.ms),
                        ],
                        
                        SizedBox(height: 20),
                        
                        // Action buttons
                        if (hasSelectedChoice) ...[  // Only show these buttons after selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Complete button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _nextTurn();
                                  },
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('COMPLETADO'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.truthColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Skip button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
                                    playerProvider.updateScore(currentPlayer.id, 1);
                                    if (currentPlayer.score >= 5) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('¡FONDO BLANCO!'),
                                          content: Text('${currentPlayer.name} ha alcanzado 5 puntos. ¡Debe hacer FONDO BLANCO (terminar toda la botella o bebida)!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
                                                playerProvider.updateScore(currentPlayer.id, -currentPlayer.score); // Reset score to 0
                                                Navigator.of(context).pop();
                                                _nextTurn();
                                              },
                                              child: const Text('Aceptar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      _nextTurn();
                                    }
                                  },
                                  icon: const Icon(Icons.skip_next),
                                  label: const Text('SIGUIENTE'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.surfaceColor,
                                    foregroundColor: AppTheme.textPrimaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2, duration: 500.ms),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}