import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// A single labelled info tile used inside the boarding pass detail grid.
///
/// Shows a faint [label] above a bold [value], with an optional [icon].
class BoardingInfoTile extends StatelessWidget {
  const BoardingInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label row
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 11, color: AppColors.airlineRed),
              const SizedBox(width: 4),
            ],
            Text(
              label.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                letterSpacing: 1.2,
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        // Value
        Text(
          value,
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 15,
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        // Bottom accent line
        Container(height: 1, color: AppColors.borderSoft),
      ],
    );
  }
}
