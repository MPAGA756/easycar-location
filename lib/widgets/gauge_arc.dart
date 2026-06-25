import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Élément signature de l'identité visuelle EasyCar.
/// Un arc façon "compteur de vitesse" (tableau de bord auto traditionnel),
/// dessiné avec CustomPainter (donc 100% local, pas d'assets).
/// Utilisé en fond décoratif sur le Splash et en en-tête du Dashboard.
class GaugeArc extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final double sweepFraction; // 0.0 à 1.0, portion de l'arc dessinée

  const GaugeArc({
    super.key,
    this.size = 220,
    this.color = AppColors.primary,
    this.strokeWidth = 10,
    this.sweepFraction = 0.72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(
          color: color,
          strokeWidth: strokeWidth,
          sweepFraction: sweepFraction,
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double sweepFraction;

  _GaugePainter({
    required this.color,
    required this.strokeWidth,
    required this.sweepFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const startAngle = math.pi * 0.75; // démarre en bas-gauche
    final sweep = math.pi * 1.5 * sweepFraction;

    // Piste de fond (gris, façon cadran)
    final trackPaint = Paint()
      ..color = AppColors.secondaryLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, math.pi * 1.5, false, trackPaint);

    // Arc coloré (jauge active)
    final arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweep,
        colors: [color.withOpacity(0.4), color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweep, false, arcPaint);

    // Petites graduations façon tableau de bord traditionnel
    final tickPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2;
    const tickCount = 8;
    for (int i = 0; i <= tickCount; i++) {
      final angle = startAngle + (math.pi * 1.5) * (i / tickCount);
      final outer = Offset(
        center.dx + (radius + strokeWidth * 0.7) * math.cos(angle),
        center.dy + (radius + strokeWidth * 0.7) * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (radius + strokeWidth * 0.25) * math.cos(angle),
        center.dy + (radius + strokeWidth * 0.25) * math.sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.sweepFraction != sweepFraction;
  }
}
