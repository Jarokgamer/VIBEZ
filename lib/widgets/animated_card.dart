import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Una tarjeta personalizada con animaciones sutiles para mejorar la experiencia de usuario.
class AnimatedCard extends StatefulWidget {
  /// Función que se ejecuta cuando se toca la tarjeta
  final VoidCallback? onTap;
  
  /// Contenido de la tarjeta
  final Widget child;
  
  /// Color de fondo de la tarjeta
  final Color? backgroundColor;
  
  /// Radio de borde de la tarjeta
  final double borderRadius;
  
  /// Elevación de la tarjeta
  final double elevation;
  
  /// Padding interior de la tarjeta
  final EdgeInsetsGeometry? padding;
  
  /// Si es verdadero, la tarjeta tendrá un efecto de brillo al ser tocada
  final bool hasShimmerEffect;

  const AnimatedCard({
    super.key,
    this.onTap,
    required this.child,
    this.backgroundColor,
    this.borderRadius = 16.0,
    this.elevation = 4.0,
    this.padding,
    this.hasShimmerEffect = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cardWidget = Card(
      color: widget.backgroundColor,
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16.0),
        child: widget.child,
      ),
    );

    // Animar solo si hay una acción al tocar
    if (widget.onTap == null) {
      return cardWidget;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = true;
        });
        
        widget.onTap?.call();
        
        // Restaurar el estado después de un breve retraso
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _isPressed = false;
            });
          }
        });
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _isPressed ? 0.9 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: widget.hasShimmerEffect
                ? cardWidget
                    .animate(target: _isPressed ? 1 : 0)
                    .shimmer(duration: 400.ms, color: Colors.white24)
                    .animate(target: _isHovered ? 1 : 0)
                    .elevation(
                      begin: widget.elevation,
                      end: widget.elevation + 2,
                      duration: 200.ms,
                      curve: Curves.easeInOut,
                    )
                : cardWidget,
          ),
        ),
      ),
    );
  }
} 