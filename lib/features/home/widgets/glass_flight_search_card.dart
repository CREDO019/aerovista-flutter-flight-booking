import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'airport_code_chip.dart';
import 'route_preview_card.dart';

/// The main flight search glassmorphism card.
///
/// Displays a FROM / TO route selector, trip detail chips (date, passengers,
/// cabin), and the animated route preview strip at the bottom.
///
/// All values are static mock data for this UI concept.
class GlassFlightSearchCard extends StatelessWidget {
  const GlassFlightSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Semi-transparent glass surface
        color: AppColors.glassWhite,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Route + trip details ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                const _RouteRow(),
                const SizedBox(height: AppSpacing.lg),
                const _TripDetailsRow(),
              ],
            ),
          ),

          // ── Separator ─────────────────────────────────────────────────
          const Divider(height: 1, color: AppColors.borderSoft),

          // ── Animated route preview ─────────────────────────────────────
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: RoutePreviewCard(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (private to this file)
// ─────────────────────────────────────────────────────────────────────────────

/// FROM → swap icon ← TO row.
class _RouteRow extends StatelessWidget {
  const _RouteRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── From ──────────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEREDEN',
                style: AppTextStyles.caption.copyWith(letterSpacing: 1.6),
              ),
              const SizedBox(height: AppSpacing.xs),
              const AirportCodeChip(code: 'IST', city: 'İstanbul'),
            ],
          ),
        ),

        // ── Swap icon ─────────────────────────────────────────────────
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.airlineRed.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.airlineRed.withValues(alpha: 0.32),
            ),
          ),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.airlineRed,
            size: 20,
          ),
        ),

        // ── To ────────────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'NEREYE',
                style: AppTextStyles.caption.copyWith(letterSpacing: 1.6),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.xs),
              const AirportCodeChip(
                code: 'CDG',
                city: 'Paris',
                alignRight: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Horizontal row of three detail chips: Date / Passengers / Cabin.
class _TripDetailsRow extends StatelessWidget {
  const _TripDetailsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DetailChip(
          icon: Icons.calendar_today_rounded,
          label: 'Tarih',
          value: '18 Temmuz',
        ),
        const SizedBox(width: AppSpacing.sm),
        _DetailChip(
          icon: Icons.person_outline_rounded,
          label: 'Yolcu',
          value: '1 Yetişkin',
        ),
        const SizedBox(width: AppSpacing.sm),
        _DetailChip(
          icon: Icons.airline_seat_recline_normal_rounded,
          label: 'Kabin',
          value: 'Ekonomi',
        ),
      ],
    );
  }
}

/// A single trip-detail chip (icon + label + value).
class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.airlineRed),
            const SizedBox(height: 3),
            Text(label, style: AppTextStyles.caption),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
