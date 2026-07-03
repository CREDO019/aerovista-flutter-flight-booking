import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/premium_button.dart';

class OnboardingActionBar extends StatelessWidget {
  const OnboardingActionBar({
    super.key,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PremiumButton(
          label: isLastPage
              ? AppStrings.onboardingStart
              : AppStrings.onboardingNext,
          onPressed: onNext,
        ),
        if (!isLastPage) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            ),
            child: Text(
              AppStrings.onboardingSkip,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.54),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 48),
        ],
      ],
    );
  }
}
