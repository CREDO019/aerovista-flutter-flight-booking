import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

class EliteRouteViewport extends StatefulWidget {
  const EliteRouteViewport({super.key, required this.compact});

  final bool compact;

  @override
  State<EliteRouteViewport> createState() => _EliteRouteViewportState();
}

class _EliteRouteViewportState extends State<EliteRouteViewport>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.compact ? 112 : 142,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundBlack.withValues(alpha: 0.55),
            AppColors.deepNavy.withValues(alpha: 0.52),
            AppColors.cardWhite.withValues(alpha: 0.62),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lgRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) => CustomPaint(
                  painter: _EliteRouteViewportPainter(_controller.value),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.sm,
              child: _AirportLabel(
                code: 'IST',
                city: 'İstanbul',
                compact: widget.compact,
              ),
            ),
            Positioned(
              right: AppSpacing.md,
              bottom: AppSpacing.sm,
              child: _AirportLabel(
                code: 'CDG',
                city: 'Paris',
                alignRight: true,
                compact: widget.compact,
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              top: AppSpacing.sm,
              child: Text(
                'Rota Önizleme',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.42),
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AirportLabel extends StatelessWidget {
  const _AirportLabel({
    required this.code,
    required this.city,
    required this.compact,
    this.alignRight = false,
  });

  final String code;
  final String city;
  final bool compact;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: AppTextStyles.subtitle.copyWith(
            color: Colors.white,
            fontSize: compact ? 13 : 15,
            letterSpacing: 1,
          ),
        ),
        Text(
          city,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.48),
            fontSize: compact ? 9 : 10,
          ),
        ),
      ],
    );
  }
}

class _EliteRouteViewportPainter extends CustomPainter {
  const _EliteRouteViewportPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    _drawAltitudeGrid(canvas, size);

    final p0 = Offset(size.width * 0.18, size.height * 0.70);
    final p1 = Offset(size.width * 0.32, size.height * 0.14);
    final p2 = Offset(size.width * 0.68, size.height * 0.12);
    final p3 = Offset(size.width * 0.84, size.height * 0.68);
    final easedT = Curves.easeInOutCubic.transform(t);
    final fade = _edgeFade(t);
    final plane = _cubic(easedT, p0, p1, p2, p3);
    final tangent = _cubicTangent(easedT, p0, p1, p2, p3);
    final angle = math.atan2(tangent.dy, tangent.dx);

    _drawGhostRoute(canvas, p0, p1, p2, p3);
    _drawProgressRoute(canvas, p0, p1, p2, p3, easedT, fade);
    _drawPlaneAura(canvas, plane, fade);
    _drawAirportNode(canvas, p0, 0);
    _drawAirportNode(canvas, p3, math.pi);

    if (fade > 0.02) {
      PremiumPlaneMarkerPainter.paintMarker(
        canvas,
        center: plane,
        rotation: angle,
        size: 24,
        variant: PlaneMarkerVariant.hero,
        color: AppColors.softRed,
        glow: true,
        pulse: true,
        progress: t,
      );
    }
  }

  void _drawAltitudeGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 0.8;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * (0.24 + i * 0.16);
      canvas.drawLine(
        Offset(size.width * 0.06, y),
        Offset(size.width * 0.94, y),
        paint,
      );
    }

    final diagonalPaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: 0.035)
      ..strokeWidth = 0.8;
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.08 + i * 0.2);
      canvas.drawLine(
        Offset(x, size.height * 0.16),
        Offset(x + size.width * 0.13, size.height * 0.86),
        diagonalPaint,
      );
    }
  }

  void _drawGhostRoute(
    Canvas canvas,
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
  ) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 72; i++) {
      if (i % 3 == 2) continue;
      final a = i / 72;
      final b = (i + 1) / 72;
      canvas.drawLine(
        _cubic(a, p0, p1, p2, p3),
        _cubic(b, p0, p1, p2, p3),
        paint,
      );
    }
  }

  void _drawProgressRoute(
    Canvas canvas,
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
    double progress,
    double fade,
  ) {
    if (progress <= 0 || fade <= 0) return;

    final trailStart = math.max(0.0, progress - 0.20);
    final trailPaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: 0.18 * fade)
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final brightPaint = Paint()
      ..color = AppColors.softRed.withValues(alpha: 0.82 * fade)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    _drawSampledPath(canvas, p0, p1, p2, p3, 0, progress, brightPaint);
    _drawSampledPath(canvas, p0, p1, p2, p3, trailStart, progress, trailPaint);
  }

  void _drawSampledPath(
    Canvas canvas,
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
    double from,
    double to,
    Paint paint,
  ) {
    const steps = 64;
    final startStep = (from * steps).floor();
    final endStep = math.max(startStep + 1, (to * steps).ceil());

    for (var i = startStep; i < endStep; i++) {
      final a = (i / steps).clamp(from, to);
      final b = ((i + 1) / steps).clamp(from, to);
      canvas.drawLine(
        _cubic(a, p0, p1, p2, p3),
        _cubic(b, p0, p1, p2, p3),
        paint,
      );
    }
  }

  void _drawPlaneAura(Canvas canvas, Offset center, double fade) {
    if (fade <= 0) return;
    final radius = 24.0 + math.sin(t * math.pi * 2) * 2.5;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.airlineRed.withValues(alpha: 0.10 * fade),
            AppColors.airlineRed.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _drawAirportNode(Canvas canvas, Offset center, double phase) {
    final pulse = 0.5 + 0.5 * math.sin(t * math.pi * 2 + phase);
    canvas.drawCircle(
      center,
      8 + pulse * 3,
      Paint()..color = AppColors.airlineRed.withValues(alpha: 0.08),
    );
    canvas.drawCircle(
      center,
      4.5,
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      center,
      2.6,
      Paint()..color = AppColors.softRed.withValues(alpha: 0.76),
    );
  }

  Offset _cubic(double t, Offset p0, Offset p1, Offset p2, Offset p3) {
    final u = 1 - t;
    return Offset(
      u * u * u * p0.dx +
          3 * u * u * t * p1.dx +
          3 * u * t * t * p2.dx +
          t * t * t * p3.dx,
      u * u * u * p0.dy +
          3 * u * u * t * p1.dy +
          3 * u * t * t * p2.dy +
          t * t * t * p3.dy,
    );
  }

  Offset _cubicTangent(double t, Offset p0, Offset p1, Offset p2, Offset p3) {
    final u = 1 - t;
    return Offset(
      3 * u * u * (p1.dx - p0.dx) +
          6 * u * t * (p2.dx - p1.dx) +
          3 * t * t * (p3.dx - p2.dx),
      3 * u * u * (p1.dy - p0.dy) +
          6 * u * t * (p2.dy - p1.dy) +
          3 * t * t * (p3.dy - p2.dy),
    );
  }

  double _edgeFade(double value) {
    final start = Curves.easeOut.transform((value / 0.12).clamp(0.0, 1.0));
    final end = Curves.easeIn.transform(((1 - value) / 0.12).clamp(0.0, 1.0));
    return math.min(start, end);
  }

  @override
  bool shouldRepaint(_EliteRouteViewportPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
