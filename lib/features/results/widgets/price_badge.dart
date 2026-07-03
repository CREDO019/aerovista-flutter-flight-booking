import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Compact price display badge used in flight result cards.
///
/// Shows the price in a visually prominent style with a subtle red tint
/// background and a small "USD" unit label.
class PriceBadge extends StatelessWidget {
  const PriceBadge({super.key, required this.price});

  /// Price in whole USD, e.g. 849.
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.airlineRed.withValues(alpha: 0.10),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.airlineRed.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'USD',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.softRed,
              letterSpacing: 1,
            ),
          ),
          Text(
            '\$$price',
            style: AppTextStyles.title.copyWith(
              color: AppColors.airlineRed,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
