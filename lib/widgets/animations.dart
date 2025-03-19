// Este archivo exporta todos los widgets relacionados con animaciones
// para facilitar su importación en otros archivos.

export 'animated_button.dart';
export 'animated_card.dart';
export 'pulsating_widget.dart';

// Función de utilidad para animar entradas de elementos en una lista
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Crea un widget animado con efectos de entrada en cascada para listas.
/// Útil para crear efectos de entrada escalonados para elementos en ListView.
Widget animateListItem({
  required Widget child,
  required int index,
  Duration? delay,
  Duration fadeInDuration = const Duration(milliseconds: 300),
  Duration slideDuration = const Duration(milliseconds: 300),
  Offset slideBegin = const Offset(0.1, 0),
  Curve curve = Curves.easeOut,
}) {
  final actualDelay = delay ?? Duration(milliseconds: 50 * index);
  
  return child
    .animate(delay: actualDelay)
    .fadeIn(duration: fadeInDuration)
    .slideX(begin: slideBegin.dx, end: 0, duration: slideDuration, curve: curve);
}

/// Aplica un efecto de pulsación al hacer tap en un widget
class TapPulseEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;
  
  const TapPulseEffect({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 150),
  });
  
  @override
  State<TapPulseEffect> createState() => _TapPulseEffectState();
}

class _TapPulseEffectState extends State<TapPulseEffect> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleDown : 1.0,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
} 