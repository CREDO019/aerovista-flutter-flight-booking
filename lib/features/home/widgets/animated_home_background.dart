import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen animated background for the Home screen.
///
/// Renders a dark gradient with a subtle pulsing red glow (top-right),
/// a navy glow (bottom-left), and three slow-drifting abstract shapes.
/// Everything is drawn with [CustomPainter] — no image assets used.
class AnimatedHomeBackground extends StatefulWidget {
  const AnimatedHomeBackground({super.key});

  @override
  State<AnimatedHomeBackground> createState() => _AnimatedHomeBackgroundState();
}

class _AnimatedHomeBackgroundState extends State<AnimatedHomeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 6-second loop — slow enough to feel ambient, not distracting.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
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
        painter: _BackgroundPainter(_controller.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter(this.t);
  final double t; // 0.0 → 1.0 (oscillates via reverse: true)

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ── 1. Base dark gradient ─────────────────────────────────────────────
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepNavy, AppColors.backgroundBlack],
        ).createShader(rect),
    );

    // ── 2. Red glow — top-right, breathes gently ──────────────────────────
    final redCenter = Offset(size.width * 0.88, size.height * 0.12);
    final redRadius = size.width * 0.42 + t * size.width * 0.06;
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

    // ── 3. Navy glow — bottom-left, breathes opposite phase ───────────────
    final navyCenter = Offset(size.width * 0.08, size.height * 0.78);
    final navyRadius = size.width * 0.52 - t * size.width * 0.05;
    canvas.drawCircle(
      navyCenter,
      navyRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.deepNavy.withValues(alpha: 0.65),
            AppColors.deepNavy.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: navyCenter, radius: navyRadius)),
    );

    // ── 4. Floating abstract shapes ────────────────────────────────────────
    _drawShape(
      canvas,
      center: Offset(
        size.width * 0.18,
        size.height * 0.30 + math.sin(t * math.pi * 2) * 7,
      ),
      radius: 38,
      alpha: 0.04,
    );
    _drawShape(
      canvas,
      center: Offset(
        size.width * 0.78,
        size.height * 0.52 - math.cos(t * math.pi * 2) * 5,
      ),
      radius: 55,
      alpha: 0.03,
    );
    _drawShape(
      canvas,
      center: Offset(
        size.width * 0.48,
        size.height * 0.88 + math.sin(t * math.pi) * 4,
      ),
      radius: 28,
      alpha: 0.05,
    );
  }

  void _drawShape(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double alpha,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) => old.t != t;
}
