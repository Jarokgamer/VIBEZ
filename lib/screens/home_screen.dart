import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/providers/game_provider.dart';
import 'package:party_game_app/screens/player_setup_screen.dart';
import 'package:party_game_app/theme/app_theme.dart';
import 'package:party_game_app/widgets/game_card.dart';
import 'package:party_game_app/widgets/animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isDrinkingMode = false;
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Iniciar la animación después de un corto retraso
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    PulsatingWidget(
                      minScale: 0.98,
                      maxScale: 1.02,
                      duration: const Duration(milliseconds: 2000),
                      delay: const Duration(milliseconds: 800),
                      child: Text(
                        'VIBEZ',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                      ).animate().fadeIn(duration: 600.ms).slideY(
                            begin: -0.2,
                            duration: 600.ms,
                            curve: Curves.easeOutQuad,
                          ),
                    ),
                    const Spacer(),
                    const Text(
                      '🍺',
                      style: TextStyle(fontSize: 24),
                    ).animate().fadeIn(delay: 300.ms).scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 600.ms,
                        ),
                    const SizedBox(width: 8),
                    TapPulseEffect(
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),
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
                        fontWeight: FontWeight.w500,
                      ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(
                      begin: -0.1,
                      end: 0,
                      delay: 200.ms,
                      duration: 500.ms,
                      curve: Curves.easeOutQuad,
                    ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ListView.builder(
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
                        
                        // Calcula el retraso basado en el índice para crear un efecto cascada
                        final delay = Duration(milliseconds: 100 + (index * 100));
                        
                        return animateListItem(
                          index: index,
                          delay: delay,
                          fadeInDuration: const Duration(milliseconds: 400),
                          slideDuration: const Duration(milliseconds: 500),
                          slideBegin: const Offset(0, 0.2),
                          curve: Curves.easeOutQuint,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: isLastItem ? 24 : 16),
                            child: GameCard(
                              game: game,
                              onTap: () => _navigateToPlayerSetup(context, game),
                            ),
                          ),
                        );
                      },
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