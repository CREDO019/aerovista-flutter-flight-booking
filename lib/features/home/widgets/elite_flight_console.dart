import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'elite_route_viewport.dart';

class EliteFlightConsole extends StatefulWidget {
  const EliteFlightConsole({super.key, required this.compact});

  final bool compact;

  @override
  State<EliteFlightConsole> createState() => _EliteFlightConsoleState();
}

class _EliteFlightConsoleState extends State<EliteFlightConsole>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;
    final padding = compact ? AppSpacing.md : AppSpacing.lg;
    final sectionGap = compact ? AppSpacing.md : AppSpacing.lg;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 42,
            offset: const Offset(0, 22),
          ),
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.10),
            blurRadius: 52,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xlRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.105),
                      AppColors.glassWhite.withValues(alpha: 0.70),
                      AppColors.cardWhite.withValues(alpha: 0.82),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.11),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) => CustomPaint(
                  painter: _ConsoleSweepPainter(_controller.value),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ConsoleStatusRow(progress: _controller.value),
                  SizedBox(height: sectionGap),
                  _RouteSelectorRow(
                    compact: compact,
                    progress: _controller.value,
                  ),
                  SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                  _TripDetailModules(compact: compact),
                  SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
                  EliteRouteViewport(compact: compact),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xlRadius,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.09),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsoleStatusRow extends StatelessWidget {
  const _ConsoleStatusRow({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final pulse = 0.5 + 0.5 * math.sin(progress * math.pi * 2);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Özel Rota Planlayıcı',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.15,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.airlineRed.withValues(alpha: 0.10),
            borderRadius: AppRadius.pillRadius,
            border: Border.all(
              color: AppColors.airlineRed.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.softRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.airlineRed.withValues(
                        alpha: 0.35 + pulse * 0.25,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'Canlı Konsept',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteSelectorRow extends StatelessWidget {
  const _RouteSelectorRow({required this.compact, required this.progress});

  final bool compact;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AirportPanel(
            label: 'Nereden',
            code: 'IST',
            city: 'İstanbul',
            airportName: 'İstanbul Havalimanı',
            compact: compact,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10),
          child: _SwapButton(progress: progress, compact: compact),
        ),
        Expanded(
          child: _AirportPanel(
            label: 'Nereye',
            code: 'CDG',
            city: 'Paris',
            airportName: 'Charles de Gaulle Havalimanı',
            compact: compact,
            alignRight: true,
          ),
        ),
      ],
    );
  }
}

class _AirportPanel extends StatelessWidget {
  const _AirportPanel({
    required this.label,
    required this.code,
    required this.city,
    required this.airportName,
    required this.compact,
    this.alignRight = false,
  });

  final String label;
  final String code;
  final String city;
  final String airportName;
  final bool compact;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.sm : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.075)),
      ),
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.82),
              letterSpacing: 1.15,
            ),
          ),
          SizedBox(height: compact ? 2 : 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: alignRight
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              code,
              style: AppTextStyles.display.copyWith(
                fontSize: compact ? 35 : 45,
                height: 1,
                letterSpacing: 1.4,
              ),
            ),
          ),
          Text(
            city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.56),
            ),
          ),
          Text(
            airportName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignRight ? TextAlign.end : TextAlign.start,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.38),
              fontSize: compact ? 8 : 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.progress, required this.compact});

  final double progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final angle = math.sin(progress * math.pi * 2) * 0.05;

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: compact ? 40 : 46,
        height: compact ? 40 : 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.airlineRed.withValues(alpha: 0.28),
              AppColors.deepRed.withValues(alpha: 0.30),
            ],
          ),
          border: Border.all(color: AppColors.softRed.withValues(alpha: 0.34)),
          boxShadow: [
            BoxShadow(
              color: AppColors.airlineRed.withValues(alpha: 0.18),
              blurRadius: 18,
            ),
          ],
        ),
        child: const Icon(
          Icons.swap_horiz_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _TripDetailModules extends StatelessWidget {
  const _TripDetailModules({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FlightDetailModule(
          icon: Icons.calendar_today_rounded,
          label: 'Tarih',
          value: '18 Temmuz',
          compact: compact,
        ),
        SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),
        _FlightDetailModule(
          icon: Icons.person_outline_rounded,
          label: 'Yolcu',
          value: '1 Yetişkin',
          compact: compact,
        ),
        SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),
        _FlightDetailModule(
          icon: Icons.airline_seat_recline_normal_rounded,
          label: 'Kabin',
          value: 'Ekonomi',
          compact: compact,
        ),
      ],
    );
  }
}

class _FlightDetailModule extends StatelessWidget {
  const _FlightDetailModule({
    required this.icon,
    required this.label,
    required this.value,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : AppSpacing.sm,
          vertical: compact ? 8 : AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.045),
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Icon(icon, size: compact ? 13 : 15, color: AppColors.softRed),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: compact ? 9 : 10,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: compact ? 10 : 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsoleSweepPainter extends CustomPainter {
  const _ConsoleSweepPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final x = -size.width * 0.55 + size.width * 2.1 * t;
    final rect = Rect.fromLTWH(
      x,
      -size.height * 0.35,
      size.width * 0.20,
      size.height * 1.7,
    );

    canvas.save();
    canvas.rotate(-0.20);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.055),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ConsoleSweepPainter oldDelegate) => oldDelegate.t != t;
}
