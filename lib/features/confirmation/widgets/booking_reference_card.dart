import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Booking reference display card.
///
/// Shows the reference code prominently with a subtle copy icon (visual only)
/// and the concept disclaimer below.
class BookingReferenceCard extends StatelessWidget {
  const BookingReferenceCard({super.key, required this.reference});

  /// The formatted reference string, e.g. "AV-F001".
  final String reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Label ────────────────────────────────────────────────
          Text(
            AppStrings.bookingReference.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 2.2,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Reference code + copy icon ────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                reference,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.airlineRed,
                  letterSpacing: 2.5,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.copy_rounded,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Concept disclaimer ────────────────────────────────────
          Text(
            AppStrings.conceptTicket,
            style: AppTextStyles.caption.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary.withValues(alpha: 0.65),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
