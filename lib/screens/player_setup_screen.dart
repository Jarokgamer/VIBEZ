import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/player.dart';
import 'package:party_game_app/providers/player_provider.dart';
import 'package:party_game_app/screens/game_screen.dart';
import 'package:party_game_app/screens/would_you_rather_screen.dart';
import 'package:party_game_app/theme/app_theme.dart';
import 'dart:math';

class PlayerSetupScreen extends StatefulWidget {
  final Game game;

  const PlayerSetupScreen({super.key, required this.game});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final List<Color> _avatarColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    // Load saved players when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlayerProvider>(context, listen: false).loadPlayers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final players = playerProvider.players;

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
          child: Column(
            children: [
              // Game info card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
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
                          Icon(
                            widget.game.icon,
                            color: widget.game.primaryColor,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.game.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                Text(
                                  widget.game.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Jugadores (${players.length}/${widget.game.maxPlayers})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, duration: 500.ms),
              
              // Player list
              Expanded(
                child: players.isEmpty
                    ? Center(
                        child: Text(
                          'Añade jugadores para comenzar',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _avatarColors[index % _avatarColors.length],
                                  child: Text(
                                    player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  player.name,
                                  style: const TextStyle(color: AppTheme.textPrimaryColor),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => playerProvider.removePlayer(player.id),
                                ),
                              ),
                            ),
                          ).animate(delay: (50 * index).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, duration: 300.ms);
                        },
                      ),
              ),
              
              // Add player form
              if (players.length < widget.game.maxPlayers)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Nombre del jugador',
                            filled: true,
                            fillColor: AppTheme.surfaceColor.withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          style: const TextStyle(color: AppTheme.textPrimaryColor),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addPlayer(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _addPlayer();
                          _nameFocusNode.requestFocus();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.game.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
              
              // Start game button
              if (players.length >= widget.game.minPlayers)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.game.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'COMENZAR JUEGO',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideY(begin: 0.2, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  void _addPlayer() {
    if (_nameController.text.trim().isNotEmpty) {
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      final newPlayer = Player(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
      );
      
      playerProvider.addPlayer(newPlayer);
      _nameController.clear();
      // Request focus again to keep keyboard open after adding a player
      _nameFocusNode.requestFocus();
    }
  }

  void _startGame() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final players = playerProvider.players;
    
    if (players.length >= widget.game.minPlayers) {
      // Set a random player as the current player
      final randomIndex = Random().nextInt(players.length);
      playerProvider.setCurrentPlayer(players[randomIndex].id);
      
      // Navigate to the correct game screen based on game type
      Widget gameScreen;
      
      switch (widget.game.type) {
        case GameType.wouldYouRather:
          // Import the WouldYouRatherScreen at the top of the file
          gameScreen = WouldYouRatherScreen(game: widget.game);
          break;
        case GameType.neverHaveIEver:
          gameScreen = GameScreen(game: widget.game); // GameScreen handles this internally
          break;
        case GameType.spinTheBottle:
          gameScreen = GameScreen(game: widget.game); // GameScreen handles this internally
          break;
        case GameType.truthOrDare:
          gameScreen = GameScreen(game: widget.game); // GameScreen handles this internally
          break;
        case GameType.cardGame:
          gameScreen = GameScreen(game: widget.game); // GameScreen handles this internally
          break;
        case GameType.challenges:
          gameScreen = GameScreen(game: widget.game); // GameScreen handles this internally
          break;
        default:
          gameScreen = GameScreen(game: widget.game);
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gameScreen,
        ),
      );
    }
  }
}