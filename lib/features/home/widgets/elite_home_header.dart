import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

class EliteHomeHeader extends StatelessWidget {
  const EliteHomeHeader({super.key, required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleSize = compact ? 31.0 : 38.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LoungeBadge()
            .animate(delay: 150.ms)
            .fadeIn(duration: 520.ms, curve: Curves.easeOut)
            .slideY(begin: 0.12, end: 0, duration: 520.ms),
        SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
        Text(
              'İyi akşamlar, Emirhan',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.92),
              ),
            )
            .animate(delay: 300.ms)
            .fadeIn(duration: 540.ms, curve: Curves.easeOut)
            .slideY(begin: 0.18, end: 0, duration: 540.ms),
        SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
        Text(
              'Sonraki rotanı\ngökyüzünde çiz.',
              style: AppTextStyles.display.copyWith(
                fontSize: titleSize,
                height: 1.04,
              ),
            )
            .animate(delay: 450.ms)
            .fadeIn(duration: 650.ms, curve: Curves.easeOut)
            .blurXY(begin: 8, end: 0, duration: 650.ms)
            .slideY(begin: 0.12, end: 0, duration: 650.ms),
        SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: compact ? 310 : 350),
          child:
              Text(
                    'Uçuşunu daha akıcı, sakin ve premium bir deneyimle planla.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.86),
                      height: compact ? 1.35 : 1.45,
                    ),
                  )
                  .animate(delay: 650.ms)
                  .fadeIn(duration: 540.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.12, end: 0, duration: 540.ms),
        ),
      ],
    );
  }
}

class _LoungeBadge extends StatelessWidget {
  const _LoungeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PremiumPlaneMarker(
            size: 15,
            variant: PlaneMarkerVariant.minimal,
            glow: false,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'AeroVista Lounge',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.softRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.airlineRed.withValues(alpha: 0.48),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
