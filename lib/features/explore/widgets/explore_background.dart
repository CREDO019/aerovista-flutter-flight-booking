import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Animated ambient background for the destination discovery screen.
class ExploreBackground extends StatefulWidget {
  const ExploreBackground({super.key});

  @override
  State<ExploreBackground> createState() => _ExploreBackgroundState();
}

class _ExploreBackgroundState extends State<ExploreBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => CustomPaint(
          painter: _ExploreBackgroundPainter(_ctrl.value),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ExploreBackgroundPainter extends CustomPainter {
  const _ExploreBackgroundPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF101B30),
            AppColors.deepNavy,
            AppColors.backgroundBlack,
          ],
          stops: [0.0, 0.42, 1.0],
        ).createShader(rect),
    );

    _drawGlow(
      canvas,
      center: Offset(
        size.width * (0.18 + math.sin(t * math.pi * 2) * 0.025),
        size.height * 0.10,
      ),
      radius: size.width * 0.62,
      colors: [
        AppColors.airlineRed.withValues(alpha: 0.18),
        AppColors.airlineRed.withValues(alpha: 0.0),
      ],
    );

    _drawGlow(
      canvas,
      center: Offset(
        size.width * 0.82,
        size.height * (0.86 + math.cos(t * math.pi * 2) * 0.018),
      ),
      radius: size.width * 0.66,
      colors: [
        const Color(0xFF17345A).withValues(alpha: 0.34),
        const Color(0xFF17345A).withValues(alpha: 0.0),
      ],
    );

    _drawRouteLines(canvas, size);
    _drawParticles(canvas, size);
  }

  void _drawGlow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required List<Color> colors,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: colors,
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _drawRouteLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.softRed.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final y = size.height * (0.20 + i * 0.16);
      final drift = math.sin(t * math.pi * 2 + i) * size.height * 0.012;
      final path = Path()
        ..moveTo(-size.width * 0.05, y + drift)
        ..cubicTo(
          size.width * 0.22,
          y - size.height * (0.10 + i * 0.006),
          size.width * 0.68,
          y + size.height * (0.08 - i * 0.004),
          size.width * 1.05,
          y - drift * 0.6,
        );

      canvas.drawPath(path, linePaint);
      if (i.isEven) {
        canvas.drawCircle(
          Offset(size.width * (0.18 + i * 0.13), y - drift * 0.35),
          2.0,
          dotPaint,
        );
      }
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()..style = PaintingStyle.fill;
    const anchors = [
      Offset(0.10, 0.25),
      Offset(0.26, 0.14),
      Offset(0.72, 0.20),
      Offset(0.88, 0.36),
      Offset(0.17, 0.70),
      Offset(0.68, 0.78),
      Offset(0.42, 0.90),
      Offset(0.92, 0.88),
    ];

    for (int i = 0; i < anchors.length; i++) {
      final phase = t * math.pi * 2 + i * 0.72;
      final anchor = anchors[i];
      final offset = Offset(
        size.width * anchor.dx + math.sin(phase) * 4,
        size.height * anchor.dy + math.cos(phase * 0.8) * 5,
      );
      particlePaint.color = Colors.white.withValues(
        alpha: 0.035 + (i.isEven ? 0.025 : 0.0),
      );
      canvas.drawCircle(offset, i.isEven ? 1.7 : 1.2, particlePaint);
    }
  }

  @override
  bool shouldRepaint(_ExploreBackgroundPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
