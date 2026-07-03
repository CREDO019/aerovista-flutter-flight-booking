import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AeroVista shadow tokens.
class AppShadows {
  AppShadows._();

  /// Subtle depth shadow for cards.
  static final List<BoxShadow> softCardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Glowing red accent shadow for interactive elements.
  static final List<BoxShadow> redGlowShadow = [
    BoxShadow(
      color: AppColors.airlineRed.withValues(alpha: 0.45),
      blurRadius: 24,
      spreadRadius: 2,
      offset: const Offset(0, 6),
    ),
  ];
}
