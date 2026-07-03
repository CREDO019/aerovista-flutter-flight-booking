import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'animated_route_painter.dart';

/// Mini animated route card shown inside [GlassFlightSearchCard].
///
/// Renders the Bézier arc + moving plane using [AnimatedRoutePainter],
/// driven by a looping [AnimationController].
class RoutePreviewCard extends StatefulWidget {
  const RoutePreviewCard({super.key});

  @override
  State<RoutePreviewCard> createState() => _RoutePreviewCardState();
}

class _RoutePreviewCardState extends State<RoutePreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 5-second loop — smooth, slow enough to be cinematic.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
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
      height: 108,
      decoration: BoxDecoration(
        color: AppColors.cardWhite.withValues(alpha: 0.5),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Stack(
        children: [
          // ── Animated route arc + plane ──────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) => CustomPaint(
                painter: AnimatedRoutePainter(planeT: _controller.value),
              ),
            ),
          ),

          // ── Origin label ────────────────────────────────────────────
          Positioned(
            left: AppSpacing.md,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IST',
                  style: AppTextStyles.subtitle.copyWith(fontSize: 13),
                ),
                Text('İstanbul', style: AppTextStyles.caption),
              ],
            ),
          ),

          // ── Destination label ────────────────────────────────────────
          Positioned(
            right: AppSpacing.md,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'CDG',
                  style: AppTextStyles.subtitle.copyWith(fontSize: 13),
                ),
                Text('Paris', style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
