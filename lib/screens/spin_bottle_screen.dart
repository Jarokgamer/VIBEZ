import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/player.dart';
import 'package:party_game_app/providers/player_provider.dart';
import 'package:party_game_app/theme/app_theme.dart';

class SpinBottleScreen extends StatefulWidget {
  final Game game;

  const SpinBottleScreen({super.key, required this.game});

  @override
  State<SpinBottleScreen> createState() => _SpinBottleScreenState();
}

class _SpinBottleScreenState extends State<SpinBottleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Player? selectedPlayer;
  Player? currentPlayer;
  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isSpinning = false;
        });
        // Player selection is handled in the _spinWheel method
      }
    });

    // Set initial current player
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      if (playerProvider.players.isNotEmpty) {
        setState(() {
          currentPlayer = playerProvider.players.first;
        });
      }
    });
  }

  double _currentRotation = 0.0;

  void _spinWheel() {
    if (!isSpinning) {
      setState(() {
        isSpinning = true;
        selectedPlayer = null;
      });

      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      final players = playerProvider.players;
      if (players.isEmpty) return;

      final random = Random();
      // Generate a random number of full rotations (between 4 and 6)
      final fullRotations = 4 + random.nextDouble() * 2;
      // Generate a random spin speed factor (between 0.8 and 1.2)
      final speedFactor = 0.8 + random.nextDouble() * 0.4;
      
      // Calculate the total rotation including the random extra rotation
      final totalRotation = fullRotations * 2 * pi + _currentRotation;

      // Adjust the controller duration based on the speed factor
      _controller.duration = Duration(milliseconds: (3000 * speedFactor).round());

      _animation = Tween<double>(
        begin: _currentRotation,
        end: totalRotation,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));

      _controller.reset();
      _controller.forward().then((_) {
        // Calculate which player segment is at the top (where the arrow points)
        final segmentAngle = 2 * pi / players.length;
        // Normalize the final angle to be between 0 and 2π
        final normalizedAngle = (totalRotation % (2 * pi) + 2 * pi) % (2 * pi);
        // Calculate which segment is at the top (where the arrow points)
        // Add pi/2 to account for the initial rotation of segments (first segment starts at -pi/2)
        final adjustedAngle = (normalizedAngle + pi/2) % (2 * pi);
        final selectedIndex = ((2 * pi - adjustedAngle) / segmentAngle).floor() % players.length;
        
        setState(() {
          isSpinning = false;
          selectedPlayer = players[selectedIndex];
          // Move to next player's turn
          final currentIndex = players.indexOf(currentPlayer!);
          currentPlayer = players[(currentIndex + 1) % players.length];
          _currentRotation = totalRotation;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                // Current player's turn
                if (currentPlayer != null)
                  Card(
                    color: AppTheme.surfaceColor.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Turno de:',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentPlayer!.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // Game instructions
                Card(
                  color: AppTheme.surfaceColor.withOpacity(0.8),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '¡Gira la rueda!',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Toca la rueda para girarla y ver con quién te toca besar.',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Spinning wheel
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: _spinWheel,
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _animation.value,
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.surfaceColor,
                                    border: Border.all(
                                      color: widget.game.primaryColor,
                                      width: 4,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: WheelPainter(
                                      players: players,
                                      primaryColor: widget.game.primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Fixed arrow indicator at the top
                        Positioned(
                          top: -10,
                          child: Transform.rotate(
                            angle: -pi/2,  // Rotate arrow to point right
                            child: Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: widget.game.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Selected player display
                if (selectedPlayer != null && !isSpinning)
                  Card(
                    color: AppTheme.surfaceColor.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            '¡La rueda se detuvo en:',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedPlayer!.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(),
              ],
            ),
          ),
          ),
          // Add stationary arrow at the top
          // Position the arrow at the top of the wheel
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 - 170, // Positioned just above the wheel
            left: MediaQuery.of(context).size.width * 0.5 - 20,
            child: Icon(
              Icons.arrow_downward,
              size: 40,
              color: widget.game.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Color color;
  
  ArrowPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    // Draw a triangle pointing downward
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
      
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WheelPainter extends CustomPainter {
  final List<Player> players;
  final Color primaryColor;

  WheelPainter({required this.players, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (players.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / players.length;
    
    // Draw segments and names
    for (var i = 0; i < players.length; i++) {
      final startAngle = i * segmentAngle;
      final paint = Paint()
        ..color = i.isEven ? primaryColor.withOpacity(0.2) : primaryColor.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Draw dividing lines
      final linePaint = Paint()
        ..color = primaryColor.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * cos(startAngle),
          center.dy + radius * sin(startAngle),
        ),
        linePaint,
      );

      // Draw player names
      final textPainter = TextPainter(
        text: TextSpan(
          text: players[i].name,
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Position text in the middle of the segment
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.6; // Adjusted for better positioning
      final x = center.dx + textRadius * cos(textAngle);
      final y = center.dy + textRadius * sin(textAngle);

      canvas.save();
      canvas.translate(x, y);
      // Adjust text rotation to be readable from the outside of the wheel
      canvas.rotate(textAngle + pi / 2);
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Add a small circle at the center for better visual reference
    final centerDotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 10, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}