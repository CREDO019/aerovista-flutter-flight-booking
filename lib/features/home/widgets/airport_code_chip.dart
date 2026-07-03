import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Displays an IATA airport code prominently with the city name below.
///
/// Used on the flight search card to make the route segment visually dominant.
class AirportCodeChip extends StatelessWidget {
  const AirportCodeChip({
    super.key,
    required this.code,
    required this.city,
    this.alignRight = false,
  });

  /// Three-letter IATA code, e.g. "IST".
  final String code;

  /// Full city name, e.g. "Istanbul".
  final String city;

  /// When true, text is right-aligned (for the destination side).
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          code,
          style: AppTextStyles.display.copyWith(
            fontSize: 30,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          city,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
