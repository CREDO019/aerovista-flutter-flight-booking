import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/destination_model.dart';
import 'destination_chip.dart';
import 'destination_gradient_painter.dart';
import 'destination_route_preview.dart';
import 'destination_visual.dart';

/// Large parallax destination card used inside the horizontal PageView.
class ParallaxDestinationCard extends StatelessWidget {
  const ParallaxDestinationCard({
    super.key,
    required this.destination,
    required this.pageOffset,
    required this.onViewFlights,
  });

  final DestinationModel destination;
  final double pageOffset;
  final VoidCallback onViewFlights;

  static const List<String> _chips = [
    'Popüler',
    'Direkt Uçuş',
    'Hafta Sonu',
    'Premium Seçim',
  ];

  @override
  Widget build(BuildContext context) {
    final distance = pageOffset.abs().clamp(0.0, 1.0).toDouble();
    final active = 1.0 - distance;
    final textShift = pageOffset * -18;
    final textOpacity = 0.72 + active * 0.28;
    final visual = DestinationVisual.forModel(destination);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.xlRadius,
            boxShadow: [
              ...AppShadows.softCardShadow,
              BoxShadow(
                color: AppColors.airlineRed.withValues(
                  alpha: 0.08 + active * 0.08,
                ),
                blurRadius: 34,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.xlRadius,
            child: Stack(
              children: [
                Positioned.fill(
                  child: visual.assetAvailable
                      ? _DestinationPhoto(
                          visual: visual,
                          pageOffset: pageOffset,
                          cityName: destination.city,
                        )
                      : CustomPaint(
                          painter: DestinationGradientPainter(
                            city: destination.city,
                            pageOffset: pageOffset,
                          ),
                        ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.76, -0.70),
                        radius: 0.95,
                        colors: [
                          visual.accent.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.18),
                          Colors.black.withValues(alpha: 0.56),
                        ],
                        stops: const [0.0, 0.46, 1.0],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.10 + active * 0.08,
                        ),
                      ),
                      borderRadius: AppRadius.xlRadius,
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxHeight < 400;
                    final padding = compact ? 12.0 : AppSpacing.lg;
                    final titleSize = compact ? 30.0 : 42.0;
                    final badgeSize = compact ? 36.0 : 46.0;

                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CardTopRow(
                            airportCode: destination.airportCode,
                            airportName: destination.airportName,
                            isDomestic: destination.isDomestic,
                            badgeSize: badgeSize,
                          ),
                          SizedBox(
                            height: compact ? AppSpacing.sm : AppSpacing.lg,
                          ),
                          Transform.translate(
                            offset: Offset(textShift, 0),
                            child: Opacity(
                              opacity: textOpacity,
                              child: _DestinationTitleBlock(
                                destination: destination,
                                visual: visual,
                                titleSize: titleSize,
                                compact: compact,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: compact ? AppSpacing.xs : AppSpacing.md,
                          ),
                          Opacity(
                            opacity: 0.78 + active * 0.22,
                            child: Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                for (final chip in _chips)
                                  DestinationChip(label: chip),
                              ],
                            ),
                          ),
                          const Spacer(),
                          DestinationRoutePreview(
                            airportCode: destination.airportCode,
                            compact: compact,
                          ),
                          SizedBox(
                            height: compact ? AppSpacing.xs : AppSpacing.sm,
                          ),
                          _CardBottomRow(
                            destination: destination,
                            compact: compact,
                            onViewFlights: onViewFlights,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardTopRow extends StatelessWidget {
  const _CardTopRow({
    required this.airportCode,
    required this.airportName,
    required this.isDomestic,
    required this.badgeSize,
  });

  final String airportCode;
  final String airportName;
  final bool isDomestic;
  final double badgeSize;

  @override
  Widget build(BuildContext context) {
    final compact = badgeSize <= 36;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Origin + domestic badge ────────────────────────────────────
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: compact ? 138 : 172),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: AppRadius.pillRadius,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.flight_takeoff_rounded,
                      size: 14,
                      color: AppColors.softRed,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        'İstanbul çıkışlı',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      (isDomestic
                              ? const Color(0xFF2A9D8F)
                              : const Color(0xFF2A6FBA))
                          .withValues(alpha: 0.20),
                  borderRadius: AppRadius.pillRadius,
                  border: Border.all(
                    color:
                        (isDomestic
                                ? const Color(0xFF2A9D8F)
                                : const Color(0xFF2A6FBA))
                            .withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  isDomestic ? 'Yurtiçi' : 'Yurtdışı',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // ── Airport code badge + name ──────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: AppRadius.mdRadius,
                border: Border.all(
                  color: AppColors.softRed.withValues(alpha: 0.42),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                airportCode,
                style: AppTextStyles.subtitle.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: compact ? 96 : 110,
              child: Text(
                airportName,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 8,
                  letterSpacing: 0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DestinationPhoto extends StatelessWidget {
  const _DestinationPhoto({
    required this.visual,
    required this.pageOffset,
    required this.cityName,
  });

  final DestinationVisual visual;
  final double pageOffset;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(pageOffset * -28, 0),
      child: Transform.scale(
        scale: 1.08,
        child: Image.asset(
          visual.assetPath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return CustomPaint(
              painter: DestinationGradientPainter(
                city: cityName,
                pageOffset: pageOffset,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DestinationTitleBlock extends StatelessWidget {
  const _DestinationTitleBlock({
    required this.destination,
    required this.visual,
    required this.titleSize,
    required this.compact,
  });

  final DestinationModel destination;
  final DestinationVisual visual;
  final double titleSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          destination.city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.display.copyWith(
            color: Colors.white,
            fontSize: titleSize,
            height: 1.0,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          destination.country,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.subtitle.copyWith(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: compact ? 13 : 15,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
        Text(
          visual.moodLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: visual.accent.withValues(alpha: 0.92),
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
        Text(
          destination.subtitle,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.35,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _CardBottomRow extends StatelessWidget {
  const _CardBottomRow({
    required this.destination,
    required this.compact,
    required this.onViewFlights,
  });

  final DestinationModel destination;
  final bool compact;
  final VoidCallback onViewFlights;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Başlangıç',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.56),
                  letterSpacing: 0,
                ),
              ),
              Text(
                '\$${destination.startingPrice}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.display.copyWith(
                  color: Colors.white,
                  fontSize: compact ? 23 : 27,
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ViewFlightsButton(
          destinationId: destination.id,
          compact: compact,
          onPressed: onViewFlights,
        ),
      ],
    );
  }
}

class _ViewFlightsButton extends StatelessWidget {
  const _ViewFlightsButton({
    required this.destinationId,
    required this.compact,
    required this.onPressed,
  });

  final String destinationId;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.pillRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.softRed, AppColors.airlineRed],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.36),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: compact ? 38 : 42,
        child: TextButton.icon(
          key: ValueKey('view-flights-$destinationId'),
          onPressed: onPressed,
          icon: const Icon(Icons.search_rounded, size: 16, color: Colors.white),
          label: Text(
            AppStrings.viewFlights,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }
}
