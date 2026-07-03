import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Premium horizontal filter rail for the Results screen.
///
/// State stays lifted to [FlightResultsScreen]; this widget only renders and
/// animates the selected filter affordance.
class EliteResultsFilterBar extends StatelessWidget {
  const EliteResultsFilterBar({
    super.key,
    required this.activeIndex,
    required this.onChanged,
  });

  final int activeIndex;
  final ValueChanged<int> onChanged;

  static const _chips = [
    (Icons.stars_rounded, 'Önerilen'),
    (Icons.payments_rounded, 'En Uygun'),
    (Icons.bolt_rounded, 'En Hızlı'),
    (Icons.wb_sunny_outlined, 'Sabah'),
    (Icons.nights_stay_outlined, 'Akşam'),
    (Icons.flag_rounded, 'Yurtiçi'),
    (Icons.public_rounded, 'Yurtdışı'),
    (Icons.flight_takeoff_rounded, 'Direkt'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: AppSpacing.md),
        itemCount: _chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final (icon, label) = _chips[index];
          return _EliteFilterChip(
            icon: icon,
            label: label,
            isActive: activeIndex == index,
            onTap: () => onChanged(index),
          );
        },
      ),
    );
  }
}

class _EliteFilterChip extends StatefulWidget {
  const _EliteFilterChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_EliteFilterChip> createState() => _EliteFilterChipState();
}

class _EliteFilterChipState extends State<_EliteFilterChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 130),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: _controller.reverse,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 210),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: AppRadius.pillRadius,
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.airlineRed, AppColors.deepRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: active
                ? null
                : const Color(0xFF0A1422).withValues(alpha: 0.88),
            border: Border.all(
              color: active
                  ? AppColors.softRed.withValues(alpha: 0.48)
                  : Colors.white.withValues(alpha: 0.09),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.airlineRed.withValues(alpha: 0.24),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: active
                    ? Colors.white
                    : AppColors.textSecondary.withValues(alpha: 0.78),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTextStyles.caption.copyWith(
                  color: active
                      ? Colors.white
                      : AppColors.textSecondary.withValues(alpha: 0.86),
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
