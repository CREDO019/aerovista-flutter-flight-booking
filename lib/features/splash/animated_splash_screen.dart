import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_disclaimer.dart';
import '../../shared/widgets/premium_plane_marker.dart';

/// Animated splash screen.
///
/// Displays the AeroVista brand mark with a fade+slide entrance animation,
/// then automatically navigates to onboarding after ~2.5 seconds.
class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // Navigate to Home after content has had time to animate in.
    _navigationTimer = Timer(const Duration(milliseconds: 2400), _goHome);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.backgroundBlack],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Brand icon placeholder ─────────────────────────────────
              Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.airlineRed,
                      shape: BoxShape.circle,
                    ),
                    child: const PremiumPlaneMarker(
                      size: 34,
                      rotation: -0.10,
                      variant: PlaneMarkerVariant.route,
                      color: Colors.white,
                      glow: false,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.72, 0.72),
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  ),

              const SizedBox(height: AppSpacing.lg),

              // ── App name ───────────────────────────────────────────────
              Text(AppStrings.appName, style: AppTextStyles.display)
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(
                    begin: 0.16,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  ),

              const SizedBox(height: AppSpacing.sm),

              // ── Tagline ────────────────────────────────────────────────
              Text(AppStrings.appTagline, style: AppTextStyles.body)
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(
                    begin: 0.14,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  ),

              const SizedBox(height: AppSpacing.xxl * 2),

              // ── Disclaimer ─────────────────────────────────────────────
              const AppDisclaimer()
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
