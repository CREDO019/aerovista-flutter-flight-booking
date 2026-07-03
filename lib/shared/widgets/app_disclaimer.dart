import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';

/// A small, unobtrusive legal disclaimer widget.
/// Displayed subtly at the bottom of the Splash and Home screens.
class AppDisclaimer extends StatelessWidget {
  const AppDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.disclaimer,
      style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
      textAlign: TextAlign.center,
    );
  }
}
