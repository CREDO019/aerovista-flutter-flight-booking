import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// Smooth destination page indicator driven by the PageView position.
class DestinationPageIndicator extends StatelessWidget {
  const DestinationPageIndicator({
    super.key,
    required this.count,
    required this.page,
  });

  final int count;
  final double page;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final distance = (page - index).abs().clamp(0.0, 1.0).toDouble();
        final active = 1.0 - distance;
        final width = 7.0 + active * 18.0;
        final color = Color.lerp(
          AppColors.textSecondary.withValues(alpha: 0.28),
          AppColors.airlineRed,
          active,
        );

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: width,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.pillRadius,
            boxShadow: active > 0.4
                ? [
                    BoxShadow(
                      color: AppColors.airlineRed.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
