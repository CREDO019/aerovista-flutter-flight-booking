import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EliteHomeBackground extends StatefulWidget {
  const EliteHomeBackground({super.key});

  @override
  State<EliteHomeBackground> createState() => _EliteHomeBackgroundState();
}

class _EliteHomeBackgroundState extends State<EliteHomeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => CustomPaint(
        painter: _EliteHomeBackgroundPainter(_controller.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _EliteHomeBackgroundPainter extends CustomPainter {
  const _EliteHomeBackgroundPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    _drawBaseAtmosphere(canvas, rect, size);
    _drawRouteMapLines(canvas, size);
    _drawRunwayPerspective(canvas, size);
    _drawGlassReflections(canvas, size);
    _drawParticles(canvas, size);
  }

  void _drawBaseAtmosphere(Canvas canvas, Rect rect, Size size) {
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF13243A),
            AppColors.deepNavy,
            AppColors.backgroundBlack,
          ],
          stops: [0, 0.42, 1],
        ).createShader(rect),
    );

    _drawRadialGlow(
      canvas,
      center: Offset(size.width * 0.12, size.height * 0.78),
      radius: size.width * 0.78,
      color: AppColors.airlineRed,
      alpha: 0.18 + math.sin(t * math.pi * 2) * 0.025,
    );
    _drawRadialGlow(
      canvas,
      center: Offset(size.width * 0.68, size.height * 0.16),
      radius: size.width * 0.70,
      color: const Color(0xFF2A6FBA),
      alpha: 0.14,
    );
    _drawRadialGlow(
      canvas,
      center: Offset(size.width * 1.05, size.height * 0.88),
      radius: size.width * 0.58,
      color: AppColors.deepRed,
      alpha: 0.11,
    );
  }

  void _drawRadialGlow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
    required double alpha,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _drawRouteMapLines(Canvas canvas, Size size) {
    final phase = math.sin(t * math.pi * 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.045);

    for (var i = 0; i < 4; i++) {
      final y = size.height * (0.18 + i * 0.09) + phase * (2 + i);
      final path = Path()
        ..moveTo(size.width * -0.08, y)
        ..cubicTo(
          size.width * 0.24,
          y - 54 - i * 10,
          size.width * 0.64,
          y + 46 + i * 7,
          size.width * 1.08,
          y - 18,
        );
      canvas.drawPath(path, paint);
    }

    final redPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = AppColors.airlineRed.withValues(alpha: 0.045);

    final arc = Path()
      ..moveTo(size.width * 0.02, size.height * 0.43 + phase * 4)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.25,
        size.width * 0.58,
        size.height * 0.50,
        size.width * 0.98,
        size.height * 0.34,
      );
    canvas.drawPath(arc, redPaint);
  }

  void _drawRunwayPerspective(Canvas canvas, Size size) {
    final horizon = Offset(size.width * 0.52, size.height * 0.58);
    final bottomY = size.height * 1.03;
    final pulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);

    final centerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = Colors.white.withValues(alpha: 0.08);
    canvas.drawLine(horizon, Offset(size.width * 0.50, bottomY), centerPaint);

    for (var i = 0; i < 13; i++) {
      final p = i / 12;
      final depth = math.pow(p, 1.65).toDouble();
      final y = _mix(horizon.dy, bottomY, depth);
      final spread = _mix(18, size.width * 0.44, depth);
      final radius = _mix(1.1, 4.3, depth);
      final alpha = _mix(0.12, 0.48, depth) * (0.82 + pulse * 0.18);
      final isRed = i.isEven;

      final paint = Paint()
        ..color = (isRed ? AppColors.airlineRed : Colors.white).withValues(
          alpha: alpha,
        );

      canvas.drawCircle(Offset(horizon.dx - spread, y), radius, paint);
      canvas.drawCircle(Offset(horizon.dx + spread, y), radius, paint);

      if (i % 2 == 1) {
        canvas.drawCircle(
          Offset(horizon.dx, y),
          radius * 0.55,
          Paint()..color = Colors.white.withValues(alpha: alpha * 0.45),
        );
      }
    }
  }

  void _drawGlassReflections(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16
      ..color = Colors.white.withValues(alpha: 0.025);

    final drift = math.sin(t * math.pi * 2) * 12;
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.18 + i * 0.32) + drift;
      canvas.drawLine(
        Offset(x, size.height * -0.10),
        Offset(x + size.width * 0.24, size.height * 0.45),
        paint,
      );
    }

    final thinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.055);
    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.18),
      Offset(size.width * 0.82, size.height * 0.07),
      thinPaint,
    );
  }

  void _drawParticles(Canvas canvas, Size size) {
    for (var i = 0; i < 14; i++) {
      final baseX = ((i * 37 + 11) % 100) / 100;
      final baseY = ((i * 61 + 19) % 100) / 100;
      final driftX = math.sin(t * math.pi * 2 + i) * 5;
      final driftY = math.cos(t * math.pi * 2 + i * 0.7) * 3;
      final alpha = 0.05 + ((i % 4) * 0.012);
      canvas.drawCircle(
        Offset(size.width * baseX + driftX, size.height * baseY + driftY),
        i % 3 == 0 ? 1.3 : 0.85,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }
  }

  double _mix(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(_EliteHomeBackgroundPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
