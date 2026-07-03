import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock_flights.dart';
import '../../models/flight_model.dart';
import '../../shared/widgets/elite_screen_background.dart';
import '../../shared/widgets/flight_hero_surface.dart';
import '../../shared/widgets/globe_route/globe_route_animation.dart';
import '../../shared/widgets/premium_button.dart';
import 'widgets/boarding_pass_header.dart';
import 'widgets/premium_boarding_pass_card.dart';

/// Premium boarding pass screen — Step 4.
///
/// This is the centrepiece of the AeroVista concept.
///
/// Hero chain:
///   [FlightResultCard] → tag: "flight-card-${flight.id}"
///                      → [BoardingPassScreen] wraps the card with the same tag
///
/// The card expands from the result list item into a full boarding pass.
/// After the Hero animation settles, the card's inner sections stagger in
/// via [flutter_animate].
///
/// Data: reads the selected [FlightModel] from route arguments;
/// falls back to [MockFlights.all.first] if null (safe).
class BoardingPassScreen extends StatelessWidget {
  const BoardingPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Resolve FlightModel ─────────────────────────────────────────────
    final flight =
        ModalRoute.of(context)?.settings.arguments as FlightModel? ??
        MockFlights.all.first;
    final compact =
        MediaQuery.sizeOf(context).height < 740 ||
        MediaQuery.sizeOf(context).width < 390;

    return Scaffold(
      // No AppBar — custom header inside scroll view keeps it edge-to-edge.
      body: Stack(
        children: [
          // ── Layer 1: ambient background ────────────────────────────
          const EliteScreenBackground(
            redGlowFraction: 0.66,
            redGlowAlpha: 0.14,
          ),

          // ── Layer 2: content ───────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // ── Header ────────────────────────────────────────
                  BoardingPassHeader(onBack: () => Navigator.pop(context)),

                  SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),

                  GlobeRouteAnimation(
                        fromCode: flight.fromCode,
                        toCode: flight.toCode,
                        fromCity: flight.fromCity,
                        toCity: flight.toCity,
                        fromAirportName: flight.fromAirportName,
                        toAirportName: flight.toAirportName,
                        isDomestic: flight.isDomestic,
                        height: compact ? 176 : 208,
                        size: GlobeRouteSize.medium,
                      )
                      .animate(delay: 240.ms)
                      .fadeIn(duration: 480.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 480.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),

                  // ── Boarding pass card (Hero target) ──────────────
                  Hero(
                        tag: 'flight-card-${flight.id}',
                        flightShuttleBuilder: (_, animation, _, _, _) {
                          return FadeTransition(
                            opacity: animation,
                            child: FlightHeroSurface(flight: flight),
                          );
                        },
                        child: PremiumBoardingPassCard(flight: flight),
                      )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Confirm booking CTA ───────────────────────────
                  PremiumButton(
                        label: AppStrings.confirmBooking,
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.confirmation,
                          arguments: flight,
                        ),
                      )
                      .animate(delay: 750.ms)
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: 0.1, end: 0, duration: 450.ms),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
