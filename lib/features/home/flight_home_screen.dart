import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/flight_results_args.dart';
import '../../shared/widgets/app_disclaimer.dart';
import '../../shared/widgets/premium_button.dart';
import 'widgets/elite_flight_console.dart';
import 'widgets/elite_home_background.dart';
import 'widgets/elite_home_header.dart';

/// Premium home screen — Step 2 transformation.
///
/// Layout (bottom-up z-order):
///   1. [AnimatedHomeBackground] — full-screen canvas (ambient glows)
///   2. Foreground scroll content: Header → Search card → CTAs → Disclaimer
///
/// All entrance animations are driven by [flutter_animate] with staggered delays
/// so each section glides in after the previous one.
class FlightHomeScreen extends StatelessWidget {
  const FlightHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxHeight < 740 || constraints.maxWidth < 390;
          final horizontalPadding = compact ? AppSpacing.md : AppSpacing.lg;
          final topGap = compact ? AppSpacing.md : AppSpacing.xl;
          final heroGap = compact ? AppSpacing.md : AppSpacing.xl;
          final actionGap = compact ? AppSpacing.md : AppSpacing.lg;

          return Stack(
            children: [
              const EliteHomeBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: topGap),
                      EliteHomeHeader(compact: compact),
                      SizedBox(height: heroGap),
                      EliteFlightConsole(compact: compact)
                          .animate(delay: 850.ms)
                          .fadeIn(duration: 560.ms, curve: Curves.easeOut)
                          .scale(
                            begin: const Offset(0.97, 0.97),
                            end: const Offset(1, 1),
                            duration: 560.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            duration: 560.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      SizedBox(height: actionGap),
                      PremiumButton(
                            label: AppStrings.searchFlights,
                            icon: Icons.travel_explore_rounded,
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.results,
                              arguments: const FlightResultsArgs(
                                destinationCode: 'CDG',
                              ),
                            ),
                          )
                          .animate(delay: 1250.ms)
                          .fadeIn(duration: 420.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.10, end: 0, duration: 420.ms),
                      SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                      Center(
                            child: _ExplorePill(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.explore,
                              ),
                            ),
                          )
                          .animate(delay: 1350.ms)
                          .fadeIn(duration: 420.ms, curve: Curves.easeOut),
                      SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                      Center(
                            child: Opacity(
                              opacity: 0.72,
                              child: const AppDisclaimer(),
                            ),
                          )
                          .animate(delay: 1450.ms)
                          .fadeIn(duration: 420.ms, curve: Curves.easeOut),
                      SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widget
// ─────────────────────────────────────────────────────────────────────────────

class _ExplorePill extends StatefulWidget {
  const _ExplorePill({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_ExplorePill> createState() => _ExplorePillState();
}

class _ExplorePillState extends State<_ExplorePill> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassWhite.withValues(alpha: 0.68),
            borderRadius: AppRadius.pillRadius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.explore_rounded,
                size: 17,
                color: AppColors.softRed,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                AppStrings.exploreDestinations,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
