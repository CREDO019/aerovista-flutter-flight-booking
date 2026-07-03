import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Premium header for the destination discovery screen.
class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
              children: [
                _BackButton(onBack: onBack),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.airlineRed.withValues(alpha: 0.12),
                    borderRadius: AppRadius.pillRadius,
                    border: Border.all(
                      color: AppColors.airlineRed.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Text(
                    'Rota Keşfi',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.softRed,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 450.ms)
            .slideY(begin: -0.10, end: 0, duration: 450.ms),
        SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
        Text(
              'Rotanı dünyada seç.',
              style: AppTextStyles.display.copyWith(
                fontSize: compact ? 28 : 31,
                height: 1.06,
                letterSpacing: 0,
              ),
            )
            .animate(delay: 120.ms)
            .fadeIn(duration: 560.ms)
            .slideY(begin: 0.12, end: 0, duration: 560.ms),
        const SizedBox(height: AppSpacing.sm),
        Text(
              'Türkiye içi ve yurt dışı uçuşları sinematik bir rota deneyimiyle keşfet.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.68),
                letterSpacing: 0,
              ),
            )
            .animate(delay: 230.ms)
            .fadeIn(duration: 520.ms)
            .slideY(begin: 0.08, end: 0, duration: 520.ms),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
