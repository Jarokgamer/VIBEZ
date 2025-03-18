import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/providers/game_provider.dart';
import 'package:party_game_app/screens/player_setup_screen.dart';
import 'package:party_game_app/theme/app_theme.dart';
import 'package:party_game_app/widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDrinkingMode = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final games = gameProvider.games;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryColor.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'VIBEZ',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn(duration: 600.ms).slideY(
                          begin: -0.2,
                          duration: 600.ms,
                          curve: Curves.easeOutQuad,
                        ),
                    const Spacer(),
                    const Text(
                      '🍺',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDrinkingMode = !isDrinkingMode;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 30,
                        width: 51,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isDrinkingMode ? Colors.green : Colors.grey.shade300,
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              left: isDrinkingMode ? 22 : 2,
                              top: 2,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Elige un juego para comenzar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    // Hide 'La Puta' game when drinking mode is off
                    if (!isDrinkingMode && game.name == 'La Puta') {
                      return const SizedBox.shrink();
                    }
                    
                    // Add more bottom padding to the last item to avoid overflow
                    final isLastItem = index == games.length - 1;
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLastItem ? 24 : 16),
                      child: GameCard(
                        game: game,
                        onTap: () => _navigateToPlayerSetup(context, game),
                      ).animate(delay: (100 * index).ms).fadeIn(
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ).slideY(
                            begin: 0.2,
                            duration: 500.ms,
                            curve: Curves.easeOutQuad,
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPlayerSetup(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerSetupScreen(game: game),
      ),
    );
  }
}