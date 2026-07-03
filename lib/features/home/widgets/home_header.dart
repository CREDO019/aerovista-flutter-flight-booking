import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// Home screen header with staggered flutter_animate entrance animations.
///
/// Shows:
/// - A small plane badge + greeting line
/// - Main hero title
/// - Supporting subtitle
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Plane badge + greeting ──────────────────────────────────────
        Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.airlineRed.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.airlineRed.withValues(alpha: 0.38),
                    ),
                  ),
                  child: const PremiumPlaneMarker(
                    size: 16,
                    variant: PlaneMarkerVariant.minimal,
                    glow: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('İyi akşamlar, Emirhan', style: AppTextStyles.body),
              ],
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(
              begin: -0.08,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: AppSpacing.sm),

        // ── Hero title ─────────────────────────────────────────────────
        Text(
              'Sonraki yolculuğun\nnerede başlasın?',
              style: AppTextStyles.display,
            )
            .animate(delay: 150.ms)
            .fadeIn(duration: 600.ms)
            .slideY(
              begin: 0.14,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: AppSpacing.sm),

        // ── Subtitle ───────────────────────────────────────────────────
        Text(
              'Uçuşunu daha akıcı ve premium bir deneyimle planla.',
              style: AppTextStyles.body,
            )
            .animate(delay: 280.ms)
            .fadeIn(duration: 600.ms)
            .slideY(
              begin: 0.1,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
      ],
    );
  }
}
