import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock_flights.dart';
import '../../models/flight_model.dart';
import '../../shared/widgets/elite_screen_background.dart';
import '../../shared/widgets/globe_route/globe_route_animation.dart';
import 'widgets/confirmation_action_row.dart';
import 'widgets/confirmation_card.dart';

/// Premium Booking Confirmation Screen — Step 5 (Step 6 Performance Redesign).
///
/// Layout:
///   Stack → [EliteScreenBackground] (ambient) + [SingleChildScrollView] (content)
///
/// Animation sequencing:
///   - 0 ms: Static background visible
///   - 150 ms: Globe fades + slides in
///   - 300-1900 ms: Plane route animation runs smoothly (Cached Static Map via RepaintBoundary)
///   - 1720 ms: Checkmark success badge zooms in beautifully over arrival node
///   - 1900 ms: Integrated Confirmation Card fades + slides in
///   - 2150 ms: Bottom actions fade in
class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Resolve FlightModel ─────────────────────────────────────────────
    final flight =
        ModalRoute.of(context)?.settings.arguments as FlightModel? ??
        MockFlights.all.first;
    final compact =
        MediaQuery.sizeOf(context).height < 740 ||
        MediaQuery.sizeOf(context).width < 390;

    final referenceCode = 'AV-${flight.id.toUpperCase()}';

    return Scaffold(
      body: Stack(
        children: [
          // ── Layer 1: Ambient Background ────────────────────────────
          const EliteScreenBackground(
            redGlowFraction: 0.50,
            redGlowAlpha: 0.17,
          ),

          // ── Layer 2: Content ───────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // ── Animated Success Route ──────────────────────────
                  // Uses playOnce=true, cached StaticGlobePainter internally
                  GlobeRouteAnimation(
                        fromCode: flight.fromCode,
                        toCode: flight.toCode,
                        fromCity: flight.fromCity,
                        toCity: flight.toCity,
                        fromAirportName: flight.fromAirportName,
                        toAirportName: flight.toAirportName,
                        isDomestic: flight.isDomestic,
                        height: compact ? 330 : 380,
                        size: compact
                            ? GlobeRouteSize.large
                            : GlobeRouteSize.hero,
                        playOnce: true,
                        showLabels: true,
                        reduceBorders: true,
                      )
                      .animate(delay: 150.ms)
                      .fadeIn(duration: 520.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.06,
                        end: 0,
                        duration: 520.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Confirmation Card (Integrated Receipt) ─────────
                  RepaintBoundary(
                    child:
                        ConfirmationCard(
                              flight: flight,
                              reference: referenceCode,
                            )
                            .animate(delay: 1900.ms)
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.05,
                              end: 0,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Action Buttons Row ──────────────────────────────
                  RepaintBoundary(child: ConfirmationActionRow(flight: flight)),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
