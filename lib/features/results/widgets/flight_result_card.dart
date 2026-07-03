import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/flight_model.dart';
import '../../../shared/widgets/flight_hero_surface.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// Elite premium ticket selector for a flight result.
///
/// Preserves the existing Hero tag `"flight-card-${flight.id}"` used by the
/// boarding pass transition.
class FlightResultCard extends StatefulWidget {
  const FlightResultCard({
    super.key,
    required this.flight,
    required this.onTap,
    this.isRecommended = false,
    this.isProminent = false,
  });

  final FlightModel flight;
  final VoidCallback onTap;
  final bool isRecommended;
  final bool isProminent;

  @override
  State<FlightResultCard> createState() => _FlightResultCardState();
}

class _FlightResultCardState extends State<FlightResultCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'flight-card-${widget.flight.id}',
      flightShuttleBuilder: (_, animation, _, _, _) {
        return FadeTransition(
          opacity: animation,
          child: FlightHeroSurface(flight: widget.flight),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: _controller.reverse,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: _CardSurface(
            flight: widget.flight,
            isRecommended: widget.isRecommended,
            isProminent: widget.isProminent,
          ),
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.flight,
    required this.isRecommended,
    required this.isProminent,
  });

  final FlightModel flight;
  final bool isRecommended;
  final bool isProminent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 350;
        final padding = compact ? AppSpacing.md : AppSpacing.md + 2;
        return Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgRadius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF131B2A), Color(0xFF08101C)],
            ),
            border: Border.all(
              color: isRecommended
                  ? AppColors.airlineRed.withValues(alpha: 0.42)
                  : Colors.white.withValues(alpha: 0.085),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
              if (isRecommended || isProminent)
                BoxShadow(
                  color: AppColors.airlineRed.withValues(alpha: 0.12),
                  blurRadius: 26,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: Stack(
              children: [
                const Positioned.fill(child: _CardAura()),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 2.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.airlineRed.withValues(alpha: 0.92),
                          AppColors.softRed.withValues(alpha: 0.32),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTopRow(
                        flight: flight,
                        isRecommended: isRecommended,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                      _RoutePanel(flight: flight, compact: compact),
                      SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                      _CardBottomRow(flight: flight, compact: compact),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardAura extends StatelessWidget {
  const _CardAura();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CardAuraPainter());
  }
}

class _CardAuraPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.78, -0.88),
          radius: 1.05,
          colors: [Colors.white.withValues(alpha: 0.055), Colors.transparent],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.98, -0.12),
          radius: 0.88,
          colors: [
            AppColors.airlineRed.withValues(alpha: 0.09),
            Colors.transparent,
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _CardAuraPainter oldDelegate) => false;
}

class _CardTopRow extends StatelessWidget {
  const _CardTopRow({
    required this.flight,
    required this.isRecommended,
    required this.compact,
  });

  final FlightModel flight;
  final bool isRecommended;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _StatusPill(
                label: isRecommended ? 'ÖNERİLEN UÇUŞ' : _primaryLabel,
                icon: isRecommended
                    ? Icons.stars_rounded
                    : Icons.flight_takeoff_rounded,
                color: isRecommended
                    ? AppColors.airlineRed
                    : const Color(0xFF2A6FBA),
                strong: isRecommended,
              ),
              _StatusPill(
                label: flight.stops == 0 ? 'Direkt' : '${flight.stops} Aktarma',
                icon: Icons.timeline_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              flight.flightNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.82),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              flight.cabin,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.78),
                fontSize: compact ? 9.5 : 10.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String get _primaryLabel => flight.isDomestic ? 'Yurtiçi' : 'Yurtdışı';
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.icon,
    required this.color,
    this.strong = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: strong ? 0.18 : 0.10),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(
          color: color.withValues(alpha: strong ? 0.38 : 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color.withValues(alpha: 0.96)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: strong
                  ? Colors.white.withValues(alpha: 0.92)
                  : AppColors.textPrimary.withValues(alpha: 0.74),
              fontSize: 9.3,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w700,
              letterSpacing: strong ? 0.6 : 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePanel extends StatelessWidget {
  const _RoutePanel({required this.flight, required this.compact});

  final FlightModel flight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.sm : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF07101B).withValues(alpha: 0.76),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.075)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _AirportStop(
              time: flight.departureTime,
              code: flight.fromCode,
              airportName: flight.fromAirportName,
              compact: compact,
            ),
          ),
          SizedBox(
            width: compact ? 96 : 116,
            child: _RouteBridge(duration: flight.duration, compact: compact),
          ),
          Expanded(
            child: _AirportStop(
              time: flight.arrivalTime,
              code: flight.toCode,
              airportName: flight.toAirportName,
              compact: compact,
              alignRight: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AirportStop extends StatelessWidget {
  const _AirportStop({
    required this.time,
    required this.code,
    required this.airportName,
    required this.compact,
    this.alignRight = false,
  });

  final String time;
  final String code;
  final String airportName;
  final bool compact;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title.copyWith(
            fontSize: compact ? 20 : 23,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          code,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.82),
            fontSize: compact ? 12.5 : 13.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          airportName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignRight ? TextAlign.end : TextAlign.start,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.68),
            fontSize: compact ? 8.6 : 9.2,
          ),
        ),
      ],
    );
  }
}

class _RouteBridge extends StatelessWidget {
  const _RouteBridge({required this.duration, required this.compact});

  final String duration;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          duration,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.64),
            fontWeight: FontWeight.w700,
            fontSize: compact ? 9.2 : 10.0,
          ),
        ),
        SizedBox(height: compact ? 5 : 7),
        SizedBox(
          height: compact ? 22 : 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned.fill(child: _PremiumRouteLine()),
              PremiumPlaneMarker(
                size: compact ? 13 : 14,
                variant: PlaneMarkerVariant.minimal,
                glow: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PremiumRouteLine extends StatelessWidget {
  const _PremiumRouteLine();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PremiumRouteLinePainter());
  }
}

class _PremiumRouteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final glowPaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: 0.12)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), glowPaint);

    var x = 0.0;
    const dash = 4.0;
    const gap = 4.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, centerY),
        Offset((x + dash).clamp(0, size.width), centerY),
        linePaint,
      );
      x += dash + gap;
    }

    final nodePaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: 0.78);
    canvas.drawCircle(Offset(0, centerY), 2.4, nodePaint);
    canvas.drawCircle(Offset(size.width, centerY), 2.4, nodePaint);
  }

  @override
  bool shouldRepaint(covariant _PremiumRouteLinePainter oldDelegate) => false;
}

class _CardBottomRow extends StatelessWidget {
  const _CardBottomRow({required this.flight, required this.compact});

  final FlightModel flight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _InfoChip(icon: Icons.luggage_rounded, label: flight.baggage),
              _InfoChip(
                icon: Icons.airline_stops_rounded,
                label: flight.stops == 0
                    ? 'Direkt uçuş'
                    : '${flight.stops} aktarma',
              ),
              _InfoChip(
                icon: _periodIcon(flight.departurePeriod),
                label: _periodLabel(flight.departurePeriod),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _PriceAction(price: flight.price, compact: compact),
      ],
    );
  }

  IconData _periodIcon(String period) {
    return switch (period) {
      'sabah' => Icons.wb_sunny_outlined,
      'akşam' => Icons.nights_stay_outlined,
      'gece' => Icons.dark_mode_outlined,
      _ => Icons.schedule_rounded,
    };
  }

  String _periodLabel(String period) {
    return switch (period) {
      'sabah' => 'Sabah',
      'öğle' => 'Öğle',
      'akşam' => 'Akşam',
      'gece' => 'Gece',
      _ => period,
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.textSecondary.withValues(alpha: 0.76),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.80),
            fontSize: 9.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PriceAction extends StatelessWidget {
  const _PriceAction({required this.price, required this.compact});

  final int price;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(compact ? 10 : 12, 8, compact ? 9 : 11, 8),
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.airlineRed.withValues(alpha: 0.20),
            AppColors.deepRed.withValues(alpha: 0.24),
          ],
        ),
        border: Border.all(color: AppColors.airlineRed.withValues(alpha: 0.34)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'USD',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.softRed.withValues(alpha: 0.86),
                  fontSize: 8.4,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '\$$price',
                style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontSize: compact ? 18 : 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(width: 9),
          Container(
            width: compact ? 28 : 30,
            height: compact ? 28 : 30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
