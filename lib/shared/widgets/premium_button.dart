import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

/// A reusable premium CTA button.
///
/// Features:
/// - Red gradient fill (softRed → airlineRed)
/// - Red glow drop-shadow
/// - Pill shape
/// - Tactile press animation (scale 1.0 → 0.96 on tap-down, restores on release)
/// - Optional leading icon
///
/// Usage:
/// ```dart
/// PremiumButton(
///   label: 'Search Flights',
///   icon: Icons.search_rounded,
///   onPressed: () { ... },
/// )
/// ```
class PremiumButton extends StatefulWidget {
  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
  });

  final String label;
  final VoidCallback onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Stretches to fill available width when true (default).
  final bool isFullWidth;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.965,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _ctrl.forward();

  void _onTapUp(TapUpDetails _) => _ctrl.reverse();

  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, _) {
          final press = _ctrl.value;

          return Transform.scale(
            scale: _scale.value,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.pillRadius,
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      AppColors.deepRed,
                      AppColors.airlineRed,
                      0.30 + press * 0.16,
                    )!,
                    Color.lerp(
                      AppColors.airlineRed,
                      AppColors.softRed,
                      0.20 + press * 0.18,
                    )!,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.11 + press * 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.airlineRed.withValues(
                      alpha: 0.30 + press * 0.16,
                    ),
                    blurRadius: 22 + press * 10,
                    spreadRadius: 1 + press * 1.5,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.26),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 18,
                    right: 18,
                    top: 1,
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.32 + press * 0.12),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.isFullWidth ? double.infinity : null,
                    height: 54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.lg),
                            child: Transform.translate(
                              offset: Offset(press * 2, 0),
                              child: Icon(
                                widget.icon,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Padding(
                          padding: EdgeInsets.only(
                            left: widget.icon == null ? AppSpacing.lg : 0,
                            right: AppSpacing.lg,
                          ),
                          child: Text(
                            widget.label,
                            style: AppTextStyles.subtitle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
