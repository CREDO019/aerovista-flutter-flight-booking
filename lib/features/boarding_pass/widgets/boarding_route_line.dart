import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// Animated horizontal route line for the boarding pass card.
///
/// Displays:
///   LEFT   — origin IATA code + city + airport name
///   CENTER — flight arc line + PremiumPlaneMarker + duration
///   RIGHT  — destination IATA code + city + airport name
///   FOOTER — domestic / international badge
class BoardingRouteLine extends StatelessWidget {
  const BoardingRouteLine({
    super.key,
    required this.fromCode,
    required this.fromCity,
    required this.fromAirportName,
    required this.toCode,
    required this.toCity,
    required this.toAirportName,
    required this.duration,
    this.isDomestic = false,
  });

  final String fromCode;
  final String fromCity;
  final String fromAirportName;
  final String toCode;
  final String toCity;
  final String toAirportName;
  final String duration;
  final bool isDomestic;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Route row ────────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Origin ────────────────────────────────────────────────────
            _RouteStop(
              code: fromCode,
              city: fromCity,
              airportName: fromAirportName,
            ),

            // ── Centre arc ────────────────────────────────────────────────
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    duration,
                    style: AppTextStyles.caption.copyWith(letterSpacing: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.borderSoft.withValues(alpha: 0.3),
                                AppColors.airlineRed.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        child: const PremiumPlaneMarker(
                          size: 20,
                          variant: PlaneMarkerVariant.route,
                          glow: false,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.airlineRed.withValues(alpha: 0.8),
                                AppColors.borderSoft.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Destination ───────────────────────────────────────────────
            _RouteStop(
              code: toCode,
              city: toCity,
              airportName: toAirportName,
              alignRight: true,
            ),
          ],
        ),

        // ── Domestic / International badge ────────────────────────────────
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  (isDomestic
                          ? const Color(0xFF2A9D8F)
                          : const Color(0xFF2A6FBA))
                      .withValues(alpha: 0.12),
              borderRadius: AppRadius.pillRadius,
              border: Border.all(
                color:
                    (isDomestic
                            ? const Color(0xFF2A9D8F)
                            : const Color(0xFF2A6FBA))
                        .withValues(alpha: 0.28),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDomestic ? Icons.flag_rounded : Icons.public_rounded,
                  size: 11,
                  color: isDomestic
                      ? const Color(0xFF2A9D8F)
                      : const Color(0xFF2A6FBA),
                ),
                const SizedBox(width: 5),
                Text(
                  isDomestic ? 'Yurtiçi Uçuş' : 'Yurtdışı Uçuş',
                  style: AppTextStyles.caption.copyWith(
                    color: isDomestic
                        ? const Color(0xFF2A9D8F)
                        : const Color(0xFF2A6FBA),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteStop extends StatelessWidget {
  const _RouteStop({
    required this.code,
    required this.city,
    required this.airportName,
    this.alignRight = false,
  });

  final String code;
  final String city;
  final String airportName;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final cross = alignRight
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: cross,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          code,
          style: AppTextStyles.display.copyWith(fontSize: 34, letterSpacing: 1),
        ),
        Text(
          city,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(
          width: 100,
          child: Text(
            airportName,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.58),
              fontSize: 8.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignRight ? TextAlign.end : TextAlign.start,
          ),
        ),
      ],
    );
  }
}
