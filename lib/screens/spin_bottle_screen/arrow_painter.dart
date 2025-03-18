import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Color color;

  ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Start from the right point of the arrow
    path.moveTo(size.width, size.height / 2);
    // Draw the top part of the arrow
    path.lineTo(0, 0);
    // Draw the bottom part of the arrow
    path.lineTo(0, size.height);
    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}