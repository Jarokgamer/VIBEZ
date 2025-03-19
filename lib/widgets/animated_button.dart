import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Un botón personalizado con animaciones sutiles para mejorar la experiencia de usuario.
class AnimatedButton extends StatefulWidget {
  /// Función que se ejecuta cuando se presiona el botón
  final VoidCallback onPressed;
  
  /// Texto o widget a mostrar dentro del botón
  final Widget child;
  
  /// Color de fondo del botón
  final Color backgroundColor;
  
  /// Color del texto o contenido del botón
  final Color? foregroundColor;
  
  /// Forma del botón
  final OutlinedBorder? shape;
  
  /// Padding interior del botón
  final EdgeInsetsGeometry? padding;
  
  /// Tamaño del botón
  final Size? minimumSize;
  
  /// Si es verdadero, el botón ocupará todo el ancho disponible
  final bool isFullWidth;
  
  /// Si está deshabilitado, el botón no responderá a las interacciones
  final bool isDisabled;
  
  /// Ícono opcional para mostrar a la izquierda del texto
  final IconData? icon;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.padding,
    this.minimumSize,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.icon,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonWidget = ElevatedButton(
      onPressed: widget.isDisabled ? null : () {
        setState(() {
          _isPressed = true;
        });
        
        widget.onPressed();
        
        // Restaurar el estado después de un breve retraso
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              _isPressed = false;
            });
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        shape: widget.shape,
        padding: widget.padding,
        minimumSize: widget.minimumSize,
        disabledBackgroundColor: widget.backgroundColor.withOpacity(0.5),
        disabledForegroundColor: widget.foregroundColor?.withOpacity(0.5) ?? Colors.white.withOpacity(0.5),
      ),
      child: widget.icon != null 
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon),
                const SizedBox(width: 8),
                widget.child,
              ],
            )
          : widget.child,
    );

    // Aplicar animaciones basadas en el estado
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: widget.isFullWidth
          ? SizedBox(
              width: double.infinity,
              child: buttonWidget,
            )
              .animate(target: _isPressed ? 1 : 0)
              .shimmer(duration: 400.ms, color: widget.foregroundColor?.withOpacity(0.3) ?? Colors.white30)
          : buttonWidget
              .animate(target: _isPressed ? 1 : 0)
              .shimmer(duration: 400.ms, color: widget.foregroundColor?.withOpacity(0.3) ?? Colors.white30),
    );
  }
} 