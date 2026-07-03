import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

/// A reusable semi-transparent card with a glassmorphism feel.
///
/// Wrap any content in [GlassCard] to get consistent dark-glass
/// surface styling across the app.
///
/// Usage:
/// ```dart
/// GlassCard(
///   child: Text('Hello'),
/// )
/// ```
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius,
    this.hasShadow = true,
    this.hasBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  /// Whether to apply a subtle drop shadow beneath the card.
  final bool hasShadow;

  /// Whether to render a soft border.
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: borderRadius ?? AppRadius.lgRadius,
        border: hasBorder
            ? Border.all(color: AppColors.borderSoft, width: 1)
            : null,
        boxShadow: hasShadow ? AppShadows.softCardShadow : null,
      ),
      child: child,
    );
  }
}
