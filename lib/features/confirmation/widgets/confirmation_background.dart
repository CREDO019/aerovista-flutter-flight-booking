import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen ambient background for the Booking Confirmed screen.
///
/// This is the most dramatic background in the app — the "closing shot."
/// Features:
///   - Deep navy → black radial-tinted gradient
///   - A warm red bloom behind the centre content
///   - Faint navy glow at bottom
///   - Slow drifting abstract route arcs
///   - Subtle floating micro-particles
///
/// Powered by an 8-second reversing [AnimationController].
class ConfirmationBackground extends StatefulWidget {
  const ConfirmationBackground({super.key});

  @override
  State<ConfirmationBackground> createState() => _ConfirmationBackgroundState();
}

class _ConfirmationBackgroundState extends State<ConfirmationBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
        painter: _ConfBgPainter(_ctrl.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ConfBgPainter extends CustomPainter {
  const _ConfBgPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ── 1. Base gradient ───────────────────────────────────────────────
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.deepNavy, AppColors.backgroundBlack],
          stops: [0.0, 0.85],
        ).createShader(rect),
    );

    // ── 2. Central red bloom — breathes with animation ─────────────────
    final redCenter = Offset(size.width * 0.5, size.height * 0.38);
    final redRadius = size.width * 0.58 + t * size.width * 0.08;
    canvas.drawCircle(
      redCenter,
      redRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.airlineRed.withValues(alpha: 0.13),
            AppColors.airlineRed.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: redCenter, radius: redRadius)),
    );

    // ── 3. Navy glow — bottom, grounds the layout ──────────────────────
    final navyCenter = Offset(size.width * 0.5, size.height * 0.95);
    final navyRadius = size.width * 0.7 - t * size.width * 0.05;
    canvas.drawCircle(
      navyCenter,
      navyRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.deepNavy.withValues(alpha: 0.60),
            AppColors.deepNavy.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: navyCenter, radius: navyRadius)),
    );

    // ── 4. Abstract route arc lines ────────────────────────────────────
    _drawRouteArcs(canvas, size);

    // ── 5. Floating micro-particles ────────────────────────────────────
    _drawParticles(canvas, size);
  }

  void _drawRouteArcs(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.022)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final yFrac = 0.15 + i * 0.18;
      final amplitude = 0.06 + math.sin(t * 1.5 + i * 0.9) * 0.012;
      final path = Path()
        ..moveTo(0, size.height * yFrac)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * (yFrac - amplitude),
          size.width,
          size.height * (yFrac + 0.04),
        );
      canvas.drawPath(path, paint);
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    final positions = [
      Offset(size.width * 0.08, size.height * 0.20 + math.sin(t * math.pi) * 6),
      Offset(size.width * 0.88, size.height * 0.16 + math.cos(t * math.pi) * 5),
      Offset(
        size.width * 0.18,
        size.height * 0.75 - math.sin(t * math.pi * 0.8) * 4,
      ),
      Offset(
        size.width * 0.78,
        size.height * 0.80 + math.cos(t * math.pi * 1.2) * 6,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.92 - math.sin(t * math.pi * 0.6) * 3,
      ),
    ];
    for (final pos in positions) {
      canvas.drawCircle(
        pos,
        1.8,
        Paint()..color = Colors.white.withValues(alpha: 0.07),
      );
    }
  }

  @override
  bool shouldRepaint(_ConfBgPainter old) => old.t != t;
}
