import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/flight_model.dart';
import 'boarding_info_tile.dart';
import 'boarding_route_line.dart';
import 'perforated_divider.dart';
import 'qr_placeholder.dart';

/// The premium digital boarding pass card.
///
/// This is the Hero target widget — its tag must match the source in
/// [FlightResultCard]: `'flight-card-${flight.id}'`.
///
/// Structure:
///   ┌─────────────────────────────┐
///   │ AeroVista branding strip    │  ← red gradient top bar
///   │ Flight number + cabin       │
///   │─────────────────────────────│
///   │ IST  ───✈───  CDG           │  ← BoardingRouteLine
///   │ Istanbul      Paris          │
///   │─────────────────────────────│
///   │ Departure │ Arrival │ Dur.  │
///   │ Gate      │ Seat    │ Pass. │
///   ├ ● ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ● ─┤  ← PerforatedDivider
///   │        [QR Code]            │
///   │   AV-{id}  ·  Concept      │
///   └─────────────────────────────┘
///
/// After the Hero animation resolves, inner content animates in with
/// staggered [flutter_animate] fade + slideY effects.
class PremiumBoardingPassCard extends StatelessWidget {
  const PremiumBoardingPassCard({super.key, required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final compact = screenSize.height < 740 || screenSize.width < 390;
    final edgePadding = compact ? AppSpacing.md : AppSpacing.lg;
    final routeGap = compact ? AppSpacing.md : AppSpacing.xl;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.10),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xlRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Branded top strip ────────────────────────────────────
            _BrandingStrip(
              flight: flight,
              compact: compact,
            ).animate(delay: 350.ms).fadeIn(duration: 400.ms),

            // ── Main content padding ─────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                edgePadding,
                edgePadding,
                edgePadding,
                0,
              ),
              child: Column(
                children: [
                  // ── Route line ─────────────────────────────────────
                  BoardingRouteLine(
                        fromCode: flight.fromCode,
                        fromCity: flight.fromCity,
                        fromAirportName: flight.fromAirportName,
                        toCode: flight.toCode,
                        toCity: flight.toCity,
                        toAirportName: flight.toAirportName,
                        duration: flight.duration,
                        isDomestic: flight.isDomestic,
                      )
                      .animate(delay: 420.ms)
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: 0.08, end: 0, duration: 450.ms),

                  SizedBox(height: routeGap),

                  // ── Details grid ────────────────────────────────────
                  _DetailsGrid(flight: flight, compact: compact)
                      .animate(delay: 520.ms)
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: 0.06, end: 0, duration: 450.ms),

                  SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
                ],
              ),
            ),

            // ── Perforated divider ───────────────────────────────────
            const PerforatedDivider()
                .animate(delay: 600.ms)
                .fadeIn(duration: 350.ms),

            // ── QR section ───────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(edgePadding),
              child: _QrSection(flight: flight, compact: compact)
                  .animate(delay: 680.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.06, end: 0, duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Red gradient branding strip at the top of the card.
class _BrandingStrip extends StatelessWidget {
  const _BrandingStrip({required this.flight, required this.compact});
  final FlightModel flight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.md : AppSpacing.lg,
        vertical: compact ? 7 : AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.airlineRed, AppColors.deepRed],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AEROVISTA',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Konsept Biniş Kartı',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 9,
                ),
              ),
            ],
          ),
          // Flight number + cabin
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                flight.flightNumber,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                flight.cabin,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 9,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 2-column, 3-row grid of flight detail tiles.
class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.flight, required this.compact});
  final FlightModel flight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final verticalGap = compact ? AppSpacing.sm : AppSpacing.md;
    final columnGap = compact ? AppSpacing.md : AppSpacing.lg;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column A
        Expanded(
          child: Column(
            children: [
              BoardingInfoTile(
                label: AppStrings.departure,
                value: flight.departureTime,
                icon: Icons.flight_takeoff_rounded,
              ),
              SizedBox(height: verticalGap),
              BoardingInfoTile(
                label: AppStrings.gate,
                value: flight.gate,
                icon: Icons.door_front_door_outlined,
              ),
              SizedBox(height: verticalGap),
              const BoardingInfoTile(
                label: AppStrings.passenger,
                value: 'Emirhan Özkaya',
                icon: Icons.person_outline_rounded,
              ),
              SizedBox(height: verticalGap),
              BoardingInfoTile(
                label: AppStrings.cabin,
                value: flight.cabin,
                icon: Icons.airline_seat_flat_outlined,
              ),
            ],
          ),
        ),

        SizedBox(width: columnGap),

        // Column B
        Expanded(
          child: Column(
            children: [
              BoardingInfoTile(
                label: AppStrings.arrival,
                value: flight.arrivalTime,
                icon: Icons.flight_land_rounded,
              ),
              SizedBox(height: verticalGap),
              BoardingInfoTile(
                label: AppStrings.seat,
                value: flight.seat,
                icon: Icons.airline_seat_recline_normal_rounded,
              ),
              SizedBox(height: verticalGap),
              BoardingInfoTile(
                label: AppStrings.baggage,
                value: flight.baggage,
                icon: Icons.luggage_rounded,
              ),
              SizedBox(height: verticalGap),
              BoardingInfoTile(
                label: 'Aktarma',
                value: flight.stops == 0 ? 'Direkt' : '${flight.stops} Aktarma',
                icon: Icons.airline_stops_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// QR section below the perforated divider.
class _QrSection extends StatelessWidget {
  const _QrSection({required this.flight, required this.compact});
  final FlightModel flight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final codeText = 'AV-${flight.id.toUpperCase()}';
    final qrSize = compact ? 70.0 : 92.0;
    final sideGap = compact ? AppSpacing.md : AppSpacing.lg;

    return Column(
      children: [
        // QR + side info
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // QR placeholder
            QrPlaceholder(size: qrSize),

            SizedBox(width: sideGap),

            // Side labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    codeText,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.airlineRed,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'BİNİŞ KARTI',
                    style: AppTextStyles.caption.copyWith(
                      letterSpacing: 2.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.airlineRed.withValues(alpha: 0.10),
                      borderRadius: AppRadius.smRadius,
                      border: Border.all(
                        color: AppColors.airlineRed.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      'KONSEPT\nGEÇERSİZ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.softRed,
                        fontSize: 9,
                        letterSpacing: 1,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Disclaimer
        Text(
          AppStrings.conceptBoardingPass,
          style: AppTextStyles.caption.copyWith(
            fontStyle: FontStyle.italic,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
