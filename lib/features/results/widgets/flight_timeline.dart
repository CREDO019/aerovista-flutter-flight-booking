import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/premium_plane_marker.dart';

/// A horizontal flight-route timeline widget.
///
/// Shows:
///   LEFT  — departure time + IATA code
///   CENTER — dotted line with plane icon + duration label
///   RIGHT  — arrival time + IATA code
///
/// Reusable across both the results cards and future boarding pass layouts.
class FlightTimeline extends StatelessWidget {
  const FlightTimeline({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
  });

  final String fromCode;
  final String toCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Origin ─────────────────────────────────────────────────────
        _TimeStop(time: departureTime, code: fromCode),

        // ── Route line ─────────────────────────────────────────────────
        Expanded(child: _RouteLine(duration: duration)),

        // ── Destination ────────────────────────────────────────────────
        _TimeStop(time: arrivalTime, code: toCode, alignRight: true),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TimeStop extends StatelessWidget {
  const _TimeStop({
    required this.time,
    required this.code,
    this.alignRight = false,
  });

  final String time;
  final String code;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: AppTextStyles.title.copyWith(fontSize: 22, letterSpacing: 0),
        ),
        Text(
          code,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine({required this.duration});
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Duration label
        Text(duration, style: AppTextStyles.caption),

        const SizedBox(height: AppSpacing.xs),

        // Dotted line with centred plane icon
        Row(
          children: [
            // Left dash segment
            Expanded(child: _DottedLine()),

            // Plane icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: const PremiumPlaneMarker(
                size: 18,
                variant: PlaneMarkerVariant.minimal,
                glow: false,
              ),
            ),

            // Right dash segment
            Expanded(child: _DottedLine()),
          ],
        ),
      ],
    );
  }
}

/// A simple dotted horizontal line rendered via [CustomPaint].
class _DottedLine extends StatelessWidget {
  const _DottedLine();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedLinePainter(),
      child: const SizedBox(height: 1),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const dashGap = 3.0;
    double x = 0;
    final paint = Paint()
      ..color = AppColors.borderSoft
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter old) => false;
}
