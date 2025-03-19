import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Un widget que aplica una animación de pulsación a su hijo.
class PulsatingWidget extends StatelessWidget {
  /// Widget al que se le aplicará la animación de pulsación
  final Widget child;
  
  /// Duración de un ciclo completo de la animación
  final Duration duration;
  
  /// Curva de animación
  final Curve curve;
  
  /// Escala mínima (más pequeño)
  final double minScale;
  
  /// Escala máxima (más grande)
  final double maxScale;
  
  /// Si es true, la animación se ejecutará automáticamente
  final bool autoPlay;
  
  /// Si es true, la animación se repetirá indefinidamente
  final bool repeat;
  
  /// Retraso antes de comenzar la animación
  final Duration delay;

  const PulsatingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOut,
    this.minScale = 0.97,
    this.maxScale = 1.03,
    this.autoPlay = true,
    this.repeat = true,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return autoPlay
        ? child
            .animate(
              onPlay: (controller) => repeat ? controller.repeat() : controller.forward(),
            )
            .scale(
              begin: Offset(1, 1),
              end: Offset(maxScale, maxScale),
              duration: duration ~/ 2,
              curve: curve,
              delay: delay,
            )
            .then()
            .scale(
              begin: Offset(maxScale, maxScale),
              end: Offset(minScale, minScale),
              duration: duration ~/ 2,
              curve: curve,
            )
            .then()
            .scale(
              begin: Offset(minScale, minScale),
              end: Offset(1, 1),
              duration: duration ~/ 2,
              curve: curve,
            )
        : child;
  }
} 