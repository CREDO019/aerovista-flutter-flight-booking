import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Realistic perforated ticket divider.
///
/// Renders:
///   - A left half-circle notch (cut into the card edge)
///   - A dashed centre line via [CustomPainter]
///   - A right half-circle notch
///
/// Place this between the main flight info section and the QR section
/// to give the boarding pass a physical, tactile feel.
class PerforatedDivider extends StatelessWidget {
  const PerforatedDivider({super.key});

  static const double _notchRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _notchRadius * 2,
      child: Row(
        children: [
          // ── Left half-circle notch ──────────────────────────────────
          _HalfCircle(fromLeft: true),

          // ── Dashed centre line ──────────────────────────────────────
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(),
              child: const SizedBox.expand(),
            ),
          ),

          // ── Right half-circle notch ─────────────────────────────────
          _HalfCircle(fromLeft: false),
        ],
      ),
    );
  }
}

/// A semicircle cut into the card edge — mimics a ticket perforation notch.
class _HalfCircle extends StatelessWidget {
  const _HalfCircle({required this.fromLeft});
  final bool fromLeft;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: fromLeft ? Alignment.centerRight : Alignment.centerLeft,
        widthFactor: 0.5,
        child: Container(
          width: PerforatedDivider._notchRadius * 2,
          height: PerforatedDivider._notchRadius * 2,
          decoration: const BoxDecoration(
            color: AppColors.backgroundBlack,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashW = 5.0;
    const gapW = 4.0;
    double x = 0;
    final paint = Paint()
      ..color = AppColors.borderSoft
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + dashW, size.height / 2),
        paint,
      );
      x += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter _) => false;
}
