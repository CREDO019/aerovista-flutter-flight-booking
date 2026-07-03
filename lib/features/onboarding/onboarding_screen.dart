import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_disclaimer.dart';
import '../../shared/widgets/elite_screen_background.dart';
import 'widgets/onboarding_action_bar.dart';
import 'widgets/onboarding_globe_scene.dart';
import 'widgets/onboarding_indicator.dart';
import 'widgets/onboarding_page_model.dart';
import 'widgets/onboarding_page_view.dart';
import 'widgets/onboarding_scenes.dart';

/// Premium cinematic onboarding intro flow.
///
/// Directs new users through core value concepts of the redesign concept.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      OnboardingPageModel(
        title: AppStrings.onboardingPage1Title,
        subtitle: AppStrings.onboardingPage1Subtitle,
        visual: OnboardingGlobeScene(isActive: _currentPage == 0),
      ),
      OnboardingPageModel(
        title: AppStrings.onboardingPage2Title,
        subtitle: AppStrings.onboardingPage2Subtitle,
        visual: const OnboardingConsoleScene(),
      ),
      OnboardingPageModel(
        title: AppStrings.onboardingPage3Title,
        subtitle: AppStrings.onboardingPage3Subtitle,
        visual: const OnboardingTicketScene(),
      ),
    ];

    final compact = MediaQuery.sizeOf(context).height < 740;

    return Scaffold(
      body: Stack(
        children: [
          // Atmosphere
          const EliteScreenBackground(
            redGlowFraction: 0.50,
            redGlowAlpha: 0.16,
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: AppSpacing.lg,
                      top: AppSpacing.sm,
                    ),
                    child: AnimatedOpacity(
                      opacity: _currentPage == 2 ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: _currentPage == 2,
                        child: TextButton(
                          onPressed: _navigateToLogin,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.04,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.pillRadius,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                          ),
                          child: Text(
                            AppStrings.onboardingSkip,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: OnboardingPageView(
                    controller: _pageController,
                    pages: pages,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OnboardingIndicator(
                        itemCount: pages.length,
                        currentIndex: _currentPage,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      OnboardingActionBar(
                        isLastPage: _currentPage == 2,
                        onNext: _nextPage,
                        onSkip: _navigateToLogin,
                      ),
                      SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                      const AppDisclaimer(),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
