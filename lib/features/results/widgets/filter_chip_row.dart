import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Horizontal row of filter option chips for the results screen.
///
/// Chips are purely visual for now — no actual filter logic.
/// The selected chip uses the airlineRed accent; unselected chips use the
/// glass surface style.
class FilterChipRow extends StatefulWidget {
  const FilterChipRow({super.key});

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  int _selected = 0;

  static const _labels = ['En İyi', 'En Uygun', 'En Hızlı', 'Sabah', 'Akşam'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isActive = _selected == index;
          return _FilterChip(
            label: _labels[index],
            isActive: isActive,
            onTap: () => setState(() => _selected = index),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.93,
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
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.airlineRed
                : AppColors.glassWhite,
            borderRadius: AppRadius.pillRadius,
            border: Border.all(
              color: widget.isActive
                  ? AppColors.airlineRed
                  : AppColors.borderSoft,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.airlineRed.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.caption.copyWith(
              color: widget.isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
