import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Reusable elite ambient background widget.
///
/// Matches the visual quality of [EliteHomeBackground] but is parameterised
/// so every screen can have a slightly different atmospheric flavour while
/// remaining part of the same design system.
///
/// Parameters:
///   [redGlowFraction]  — where the red bloom centres [0,1] × width fraction
///   [redGlowAlpha]     — peak red bloom opacity (0.10–0.22 typical)
///   [showRunway]       — only Home needs the runway perspective lines
///   [loopSeconds]      — animation loop duration (default 18 s)
class EliteScreenBackground extends StatefulWidget {
  const EliteScreenBackground({
    super.key,
    this.redGlowFraction = 0.5,
    this.redGlowAlpha = 0.15,
    this.showRunway = false,
    this.loopSeconds = 18,
  });

  final double redGlowFraction;
  final double redGlowAlpha;
  final bool showRunway;
  final int loopSeconds;

  @override
  State<EliteScreenBackground> createState() => _EliteScreenBackgroundState();
}

class _EliteScreenBackgroundState extends State<EliteScreenBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.loopSeconds),
    )..repeat();
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
        painter: _EliteScreenBgPainter(
          t: _ctrl.value,
          redGlowFraction: widget.redGlowFraction,
          redGlowAlpha: widget.redGlowAlpha,
          showRunway: widget.showRunway,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _EliteScreenBgPainter extends CustomPainter {
  const _EliteScreenBgPainter({
    required this.t,
    required this.redGlowFraction,
    required this.redGlowAlpha,
    required this.showRunway,
  });

  final double t;
  final double redGlowFraction;
  final double redGlowAlpha;
  final bool showRunway;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ── 1. Base atmosphere ─────────────────────────────────────────────
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

    // ── 2. Red glow — breathing ────────────────────────────────────────
    final alpha = redGlowAlpha + math.sin(t * math.pi * 2) * 0.022;
    _drawRadialGlow(
      canvas,
      center: Offset(size.width * redGlowFraction, size.height * 0.28),
      radius: size.width * 0.72,
      color: AppColors.airlineRed,
      alpha: alpha,
    );

    // ── 3. Blue-navy counter glow ──────────────────────────────────────
    _drawRadialGlow(
      canvas,
      center: Offset(size.width * (1 - redGlowFraction), size.height * 0.78),
      radius: size.width * 0.60,
      color: const Color(0xFF2A6FBA),
      alpha: 0.10,
    );

    // ── 4. Route map lines ─────────────────────────────────────────────
    _drawRouteLines(canvas, size);

    // ── 5. Glass reflections ───────────────────────────────────────────
    _drawGlassReflections(canvas, size);

    // ── 6. Micro-particles ─────────────────────────────────────────────
    _drawParticles(canvas, size);

    // ── 7. Optional runway ─────────────────────────────────────────────
    if (showRunway) _drawRunway(canvas, size);
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

  void _drawRouteLines(Canvas canvas, Size size) {
    final phase = math.sin(t * math.pi * 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.038);

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
      ..strokeWidth = 0.9
      ..color = AppColors.airlineRed.withValues(alpha: 0.042);
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

  void _drawGlassReflections(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14
      ..color = Colors.white.withValues(alpha: 0.018);
    final drift = math.sin(t * math.pi * 2) * 10;
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.18 + i * 0.32) + drift;
      canvas.drawLine(
        Offset(x, size.height * -0.10),
        Offset(x + size.width * 0.22, size.height * 0.44),
        paint,
      );
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    for (var i = 0; i < 12; i++) {
      final baseX = ((i * 37 + 11) % 100) / 100;
      final baseY = ((i * 61 + 19) % 100) / 100;
      final dX = math.sin(t * math.pi * 2 + i) * 4;
      final dY = math.cos(t * math.pi * 2 + i * 0.7) * 3;
      canvas.drawCircle(
        Offset(size.width * baseX + dX, size.height * baseY + dY),
        i % 3 == 0 ? 1.2 : 0.75,
        Paint()..color = Colors.white.withValues(alpha: 0.045 + (i % 4) * 0.01),
      );
    }
  }

  void _drawRunway(Canvas canvas, Size size) {
    final horizon = Offset(size.width * 0.52, size.height * 0.58);
    final bottomY = size.height * 1.03;
    final pulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);

    canvas.drawLine(
      horizon,
      Offset(size.width * 0.50, bottomY),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.7
        ..color = Colors.white.withValues(alpha: 0.08),
    );

    for (var i = 0; i < 13; i++) {
      final p = i / 12;
      final depth = math.pow(p, 1.65).toDouble();
      final y = _mix(horizon.dy, bottomY, depth);
      final spread = _mix(18, size.width * 0.44, depth);
      final radius = _mix(1.1, 4.3, depth);
      final alpha = _mix(0.12, 0.48, depth) * (0.82 + pulse * 0.18);

      final paint = Paint()
        ..color = (i.isEven ? AppColors.airlineRed : Colors.white).withValues(
          alpha: alpha,
        );
      canvas.drawCircle(Offset(horizon.dx - spread, y), radius, paint);
      canvas.drawCircle(Offset(horizon.dx + spread, y), radius, paint);
    }
  }

  double _mix(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(_EliteScreenBgPainter old) =>
      old.t != t ||
      old.redGlowFraction != redGlowFraction ||
      old.redGlowAlpha != redGlowAlpha;
}
