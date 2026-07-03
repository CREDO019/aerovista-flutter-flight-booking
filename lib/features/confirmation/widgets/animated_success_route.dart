import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// The cinematic centrepiece of the confirmation screen.
///
/// Animation timeline (plays once, no loop):
///   0 ms        — widget builds, route line opacity starts at 0
///   200 ms      — route endpoints fade in
///   400 ms      — plane begins journey along the Bézier arc
///   400–1500 ms — plane travels left → right
///   1550 ms     — plane icon fades out
///   1600 ms     — success ✓ badge scales and fades in
///
/// All timing is driven by two [AnimationController] instances:
///   [_lineCtrl]  — draws the route line and fades the endpoints in (0→1)
///   [_planeCtrl] — moves the plane along the arc (0→1)
///
/// After [_planeCtrl] completes, [_showCheck] flips to true and the
/// check badge animates in via [flutter_animate].
class AnimatedSuccessRoute extends StatefulWidget {
  const AnimatedSuccessRoute({
    super.key,
    required this.fromCode,
    required this.fromAirportName,
    required this.toCode,
    required this.toAirportName,
  });

  final String fromCode;
  final String fromAirportName;
  final String toCode;
  final String toAirportName;

  @override
  State<AnimatedSuccessRoute> createState() => _AnimatedSuccessRouteState();
}

class _AnimatedSuccessRouteState extends State<AnimatedSuccessRoute>
    with TickerProviderStateMixin {
  late final AnimationController _lineCtrl;
  late final AnimationController _planeCtrl;
  Timer? _planeStartTimer;
  Timer? _checkTimer;
  bool _showCheck = false;

  @override
  void initState() {
    super.initState();

    // Route line draws in over 600 ms
    _lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Plane travels over 1100 ms, starting after 400 ms delay
    _planeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _planeCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // Short pause then show success check
        _checkTimer = Timer(const Duration(milliseconds: 80), () {
          if (mounted) setState(() => _showCheck = true);
        });
      }
    });

    // Stagger: line starts at 0ms, plane at 400ms
    _lineCtrl.forward();
    _planeStartTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _planeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _planeStartTimer?.cancel();
    _checkTimer?.cancel();
    _lineCtrl.dispose();
    _planeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: AnimatedBuilder(
        animation: Listenable.merge([_lineCtrl, _planeCtrl]),
        builder: (context, _) {
          return CustomPaint(
            painter: _RoutePainter(
              lineProgress: _lineCtrl.value,
              planeT: _planeCtrl.value,
              showPlane: _planeCtrl.value > 0 && _planeCtrl.value < 1.0,
              fromCode: widget.fromCode,
              toCode: widget.toCode,
            ),
            child: _buildLabelsAndCheck(),
          );
        },
      ),
    );
  }

  Widget _buildLabelsAndCheck() {
    return Stack(
      children: [
        // From code — left
        Positioned(
          left: 0,
          bottom: 8,
          child: AnimatedOpacity(
            opacity: _lineCtrl.value,
            duration: Duration.zero,
            child: Text(
              widget.fromCode,
              style: AppTextStyles.title.copyWith(
                fontSize: 18,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          width: 132,
          child: AnimatedOpacity(
            opacity: _lineCtrl.value,
            duration: Duration.zero,
            child: Text(
              widget.fromAirportName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(fontSize: 9),
            ),
          ),
        ),
        // To code — right
        Positioned(
          right: 0,
          bottom: 8,
          child: AnimatedOpacity(
            opacity: _lineCtrl.value,
            duration: Duration.zero,
            child: Text(
              widget.toCode,
              style: AppTextStyles.title.copyWith(
                fontSize: 18,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          width: 132,
          child: AnimatedOpacity(
            opacity: _lineCtrl.value,
            duration: Duration.zero,
            child: Text(
              widget.toAirportName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(fontSize: 9),
            ),
          ),
        ),
        // Success check badge — centre, appears after plane lands
        if (_showCheck)
          Positioned.fill(child: Center(child: _SuccessCheckBadge())),
      ],
    );
  }
}

/// Paints the curved route arc + progressive line draw + animated plane.
class _RoutePainter extends CustomPainter {
  const _RoutePainter({
    required this.lineProgress,
    required this.planeT,
    required this.showPlane,
    required this.fromCode,
    required this.toCode,
  });

  final double lineProgress; // 0→1 progressive arc draw
  final double planeT; // 0→1 plane position along arc
  final bool showPlane;
  final String fromCode;
  final String toCode;

  // Control points for the Bézier arc
  Offset _p0(Size s) => Offset(s.width * 0.06, s.height * 0.70);
  Offset _p1(Size s) => Offset(s.width * 0.50, s.height * 0.08);
  Offset _p2(Size s) => Offset(s.width * 0.94, s.height * 0.70);

  @override
  void paint(Canvas canvas, Size size) {
    final p0 = _p0(size);
    final p1 = _p1(size);
    final p2 = _p2(size);

    // ── Faint full arc (ghost guide) ───────────────────────────────────
    _drawArc(
      canvas,
      p0,
      p1,
      p2,
      1.0,
      AppColors.borderSoft.withValues(alpha: 0.35),
      1.0,
    );

    // ── Progressive arc draw (filled red up to lineProgress) ───────────
    _drawArc(canvas, p0, p1, p2, lineProgress, AppColors.airlineRed, 2.0);

    // ── Endpoint dots ──────────────────────────────────────────────────
    final dotPaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: lineProgress * 0.8);
    canvas.drawCircle(p0, 4, dotPaint);
    canvas.drawCircle(p2, 4, dotPaint);

    // ── Plane icon along arc ───────────────────────────────────────────
    if (showPlane) {
      final pos = _bezier(planeT, p0, p1, p2);
      final tan = _bezierTangent(planeT, p0, p1, p2);
      PremiumPlaneMarkerPainter.paintMarker(
        canvas,
        center: pos,
        rotation: math.atan2(tan.dy, tan.dx),
        size: 23,
        variant: PlaneMarkerVariant.route,
        glow: true,
        pulse: true,
        progress: planeT,
      );
    }
  }

  void _drawArc(
    Canvas canvas,
    Offset p0,
    Offset p1,
    Offset p2,
    double progress,
    Color color,
    double strokeWidth,
  ) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(p0.dx, p0.dy);
    final steps = (80 * progress).ceil().clamp(1, 80);
    for (int i = 1; i <= steps; i++) {
      final t = (i / 80) * progress;
      final pt = _bezier(t, p0, p1, p2);
      path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path, paint);
  }

  Offset _bezier(double t, Offset p0, Offset p1, Offset p2) {
    final u = 1 - t;
    return Offset(
      u * u * p0.dx + 2 * u * t * p1.dx + t * t * p2.dx,
      u * u * p0.dy + 2 * u * t * p1.dy + t * t * p2.dy,
    );
  }

  Offset _bezierTangent(double t, Offset p0, Offset p1, Offset p2) {
    final u = 1 - t;
    return Offset(
      2 * u * (p1.dx - p0.dx) + 2 * t * (p2.dx - p1.dx),
      2 * u * (p1.dy - p0.dy) + 2 * t * (p2.dy - p1.dy),
    );
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.lineProgress != lineProgress ||
      old.planeT != planeT ||
      old.showPlane != showPlane;
}

/// The success check badge that appears after the plane reaches the destination.
class _SuccessCheckBadge extends StatelessWidget {
  const _SuccessCheckBadge();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.82 + value * 0.18,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: SizedBox(
        width: 74,
        height: 74,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.airlineRed.withValues(alpha: 0.20),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.airlineRed.withValues(alpha: 0.22),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.airlineRed, AppColors.deepRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.airlineRed.withValues(alpha: 0.48),
                    blurRadius: 22,
                    spreadRadius: 1.5,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
