import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/flight_model.dart';
import '../../../shared/widgets/premium_button.dart';

/// Primary + secondary action row for the confirmation screen.
///
/// Primary  — "View Boarding Pass" → pushReplacementNamed to boardingPass
/// Secondary — "Back to Home" → pushNamedAndRemoveUntil to home
class ConfirmationActionRow extends StatelessWidget {
  const ConfirmationActionRow({super.key, required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Primary CTA ──────────────────────────────────────────────
        PremiumButton(
              label: AppStrings.viewBoardingPass,
              icon: Icons.credit_card_rounded,
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRoutes.boardingPass,
                arguments: flight,
              ),
            )
            .animate(delay: 2200.ms)
            .fadeIn(duration: 450.ms)
            .slideY(begin: 0.10, end: 0, duration: 450.ms),

        const SizedBox(height: AppSpacing.md),

        // ── Secondary: Back to Home ───────────────────────────────────
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: AppRadius.pillRadius,
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.home_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.backToHome,
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: 2350.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}
