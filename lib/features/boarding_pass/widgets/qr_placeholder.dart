import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// A custom QR-code placeholder widget.
///
/// Visually mimics a real QR code using:
///   - Three large corner finder squares (top-left, top-right, bottom-left)
///   - A grid of small random-ish inner blocks
///
/// Does NOT encode real data — this is a purely decorative concept asset.
/// Created entirely with Flutter primitives, no external QR packages.
class QrPlaceholder extends StatelessWidget {
  const QrPlaceholder({
    super.key,
    this.size = 130.0,
    this.codeLabel = '',
    this.padding = 8.0,
    this.backgroundColor = Colors.white,
    this.inkColor = AppColors.deepNavy,
  });

  /// Overall size (width = height) of the QR square.
  final double size;

  /// Small text label rendered below the QR grid.
  final String codeLabel;

  /// Quiet-zone padding around the generated demo QR.
  final double padding;

  /// QR paper color.
  final Color backgroundColor;

  /// QR module color.
  final Color inkColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadius.smRadius,
          ),
          child: CustomPaint(painter: _QrPainter(inkColor: inkColor)),
        ),
        if (codeLabel.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            codeLabel,
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 2.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Paints a QR-like pattern onto a white square canvas.
class _QrPainter extends CustomPainter {
  const _QrPainter({required this.inkColor});

  final Color inkColor;

  static const int _gridSize = 21;
  static const Set<int> _dataModules = {
    8,
    10,
    13,
    15,
    17,
    19,
    29,
    31,
    33,
    37,
    40,
    50,
    54,
    57,
    59,
    61,
    72,
    75,
    78,
    82,
    85,
    92,
    96,
    100,
    103,
    105,
    113,
    116,
    120,
    124,
    128,
    134,
    137,
    139,
    143,
    146,
    151,
    155,
    158,
    160,
    164,
    167,
    174,
    176,
    179,
    183,
    187,
    194,
    198,
    201,
    205,
    208,
    213,
    216,
    220,
    223,
    226,
    232,
    235,
    239,
    242,
    246,
    253,
    257,
    260,
    264,
    268,
    273,
    276,
    280,
    284,
    287,
    294,
    298,
    302,
    305,
    309,
    316,
    318,
    321,
    325,
    329,
    337,
    340,
    344,
    347,
    350,
    359,
    361,
    365,
    368,
    372,
    380,
    384,
    387,
    391,
    394,
    401,
    405,
    409,
    412,
    416,
    423,
    426,
    430,
    433,
    437,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.shortestSide / _gridSize;
    final dark = Paint()
      ..color = inkColor
      ..isAntiAlias = false;

    _drawFinder(canvas, dark, 0, 0, cell);
    _drawFinder(canvas, dark, 14, 0, cell);
    _drawFinder(canvas, dark, 0, 14, cell);

    for (var index = 0; index < _gridSize * _gridSize; index++) {
      final row = index ~/ _gridSize;
      final col = index % _gridSize;
      if (_isFinderZone(row, col)) continue;
      if (_isTiming(row, col) || _dataModules.contains(index)) {
        _drawModule(canvas, dark, row, col, cell);
      }
    }
  }

  /// Draws a QR finder square: outer filled square, white inner, dark centre dot.
  void _drawFinder(Canvas canvas, Paint dark, int col, int row, double cell) {
    final x = col * cell;
    final y = row * cell;
    final side = 7 * cell;

    canvas.drawRect(Rect.fromLTWH(x, y, side, side), dark);

    canvas.drawRect(
      Rect.fromLTWH(x + cell, y + cell, side - 2 * cell, side - 2 * cell),
      Paint()..color = Colors.white,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        x + 2 * cell,
        y + 2 * cell,
        side - 4 * cell,
        side - 4 * cell,
      ),
      dark,
    );
  }

  void _drawModule(Canvas canvas, Paint paint, int row, int col, double cell) {
    final inset = cell * 0.10;
    canvas.drawRect(
      Rect.fromLTWH(
        col * cell + inset,
        row * cell + inset,
        cell - inset * 2,
        cell - inset * 2,
      ),
      paint,
    );
  }

  bool _isFinderZone(int row, int col) {
    final topLeft = row < 8 && col < 8;
    final topRight = row < 8 && col > 12;
    final bottomLeft = row > 12 && col < 8;
    return topLeft || topRight || bottomLeft;
  }

  bool _isTiming(int row, int col) {
    if (row == 6 && col >= 8 && col <= 12) return col.isEven;
    if (col == 6 && row >= 8 && row <= 12) return row.isEven;
    return false;
  }

  @override
  bool shouldRepaint(_QrPainter oldDelegate) =>
      oldDelegate.inkColor != inkColor;
}
