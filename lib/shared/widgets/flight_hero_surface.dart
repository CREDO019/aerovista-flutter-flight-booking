import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/flight_model.dart';
import 'premium_plane_marker.dart';

/// Lightweight Hero shuttle used between result cards and the boarding pass.
class FlightHeroSurface extends StatelessWidget {
  const FlightHeroSurface({super.key, required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: AppShadows.softCardShadow,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.xlRadius,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.softRed, AppColors.airlineRed],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: _HeroContent(flight: flight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${flight.flightNumber}  ·  ${flight.cabin}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.softRed,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _RouteCode(
                code: flight.fromCode,
                city: flight.fromCity,
                airportName: flight.fromAirportName,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.borderSoft)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: PremiumPlaneMarker(
                        size: 17,
                        variant: PlaneMarkerVariant.minimal,
                        glow: false,
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.borderSoft)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _RouteCode(
                code: flight.toCode,
                city: flight.toCity,
                airportName: flight.toAirportName,
                alignRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteCode extends StatelessWidget {
  const _RouteCode({
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
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: AppTextStyles.display.copyWith(
            fontSize: 24,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption,
        ),
        SizedBox(
          width: 86,
          child: Text(
            airportName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignRight ? TextAlign.end : TextAlign.start,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.62),
              fontSize: 8,
            ),
          ),
        ),
      ],
    );
  }
}
