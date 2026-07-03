import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/flight_model.dart';
import '../../../shared/widgets/globe_route/globe_route_animation.dart';

/// Premium route header for the Results screen.
///
/// Keeps the globe isolated from the rest of the scroll surface while making the
/// route, airports, and trip meta feel like a single flight-selection console.
class ResultsHeader extends StatelessWidget {
  const ResultsHeader({super.key, required this.onBack, required this.flight});

  final VoidCallback onBack;
  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final compact = screen.height < 700 || screen.width < 390;

    return LayoutBuilder(
      builder: (context, constraints) {
        final globeHeight = _globeHeightFor(screen, constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                  children: [
                    _GlassBackButton(onTap: onBack),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.resultsTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.82,
                              ),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${flight.fromCity} → ${flight.toCity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.title.copyWith(
                              fontSize: compact ? 25 : 29,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(duration: 260.ms)
                .slideY(
                  begin: -0.08,
                  end: 0,
                  duration: 260.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: AppSpacing.sm),

            _RouteIdentity(flight: flight)
                .animate(delay: 120.ms)
                .fadeIn(duration: 280.ms)
                .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: 280.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: AppSpacing.sm),

            _MetaStrip(flight: flight)
                .animate(delay: 450.ms)
                .fadeIn(duration: 300.ms)
                .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: 300.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: AppSpacing.md),

            _GlobeStage(flight: flight, height: globeHeight, compact: compact)
                .animate(delay: 250.ms)
                .fadeIn(duration: 420.ms)
                .scaleXY(
                  begin: 0.97,
                  end: 1,
                  duration: 420.ms,
                  curve: Curves.easeOutCubic,
                ),
          ],
        );
      },
    );
  }

  double _globeHeightFor(Size screen, double width) {
    final base = screen.height < 700
        ? 190.0
        : screen.height < 820
        ? 214.0
        : 238.0;
    return math.min(base, width * 0.62).clamp(184.0, 246.0);
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Geri',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0D1725).withValues(alpha: 0.86),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.airlineRed.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _RouteIdentity extends StatelessWidget {
  const _RouteIdentity({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RouteAirport(
          code: flight.fromCode,
          airportName: flight.fromAirportName,
          alignRight: false,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            7,
            AppSpacing.sm,
            0,
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 17,
            color: AppColors.airlineRed.withValues(alpha: 0.88),
          ),
        ),
        _RouteAirport(
          code: flight.toCode,
          airportName: flight.toAirportName,
          alignRight: true,
        ),
      ],
    );
  }
}

class _RouteAirport extends StatelessWidget {
  const _RouteAirport({
    required this.code,
    required this.airportName,
    required this.alignRight,
  });

  final String code;
  final String airportName;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            airportName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignRight ? TextAlign.end : TextAlign.start,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.66),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaStrip extends StatelessWidget {
  const _MetaStrip({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF09121F).withValues(alpha: 0.82),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.borderSoft.withValues(alpha: 0.82)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 12,
            color: AppColors.airlineRed.withValues(alpha: 0.86),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '18 Temmuz • 1 Yetişkin • ${flight.cabin}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.74),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobeStage extends StatelessWidget {
  const _GlobeStage({
    required this.flight,
    required this.height,
    required this.compact,
  });

  final FlightModel flight;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgRadius,
        color: const Color(0xFF07101C).withValues(alpha: 0.72),
        border: Border.all(color: Colors.white.withValues(alpha: 0.075)),
        boxShadow: [
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(0xFF2A6FBA).withValues(alpha: 0.08),
            blurRadius: 34,
            offset: const Offset(-8, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lgRadius,
        child: Stack(
          children: [
            const Positioned.fill(child: _RadarStagePainterHost()),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: compact ? 0 : 2),
                child: GlobeRouteAnimation(
                  key: ValueKey('results-globe-${flight.id}'),
                  fromCode: flight.fromCode,
                  toCode: flight.toCode,
                  fromCity: flight.fromCity,
                  toCity: flight.toCity,
                  fromAirportName: flight.fromAirportName,
                  toAirportName: flight.toAirportName,
                  isDomestic: flight.isDomestic,
                  height: height - 2,
                  size: GlobeRouteSize.compact,
                  highQuality: !compact,
                  reduceBorders: compact,
                  showLabels: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarStagePainterHost extends StatelessWidget {
  const _RadarStagePainterHost();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RadarStagePainter());
  }
}

class _RadarStagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.18, -0.16),
          radius: 0.94,
          colors: [
            const Color(0xFF174064).withValues(alpha: 0.34),
            Colors.transparent,
          ],
        ).createShader(rect),
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.035);
    for (var i = 0; i < 4; i++) {
      final radius = size.shortestSide * (0.22 + i * 0.16);
      canvas.drawCircle(
        Offset(size.width * 0.56, size.height * 0.48),
        radius,
        linePaint,
      );
    }

    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = AppColors.airlineRed.withValues(alpha: 0.08);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.56, size.height * 0.48),
        radius: size.shortestSide * 0.46,
      ),
      -math.pi * 0.72,
      math.pi * 0.42,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarStagePainter oldDelegate) => false;
}
