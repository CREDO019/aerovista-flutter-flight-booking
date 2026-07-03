import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/flight_model.dart';
import '../../boarding_pass/widgets/perforated_divider.dart';

/// The elite confirmation card redesigned as a Premium Global Arrival Receipt.
///
/// Features:
///   - Premium Glassmorphism background (BackdropFilter blur + gradient border)
///   - Elegant thin red indicator line
///   - Refined non-boxy detail grid with subtle vertical/horizontal dividing lines
///   - Integrated Booking Reference ticket-footer with perforated division
class ConfirmationCard extends StatelessWidget {
  const ConfirmationCard({
    super.key,
    required this.flight,
    required this.reference,
  });

  final FlightModel flight;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 36,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.08),
            blurRadius: 45,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xlRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.xlRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cardWhite.withValues(alpha: 0.85),
                  AppColors.cardWhite.withValues(alpha: 0.65),
                  AppColors.deepNavy.withValues(alpha: 0.60),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Top accent bar ───────────────────────────────────────
                Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.airlineRed, AppColors.deepRed],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── "Booking Confirmed" title ─────────────────────
                      Text(
                            AppStrings.confirmation,
                            style: AppTextStyles.display.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                          .animate(delay: 120.ms)
                          .fadeIn(duration: 450.ms)
                          .slideY(begin: 0.1, end: 0, duration: 450.ms),

                      const SizedBox(height: AppSpacing.sm),

                      // ── Subtitle ──────────────────────────────────────
                      Text(
                        AppStrings.journeyReady(flight.fromCity, flight.toCity),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ).animate(delay: 240.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: AppSpacing.xs),

                      // ── Airport names row ──────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              flight.fromAirportName,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.70,
                                ),
                                fontSize: 9.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '→',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.airlineRed.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              flight.toAirportName,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.70,
                                ),
                                fontSize: 9.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ).animate(delay: 290.ms).fadeIn(duration: 380.ms),

                      const SizedBox(height: AppSpacing.sm),

                      // ── Domestic / international badge ─────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (flight.isDomestic
                                      ? const Color(0xFF2A9D8F)
                                      : const Color(0xFF2A6FBA))
                                  .withValues(alpha: 0.12),
                          borderRadius: AppRadius.pillRadius,
                          border: Border.all(
                            color:
                                (flight.isDomestic
                                        ? const Color(0xFF2A9D8F)
                                        : const Color(0xFF2A6FBA))
                                    .withValues(alpha: 0.28),
                          ),
                        ),
                        child: Text(
                          flight.isDomestic
                              ? 'Yurtiçi Uçuş'
                              : 'Uluslararası Uçuş',
                          style: AppTextStyles.caption.copyWith(
                            color: flight.isDomestic
                                ? const Color(0xFF2A9D8F)
                                : const Color(0xFF2A6FBA),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ).animate(delay: 340.ms).fadeIn(duration: 350.ms),

                      const SizedBox(height: AppSpacing.lg),

                      // ── Divider ───────────────────────────────────────
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ).animate(delay: 320.ms).fadeIn(duration: 300.ms),

                      const SizedBox(height: AppSpacing.md),

                      // ── Refined non-boxy detail grid ───────────────────
                      _DetailGrid(flight: flight)
                          .animate(delay: 420.ms)
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.06, end: 0, duration: 500.ms),
                    ],
                  ),
                ),

                // ── Perforated division ──────────────────────────────
                const PerforatedDivider()
                    .animate(delay: 550.ms)
                    .fadeIn(duration: 300.ms),

                // ── Integrated Booking Reference footer ──────────────
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.bookingReference.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          letterSpacing: 2.2,
                          color: AppColors.textSecondary,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            reference,
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.airlineRed,
                              letterSpacing: 2.5,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.copy_rounded,
                            size: 15,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppStrings.conceptTicket,
                        style: AppTextStyles.caption.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.55,
                          ),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 2-column grid of key flight details with clean separators.
class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.flight});
  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.flight_rounded, 'UÇUŞ', flight.flightNumber),
      (Icons.airline_seat_recline_normal_rounded, 'KOLTUK', flight.seat),
      (Icons.flight_takeoff_rounded, 'KALKIŞ', flight.departureTime),
      (Icons.door_front_door_outlined, 'KAPI', flight.gate),
      (Icons.flight_land_rounded, 'VARIŞ', flight.arrivalTime),
      (Icons.luggage_rounded, 'BAGAJ', flight.baggage),
    ];

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (int row = 0; row < 3; row++) ...[
          TableRow(
            children: [
              _DetailTile(item: items[row * 2]),
              _DetailTile(item: items[row * 2 + 1], alignRight: true),
            ],
          ),
          if (row < 2)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ],
            ),
        ],
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.item, this.alignRight = false});
  final (IconData, String, String) item;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final (icon, label, value) = item;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.airlineRed.withValues(alpha: 0.85),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 8.5,
                letterSpacing: 1.1,
                color: AppColors.textSecondary.withValues(alpha: 0.70),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );

    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: content,
      ),
    );
  }
}
