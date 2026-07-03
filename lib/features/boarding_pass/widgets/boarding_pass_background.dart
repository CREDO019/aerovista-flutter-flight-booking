import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen ambient background for the Boarding Pass screen.
///
/// Creates a richer, more dramatic atmosphere than the results screen:
/// - deep navy→black gradient
/// - warm red glow near card area (centre-right)
/// - secondary navy glow (bottom-left)
/// - faint abstract arc lines evoking a flight route map
/// - slow breathing animation via a 7-second looping [AnimationController]
class BoardingPassBackground extends StatefulWidget {
  const BoardingPassBackground({super.key});

  @override
  State<BoardingPassBackground> createState() => _BoardingPassBackgroundState();
}

class _BoardingPassBackgroundState extends State<BoardingPassBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => CustomPaint(
        painter: _BPBgPainter(_ctrl.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BPBgPainter extends CustomPainter {
  const _BPBgPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ── Base gradient ─────────────────────────────────────────────────────
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepNavy, AppColors.backgroundBlack],
          stops: [0.0, 0.8],
        ).createShader(rect),
    );

    // ── Red glow — centre, breathes with animation ─────────────────────
    final redCenter = Offset(size.width * 0.65, size.height * 0.38);
    final redRadius = size.width * 0.55 + t * size.width * 0.07;
    canvas.drawCircle(
      redCenter,
      redRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.airlineRed.withValues(alpha: 0.11),
            AppColors.airlineRed.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: redCenter, radius: redRadius)),
    );

    // ── Navy glow — bottom-left counterbalance ─────────────────────────
    final navyCenter = Offset(size.width * 0.1, size.height * 0.82);
    final navyRadius = size.width * 0.45 - t * size.width * 0.04;
    canvas.drawCircle(
      navyCenter,
      navyRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.deepNavy.withValues(alpha: 0.70),
            AppColors.deepNavy.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: navyCenter, radius: navyRadius)),
    );

    // ── Faint route-map arc lines ──────────────────────────────────────
    _drawRouteLines(canvas, size);

    // ── Floating micro-particles ──────────────────────────────────────
    _drawParticles(canvas, size);
  }

  void _drawRouteLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.028)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final yBase = 0.30 + i * 0.13;
      final path = Path()
        ..moveTo(0, size.height * yBase)
        ..quadraticBezierTo(
          size.width * 0.45,
          size.height * (yBase - 0.07 + math.sin(t * 2 + i * 0.8) * 0.015),
          size.width,
          size.height * (yBase + 0.05),
        );
      canvas.drawPath(path, paint);
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    final offsets = [
      Offset(size.width * 0.12, size.height * 0.22 + math.sin(t * math.pi) * 5),
      Offset(size.width * 0.82, size.height * 0.14 - math.cos(t * math.pi) * 4),
      Offset(
        size.width * 0.55,
        size.height * 0.72 + math.sin(t * math.pi * 1.3) * 6,
      ),
      Offset(
        size.width * 0.28,
        size.height * 0.88 - math.cos(t * math.pi * 0.7) * 3,
      ),
    ];
    for (final off in offsets) {
      canvas.drawCircle(
        off,
        2.0,
        Paint()..color = Colors.white.withValues(alpha: 0.06),
      );
    }
  }

  @override
  bool shouldRepaint(_BPBgPainter old) => old.t != t;
}
