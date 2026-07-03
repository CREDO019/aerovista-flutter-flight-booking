import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_destinations.dart';
import '../../models/destination_model.dart';
import '../../models/flight_results_args.dart';
import '../../shared/widgets/app_disclaimer.dart';
import '../../shared/widgets/elite_screen_background.dart';
import '../../shared/widgets/globe_route/globe_route_animation.dart';
import 'widgets/destination_page_indicator.dart';
import 'widgets/explore_header.dart';
import 'widgets/parallax_destination_card.dart';

/// Elite destination discovery screen.
///
/// Filter chips: Tümü / Türkiye / Yurtdışı / Popüler / Hafta Sonu
///
/// When "View Flights" is tapped on a card, navigates to Results and
/// passes the destination's [airportCode] as argument. Results will
/// pre-filter flights going to that airport.
class DestinationExploreScreen extends StatefulWidget {
  const DestinationExploreScreen({super.key});

  @override
  State<DestinationExploreScreen> createState() =>
      _DestinationExploreScreenState();
}

class _DestinationExploreScreenState extends State<DestinationExploreScreen> {
  late final PageController _pageController;
  double _page = 0;
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.84)
      ..addListener(_handlePageChanged);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageChanged)
      ..dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    final next = _pageController.page ?? _pageController.initialPage.toDouble();
    if ((next - _page).abs() < 0.001) return;
    setState(() => _page = next);
  }

  // ── Filter-driven destination list ────────────────────────────────────────
  List<DestinationModel> get _visible {
    switch (_filterIndex) {
      case 1: // Türkiye
        return MockDestinations.domestic;
      case 2: // Yurtdışı
        return MockDestinations.international;
      case 3: // Popüler — first 4 intl
        return MockDestinations.international.take(4).toList();
      case 4: // Hafta Sonu
        return MockDestinations.all
            .where(
              (d) =>
                  d.airportCode == 'ADB' ||
                  d.airportCode == 'AYT' ||
                  d.airportCode == 'ASR' ||
                  d.airportCode == 'CDG',
            )
            .toList();
      default: // Tümü
        return MockDestinations.all;
    }
  }

  void _changeFilter(int index) {
    setState(() {
      _filterIndex = index;
      _page = 0;
    });
    // Jump page controller to first without animation to avoid crash
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _returnHome() => Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.home,
    (route) => false,
  );

  void _viewFlights(DestinationModel destination) => Navigator.pushNamed(
    context,
    AppRoutes.results,
    arguments: FlightResultsArgs.fromDestination(destination),
  );

  @override
  Widget build(BuildContext context) {
    final destinations = _visible;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final compact = screenHeight < 700;
    final globeHeight = screenHeight < 700
        ? 260.0
        : screenHeight < 820
        ? 284.0
        : 316.0;
    final destinationCardHeight = screenHeight < 700
        ? 360.0
        : screenHeight < 820
        ? 372.0
        : 430.0;
    final selectedIndex = destinations.isEmpty
        ? 0
        : _page.round().clamp(0, destinations.length - 1);
    final selectedDestination = destinations.isEmpty
        ? null
        : destinations[selectedIndex];

    return Scaffold(
      body: Stack(
        children: [
          const EliteScreenBackground(
            redGlowFraction: 0.28,
            redGlowAlpha: 0.16,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ─────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      compact ? AppSpacing.md : AppSpacing.lg,
                      AppSpacing.lg,
                      0,
                    ),
                    child: ExploreHeader(onBack: _returnHome),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // ── Filter chips ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: _ExploreFilterBar(
                      activeIndex: _filterIndex,
                      onChanged: _changeFilter,
                    ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // ── Signature globe route hero ─────────────────────────
                  if (selectedDestination != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child:
                          GlobeRouteAnimation(
                                key: ValueKey(
                                  'explore-globe-${selectedDestination.airportCode}',
                                ),
                                fromCode: 'IST',
                                toCode: selectedDestination.airportCode,
                                fromCity: 'İstanbul',
                                toCity: selectedDestination.city,
                                fromAirportName: 'İstanbul Havalimanı',
                                toAirportName: selectedDestination.airportName,
                                isDomestic: selectedDestination.isDomestic,
                                height: globeHeight,
                                size: compact
                                    ? GlobeRouteSize.medium
                                    : GlobeRouteSize.large,
                              )
                              .animate(delay: 260.ms)
                              .fadeIn(duration: 520.ms, curve: Curves.easeOut)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                duration: 520.ms,
                                curve: Curves.easeOutCubic,
                              ),
                    ),

                  SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),

                  // ── Page view ───────────────────────────────────────────
                  SizedBox(
                    height: destinationCardHeight,
                    child: destinations.isEmpty
                        ? const Center(
                            child: Text(
                              'Destinasyon bulunamadı.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: destinations.length,
                            itemBuilder: (context, index) {
                              final dest = destinations[index];
                              final offset = (_page - index)
                                  .clamp(-1.0, 1.0)
                                  .toDouble();
                              final distance = offset.abs();
                              final scale = 1.0 - distance * 0.075;
                              final opacity = 1.0 - distance * 0.22;
                              final verticalOffset = distance * 18;

                              Widget card = Transform.translate(
                                offset: Offset(0, verticalOffset),
                                child: Transform.scale(
                                  scale: scale,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: ParallaxDestinationCard(
                                      destination: dest,
                                      pageOffset: offset,
                                      onViewFlights: () => _viewFlights(dest),
                                    ),
                                  ),
                                ),
                              );

                              if (index == 0) {
                                card = card
                                    .animate(delay: 310.ms)
                                    .fadeIn(duration: 620.ms)
                                    .slideY(
                                      begin: 0.10,
                                      end: 0,
                                      duration: 620.ms,
                                      curve: Curves.easeOutCubic,
                                    );
                              }

                              return card;
                            },
                          ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // ── Page indicator ─────────────────────────────────────
                  DestinationPageIndicator(
                        count: destinations.length,
                        page: _page,
                      )
                      .animate(delay: 520.ms)
                      .fadeIn(duration: 420.ms)
                      .slideY(begin: 0.16, end: 0, duration: 420.ms),

                  const SizedBox(height: AppSpacing.md),

                  // ── Disclaimer ─────────────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: AppDisclaimer(),
                  ).animate(delay: 620.ms).fadeIn(duration: 420.ms),

                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Explore filter bar
// ─────────────────────────────────────────────────────────────────────────────

class _ExploreFilterBar extends StatelessWidget {
  const _ExploreFilterBar({required this.activeIndex, required this.onChanged});

  final int activeIndex;
  final ValueChanged<int> onChanged;

  static const _labels = [
    AppStrings.filterAll,
    AppStrings.filterDomestic,
    AppStrings.filterInternational,
    AppStrings.filterPopular,
    AppStrings.filterWeekend,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_labels.length, (i) {
          final isActive = i == activeIndex;
          return Padding(
            padding: EdgeInsets.only(right: i < _labels.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.airlineRed
                      : Colors.white.withValues(alpha: 0.07),
                  borderRadius: AppRadius.pillRadius,
                  border: Border.all(
                    color: isActive ? AppColors.softRed : AppColors.borderSoft,
                  ),
                  boxShadow: isActive
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
                  _labels[i],
                  style: AppTextStyles.caption.copyWith(
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
