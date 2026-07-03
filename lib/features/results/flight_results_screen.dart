import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_flights.dart';
import '../../models/flight_model.dart';
import '../../models/flight_results_args.dart';
import '../../shared/widgets/elite_screen_background.dart';
import '../../shared/widgets/premium_plane_marker.dart';
import 'widgets/elite_results_filter_bar.dart';
import 'widgets/flight_result_card.dart';
import 'widgets/results_header.dart';

/// Elite Flight Results Screen.
///
/// Accepts an optional [String] route argument (destination airport code,
/// e.g. "CDG") passed from the Explore screen. When provided, the list is
/// pre-filtered to flights going to that destination.
///
/// Active filter chips live in local state. Tapping a chip sorts/filters
/// the current flight list with no backend.
class FlightResultsScreen extends StatefulWidget {
  const FlightResultsScreen({super.key});

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  // ── Filter chip index ─────────────────────────────────────────────────────
  // Corresponds to [EliteResultsFilterBar._labels]
  int _activeFilter = 0;

  FlightResultsArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_args != null) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is FlightResultsArgs) {
      _args = args;
    } else if (args is String) {
      _args = FlightResultsArgs(destinationCode: args);
    }
  }

  List<FlightModel> get _baseFlights {
    final destinationCode = _args?.destinationCode;
    if (destinationCode == null || destinationCode.isEmpty) {
      return MockFlights.all;
    }
    final matches = MockFlights.all
        .where((flight) => flight.toCode == destinationCode)
        .toList();
    return _stableSorted(matches, (a, b) {
      final aIstanbul = a.fromCode == 'IST' ? 0 : 1;
      final bIstanbul = b.fromCode == 'IST' ? 0 : 1;
      return aIstanbul.compareTo(bIstanbul);
    });
  }

  _VisibleFlightSet get _visibleFlightSet {
    final routeFlights = _baseFlights;
    final exactMatches = _applyFilter(routeFlights);
    final hasRouteScope = _args?.destinationCode != null;
    final canSuggest = hasRouteScope && exactMatches.isEmpty;

    if (canSuggest) {
      final suggestions = _applyFilter(MockFlights.all);
      if (suggestions.isNotEmpty) {
        return _VisibleFlightSet(
          flights: suggestions,
          countLabel: suggestions.length == 1
              ? '1 alternatif öneri'
              : '${suggestions.length} alternatif öneri',
          note: _suggestionNotice,
          isSuggestion: true,
        );
      }
    }

    return _VisibleFlightSet(
      flights: exactMatches,
      countLabel: _countLabelFor(exactMatches.length),
    );
  }

  List<FlightModel> _applyFilter(List<FlightModel> base) {
    switch (_activeFilter) {
      case 0: // Önerilen — original order
        if (!base.any((flight) => flight.recommendedScore > 0)) return base;
        return _stableSorted(
          base,
          (a, b) => b.recommendedScore.compareTo(a.recommendedScore),
        );
      case 1: // En Uygun — price asc
        return _stableSorted(base, (a, b) => a.price.compareTo(b.price));
      case 2: // En Hızlı — duration asc
        return _stableSorted(
          base,
          (a, b) => a.durationMinutes.compareTo(b.durationMinutes),
        );
      case 3: // Sabah
        return base.where((f) => f.departurePeriod == 'sabah').toList();
      case 4: // Akşam
        return base.where((f) => f.departurePeriod == 'akşam').toList();
      case 5: // Yurtiçi
        return base.where((f) => f.isDomestic).toList();
      case 6: // Yurtdışı
        return base.where((f) => !f.isDomestic).toList();
      case 7: // Direkt
        return base.where((f) => f.stops == 0).toList();
      default:
        return base;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleSet = _visibleFlightSet;
    final flights = visibleSet.flights;
    final headerFlight = _baseFlights.isNotEmpty
        ? _baseFlights.first
        : MockFlights.all.first;

    return Scaffold(
      body: Stack(
        children: [
          // ── Ambient background ───────────────────────────────────────
          const EliteScreenBackground(
            redGlowFraction: 0.78,
            redGlowAlpha: 0.14,
          ),

          // ── Scrollable content ───────────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Header ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    child: RepaintBoundary(
                      child: ResultsHeader(
                        flight: headerFlight,
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),

                // ── Filter chips ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                      0,
                    ),
                    child:
                        EliteResultsFilterBar(
                              activeIndex: _activeFilter,
                              onChanged: (i) =>
                                  setState(() => _activeFilter = i),
                            )
                            .animate(delay: 600.ms)
                            .fadeIn(duration: 360.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              duration: 360.ms,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
                ),

                // ── Result count label ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.xs,
                    ),
                    child:
                        _ResultCountStrip(
                              key: ValueKey(
                                '${_activeFilter}_${visibleSet.countLabel}_${visibleSet.isSuggestion}',
                              ),
                              text: visibleSet.countLabel,
                              filterLabel: _filterLabel,
                              isSuggestion: visibleSet.isSuggestion,
                            )
                            .animate(delay: 720.ms)
                            .fadeIn(duration: 280.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              duration: 280.ms,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
                ),

                // ── Flight list or empty state ──────────────────────────
                if (visibleSet.note != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: _SuggestionNotice(text: visibleSet.note!),
                    ),
                  ),

                if (visibleSet.note == null && flights.length == 1)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.sm,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: _SingleResultNotice(activeFilter: _activeFilter),
                    ),
                  ),

                if (flights.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState()
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 450.ms),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xs,
                      AppSpacing.md,
                      AppSpacing.xxl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: RepaintBoundary(
                        child: Column(
                          children: [
                            for (var index = 0; index < flights.length; index++)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == flights.length - 1
                                      ? 0
                                      : AppSpacing.md,
                                ),
                                child: _AnimatedFlightCard(
                                  key: ValueKey(
                                    'result-card-${_activeFilter}_${visibleSet.isSuggestion}_${flights[index].id}',
                                  ),
                                  flight: flights[index],
                                  delay: Duration(
                                    milliseconds:
                                        820 + (index > 3 ? 3 : index) * 100,
                                  ),
                                  isRecommended:
                                      index == 0 &&
                                      (_activeFilter == 0 ||
                                          visibleSet.isSuggestion),
                                  isProminent: flights.length == 1,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.boardingPass,
                                    arguments: flights[index],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _filterLabel {
    const labels = [
      'Önerilen sıralama',
      'Fiyata göre sıralı',
      'Süreye göre sıralı',
      'Sabah kalkışları',
      'Akşam kalkışları',
      'Yurtiçi uçuşlar',
      'Yurtdışı uçuşlar',
      'Direkt uçuşlar',
    ];
    return _activeFilter < labels.length ? labels[_activeFilter] : '';
  }

  String get _suggestionNotice {
    switch (_activeFilter) {
      case 5:
        return 'Bu rota için sonuç yok, yurtiçi alternatif öneriler gösteriliyor.';
      case 6:
        return 'Bu rota için sonuç yok, yurtdışı alternatif öneriler gösteriliyor.';
      default:
        return 'Bu rota için sonuç yok, alternatif öneriler gösteriliyor.';
    }
  }

  String _countLabelFor(int count) {
    if (count == 0) return 'Bu filtre için uygun öneri aranıyor';
    if (count == 1) {
      return _activeFilter == 0 ? '1 önerilen uçuş' : '1 uçuş bulundu';
    }
    if (_activeFilter == 5) return '$count yurtiçi öneri gösteriliyor';
    if (_activeFilter == 6) return '$count yurtdışı öneri gösteriliyor';
    return AppStrings.flightCount(count);
  }

  List<FlightModel> _stableSorted(
    List<FlightModel> flights,
    int Function(FlightModel a, FlightModel b) compare,
  ) {
    final indexed = flights.indexed.toList();
    indexed.sort((a, b) {
      final result = compare(a.$2, b.$2);
      return result == 0 ? a.$1.compareTo(b.$1) : result;
    });
    return indexed.map((item) => item.$2).toList();
  }
}

class _AnimatedFlightCard extends StatelessWidget {
  const _AnimatedFlightCard({
    super.key,
    required this.flight,
    required this.delay,
    required this.isRecommended,
    required this.isProminent,
    required this.onTap,
  });

  final FlightModel flight;
  final Duration delay;
  final bool isRecommended;
  final bool isProminent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlightResultCard(
          flight: flight,
          isRecommended: isRecommended,
          isProminent: isProminent,
          onTap: onTap,
        )
        .animate(delay: delay)
        .fadeIn(duration: 420.ms)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 420.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _ResultCountStrip extends StatelessWidget {
  const _ResultCountStrip({
    super.key,
    required this.text,
    required this.filterLabel,
    required this.isSuggestion,
  });

  final String text;
  final String filterLabel;
  final bool isSuggestion;

  @override
  Widget build(BuildContext context) {
    final accent = isSuggestion
        ? const Color(0xFF2A9D8F)
        : AppColors.airlineRed;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF08111E).withValues(alpha: 0.78),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(Icons.radar_rounded, size: 14, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '$text  ·  $filterLabel',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleResultNotice extends StatelessWidget {
  const _SingleResultNotice({required this.activeFilter});

  final int activeFilter;

  @override
  Widget build(BuildContext context) {
    final text = activeFilter == 0
        ? 'Bu rota için en uygun öneri'
        : 'Seçilen filtreye göre en iyi eşleşme';
    return _ConsoleNotice(
      icon: Icons.verified_rounded,
      text: text,
      accent: AppColors.airlineRed,
    );
  }
}

class _VisibleFlightSet {
  const _VisibleFlightSet({
    required this.flights,
    required this.countLabel,
    this.note,
    this.isSuggestion = false,
  });

  final List<FlightModel> flights;
  final String countLabel;
  final String? note;
  final bool isSuggestion;
}

class _SuggestionNotice extends StatelessWidget {
  const _SuggestionNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _ConsoleNotice(
          icon: Icons.travel_explore_rounded,
          text: text,
          accent: const Color(0xFF2A9D8F),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.08, end: 0, duration: 300.ms);
  }
}

class _ConsoleNotice extends StatelessWidget {
  const _ConsoleNotice({
    required this.icon,
    required this.text,
    required this.accent,
  });

  final IconData icon;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF09121F).withValues(alpha: 0.84),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: accent.withValues(alpha: 0.92)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.76),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state — shown when a filter produces zero results
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: AppRadius.xlRadius,
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PremiumPlaneMarker(
                size: 34,
                variant: PlaneMarkerVariant.hero,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.emptyStateTitle,
                style: AppTextStyles.title.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.emptyStateSubtitle,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
