import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// [CustomPainter] that draws:
///   1. A dashed quadratic Bézier arc connecting two airport points.
///   2. A small custom-painted plane silhouette at position [planeT] along the arc.
///
/// [planeT] is the normalised curve parameter (0.0 = origin, 1.0 = destination).
/// The plane is rotated to follow the curve's tangent direction.
class AnimatedRoutePainter extends CustomPainter {
  const AnimatedRoutePainter({required this.planeT});

  final double planeT;

  // Control points expressed as fractions of the canvas size.
  // p0 = left (origin), p1 = apex (off-top for upward arc), p2 = right (destination).
  Offset _p0(Size s) => Offset(s.width * 0.06, s.height * 0.72);
  Offset _p1(Size s) => Offset(s.width * 0.50, -s.height * 0.10);
  Offset _p2(Size s) => Offset(s.width * 0.94, s.height * 0.72);

  @override
  void paint(Canvas canvas, Size size) {
    final p0 = _p0(size);
    final p1 = _p1(size);
    final p2 = _p2(size);

    _drawDashedArc(canvas, p0, p1, p2);
    _drawEndDots(canvas, p0, p2);
    _drawPlane(canvas, planeT, p0, p1, p2);
  }

  // ── Dashed arc ────────────────────────────────────────────────────────────

  void _drawDashedArc(Canvas canvas, Offset p0, Offset p1, Offset p2) {
    final paint = Paint()
      ..color = AppColors.borderSoft.withValues(alpha: 0.75)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Walk along the curve in 90 steps and alternate draw/skip every 3 steps.
    const total = 90;
    for (int i = 0; i < total; i++) {
      // Draw 2 segments, skip 1 → creates a clean dashed look.
      if (i % 3 == 2) continue;
      final t0 = i / total;
      final t1 = (i + 1) / total;
      canvas.drawLine(
        _bezierPoint(t0, p0, p1, p2),
        _bezierPoint(t1, p0, p1, p2),
        paint,
      );
    }
  }

  // ── Small dot markers at each endpoint ───────────────────────────────────

  void _drawEndDots(Canvas canvas, Offset p0, Offset p2) {
    final dotPaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: 0.6);
    canvas.drawCircle(p0, 3.5, dotPaint);
    canvas.drawCircle(p2, 3.5, dotPaint);
  }

  void _drawPlane(Canvas canvas, double t, Offset p0, Offset p1, Offset p2) {
    final pos = _bezierPoint(t, p0, p1, p2);
    final tangent = _bezierTangent(t, p0, p1, p2);
    final angle = math.atan2(tangent.dy, tangent.dx);

    PremiumPlaneMarkerPainter.paintMarker(
      canvas,
      center: pos,
      rotation: angle,
      size: 22,
      variant: PlaneMarkerVariant.route,
      glow: true,
      pulse: false,
    );
  }

  // ── Bézier math ───────────────────────────────────────────────────────────

  Offset _bezierPoint(double t, Offset p0, Offset p1, Offset p2) {
    final u = 1 - t;
    return Offset(
      u * u * p0.dx + 2 * u * t * p1.dx + t * t * p2.dx,
      u * u * p0.dy + 2 * u * t * p1.dy + t * t * p2.dy,
    );
  }

  /// First derivative of the quadratic Bézier gives the tangent direction.
  Offset _bezierTangent(double t, Offset p0, Offset p1, Offset p2) {
    final u = 1 - t;
    return Offset(
      2 * u * (p1.dx - p0.dx) + 2 * t * (p2.dx - p1.dx),
      2 * u * (p1.dy - p0.dy) + 2 * t * (p2.dy - p1.dy),
    );
  }

  @override
  bool shouldRepaint(AnimatedRoutePainter old) => old.planeT != planeT;
}
