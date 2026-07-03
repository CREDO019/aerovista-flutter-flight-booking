import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Top header for the boarding pass screen.
///
/// Displays:
///   - Custom back button
///   - "Boarding Pass" screen label
///   - "Your journey is ready" hero title
///   - Supporting subtitle
///
/// Each element enters with a staggered flutter_animate fade+slide.
class BoardingPassHeader extends StatelessWidget {
  const BoardingPassHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Back + label row ───────────────────────────────────────────
        Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderSoft),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Biniş Kartı',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(
              begin: -0.06,
              end: 0,
              duration: 400.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: AppSpacing.md),

        // ── Hero title ─────────────────────────────────────────────────
        Text(AppStrings.boardingPassReady, style: AppTextStyles.display)
            .animate(delay: 100.ms)
            .fadeIn(duration: 500.ms)
            .slideY(
              begin: 0.12,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: AppSpacing.xs),

        // ── Subtitle ───────────────────────────────────────────────────
        Text(AppStrings.boardingPassSubtitle, style: AppTextStyles.body)
            .animate(delay: 200.ms)
            .fadeIn(duration: 500.ms)
            .slideY(
              begin: 0.08,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
      ],
    );
  }
}
