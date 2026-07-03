import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Premium dark background for the Results screen.
///
/// Similar to the home screen ambient background but lighter on animation
/// weight — results are content-heavy so the background stays even subtler.
/// Uses a slow-breathing glow only. No AnimationController needed here;
/// a simple [flutter_animate] loop on the outer widget handles it cleanly
/// via a [CustomPaint] driven by a single [AnimationController].
class ResultsBackground extends StatefulWidget {
  const ResultsBackground({super.key});

  @override
  State<ResultsBackground> createState() => _ResultsBackgroundState();
}

class _ResultsBackgroundState extends State<ResultsBackground>
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
        painter: _ResultsBgPainter(_ctrl.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ResultsBgPainter extends CustomPainter {
  const _ResultsBgPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ── Base gradient ─────────────────────────────────────────────────────
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [AppColors.deepNavy, AppColors.backgroundBlack],
          stops: [0.0, 0.75],
        ).createShader(rect),
    );

    // ── Soft red accent glow — top-left ────────────────────────────────────
    final redCenter = Offset(size.width * 0.12, size.height * 0.08);
    final redRadius = size.width * 0.38 + t * size.width * 0.04;
    canvas.drawCircle(
      redCenter,
      redRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.airlineRed.withValues(alpha: 0.09),
            AppColors.airlineRed.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: redCenter, radius: redRadius)),
    );

    // ── Abstract flight-map lines ──────────────────────────────────────────
    _drawMapLines(canvas, size);
  }

  /// Draws a few very faint diagonal lines that evoke a flight-path map grid.
  void _drawMapLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Curved hint lines across the lower portion of the screen
    for (int i = 0; i < 4; i++) {
      final yFrac = 0.55 + i * 0.12;
      final path = Path()
        ..moveTo(0, size.height * yFrac)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * (yFrac - 0.06 + math.sin(t + i) * 0.02),
          size.width,
          size.height * (yFrac + 0.04),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_ResultsBgPainter old) => old.t != t;
}
