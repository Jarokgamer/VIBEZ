import 'dart:math';
import 'package:flutter/material.dart';
import 'package:party_game_app/models/player.dart';

class WheelPainter extends CustomPainter {
  final List<Player> players;
  final List<Color> colors;

  WheelPainter({required this.players, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / players.length;

    // Draw wheel segments and player names
    for (var i = 0; i < players.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          i * segmentAngle,
          segmentAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);

      // Draw player names
      final textPainter = TextPainter(
        text: TextSpan(
          text: players[i].name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Calculate text position to center in segment
      final textAngle = i * segmentAngle + segmentAngle / 2;
      final textRadius = radius * 0.65; // Position text at 65% of radius for better centering
      final textX = center.dx + textRadius * cos(textAngle) - textPainter.width / 2;
      final textY = center.dy + textRadius * sin(textAngle) - textPainter.height / 2;

      canvas.save();
      canvas.translate(textX, textY);
      // Keep text upright by not rotating it with the segment
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Draw indicator line on top
    final indicatorPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, 0),
      center,
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) =>
      players != oldDelegate.players || colors != oldDelegate.colors;
}