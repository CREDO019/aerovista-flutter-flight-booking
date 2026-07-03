import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// Compact route preview with a subtle animated shimmer.
class DestinationRoutePreview extends StatefulWidget {
  const DestinationRoutePreview({
    super.key,
    required this.airportCode,
    this.compact = false,
  });

  final String airportCode;
  final bool compact;

  @override
  State<DestinationRoutePreview> createState() =>
      _DestinationRoutePreviewState();
}

class _DestinationRoutePreviewState extends State<DestinationRoutePreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.compact ? 28 : 34,
      child: Row(
        children: [
          Text(
            'IST → ${widget.airportCode}',
            style: AppTextStyles.subtitle.copyWith(
              color: Colors.white,
              fontSize: widget.compact ? 12 : 13,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, _) => CustomPaint(
                painter: _RouteLinePainter(_ctrl.value),
                child: const SizedBox(height: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteLinePainter extends CustomPainter {
  const _RouteLinePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    const dotRadius = 1.5;
    const gap = 9.0;
    for (double x = dotRadius; x < size.width; x += gap) {
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }

    final planeX = size.width * t;
    PremiumPlaneMarkerPainter.paintMarker(
      canvas,
      center: Offset(planeX, y),
      rotation: 0,
      size: 16,
      variant: PlaneMarkerVariant.minimal,
      color: AppColors.softRed,
      glow: false,
    );
  }

  @override
  bool shouldRepaint(_RouteLinePainter oldDelegate) => oldDelegate.t != t;
}
