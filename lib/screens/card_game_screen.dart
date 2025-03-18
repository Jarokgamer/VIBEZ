import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/player.dart';
import 'package:party_game_app/models/card_game.dart';
import 'package:party_game_app/providers/player_provider.dart';
import 'package:party_game_app/theme/app_theme.dart';

class CardGameScreen extends StatefulWidget {
  final Game game;

  const CardGameScreen({super.key, required this.game});

  @override
  State<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen> with SingleTickerProviderStateMixin {
  late Player currentPlayer;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isCardRevealed = false;
  CardGame? currentCard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _loadGameData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadGameData() async {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    currentPlayer = playerProvider.currentPlayer!;
  }

  void _drawCard() {
    if (!isCardRevealed) {
      setState(() {
        currentCard = CardGameRules.rules[DateTime.now().millisecond % CardGameRules.rules.length];
        isCardRevealed = true;
      });
      _controller.forward();
    }
  }

  void _nextTurn() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final players = playerProvider.players;
    final currentIndex = players.indexWhere((p) => p.id == currentPlayer.id);
    final nextIndex = (currentIndex + 1) % players.length;
    final nextPlayer = players[nextIndex];
    
    playerProvider.setCurrentPlayer(nextPlayer.id);
    setState(() {
      currentPlayer = nextPlayer;
      isCardRevealed = false;
      currentCard = null;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: widget.game.primaryColor.withOpacity(0.8),
      ),
      body: Container(
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
            child: Column(
              children: [
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
                  child: Row(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, duration: 500.ms),

                const Spacer(),

                GestureDetector(
                  onTap: _drawCard,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_animation.value * 3.14),
                        child: Container(
                          width: 280,
                          height: 400,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: _animation.value < 0.5 
                                      ? AppTheme.surfaceColor 
                                      : widget.game.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                              ),
                              if (_animation.value >= 0.5 && currentCard != null)
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(3.14),
                                  child: Container(
                                    padding: const EdgeInsets.all(24.0),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currentCard!.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        if (currentCard!.description != null) ...[                                          
                                          const SizedBox(height: 16),
                                          Text(
                                            currentCard!.description!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                if (isCardRevealed)
                  ElevatedButton.icon(
                    onPressed: _nextTurn,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('SIGUIENTE TURNO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surfaceColor,
                      foregroundColor: AppTheme.textPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}