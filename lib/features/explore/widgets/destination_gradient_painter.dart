import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Paints abstract, image-free destination identities for explore cards.
class DestinationGradientPainter extends CustomPainter {
  const DestinationGradientPainter({
    required this.city,
    required this.pageOffset,
  });

  final String city;
  final double pageOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final style = _DestinationPaintStyle.fromCity(city);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.gradient,
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    _drawAmbientBands(canvas, size, style);
    _drawIdentity(canvas, size, style);
  }

  void _drawAmbientBands(
    Canvas canvas,
    Size size,
    _DestinationPaintStyle style,
  ) {
    final shift = pageOffset * size.width * 0.12;
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              style.accent.withValues(alpha: 0.34),
              style.accent.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.72 - shift, size.height * 0.18),
              radius: size.width * 0.62,
            ),
          );

    canvas.drawCircle(
      Offset(size.width * 0.72 - shift, size.height * 0.18),
      size.width * 0.62,
      glowPaint,
    );

    final sweepPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.20 + i * 0.18);
      final path = Path()
        ..moveTo(-size.width * 0.08 - shift * 0.25, y)
        ..quadraticBezierTo(
          size.width * 0.42 - shift,
          y - size.height * (0.06 + i * 0.012),
          size.width * 1.08 - shift * 0.4,
          y + size.height * 0.06,
        );
      canvas.drawPath(path, sweepPaint);
    }
  }

  void _drawIdentity(Canvas canvas, Size size, _DestinationPaintStyle style) {
    switch (style.identity) {
      case _DestinationIdentity.paris:
        _drawParis(canvas, size, style);
      case _DestinationIdentity.tokyo:
        _drawTokyo(canvas, size, style);
      case _DestinationIdentity.newYork:
        _drawNewYork(canvas, size, style);
      case _DestinationIdentity.cappadocia:
        _drawCappadocia(canvas, size, style);
      case _DestinationIdentity.london:
        _drawLondon(canvas, size, style);
      case _DestinationIdentity.ankara:
        _drawAnkara(canvas, size, style);
      case _DestinationIdentity.izmir:
        _drawIzmir(canvas, size, style);
      case _DestinationIdentity.antalya:
        _drawAntalya(canvas, size, style);
      case _DestinationIdentity.trabzon:
        _drawTrabzon(canvas, size, style);
      case _DestinationIdentity.dubai:
        _drawDubai(canvas, size, style);
    }
  }

  void _drawParis(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.16;
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width * 0.22 - shift, size.height * 0.23),
          radius: size.width * (0.28 + i * 0.08),
        ),
        math.pi * 0.08,
        math.pi * 0.78,
        false,
        linePaint..color = Colors.white.withValues(alpha: 0.13 - i * 0.015),
      );
    }

    final baseX = size.width * 0.75 - shift * 0.6;
    final baseY = size.height * 0.72;
    final towerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(baseX - 34, baseY)
      ..lineTo(baseX, baseY - 130)
      ..lineTo(baseX + 34, baseY)
      ..moveTo(baseX - 22, baseY - 44)
      ..lineTo(baseX + 22, baseY - 44)
      ..moveTo(baseX - 13, baseY - 82)
      ..lineTo(baseX + 13, baseY - 82);
    canvas.drawPath(path, towerPaint);
  }

  void _drawTokyo(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.18;
    final sunCenter = Offset(size.width * 0.76 - shift, size.height * 0.22);
    canvas.drawCircle(
      sunCenter,
      size.width * 0.17,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.softRed.withValues(alpha: 0.80),
                AppColors.airlineRed.withValues(alpha: 0.08),
              ],
            ).createShader(
              Rect.fromCircle(center: sunCenter, radius: size.width * 0.17),
            ),
    );

    final blockPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 7; i++) {
      final width = size.width * (0.045 + (i % 3) * 0.01);
      final height = size.height * (0.10 + (i % 4) * 0.035);
      final left = size.width * (0.13 + i * 0.085) - shift * 0.35;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, size.height * 0.70 - height, width, height),
          const Radius.circular(4),
        ),
        blockPaint,
      );
    }
  }

  void _drawNewYork(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.14;
    final blockPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.18),
              Colors.white.withValues(alpha: 0.04),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.30, size.width, size.height),
          );

    for (int i = 0; i < 10; i++) {
      final left = size.width * (0.08 + i * 0.085) - shift;
      final width = size.width * (0.045 + (i % 2) * 0.02);
      final top = size.height * (0.35 + (i % 5) * 0.045);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, left + width, size.height * 0.80),
          const Radius.circular(5),
        ),
        blockPaint,
      );
    }

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..strokeWidth = 0.8;
    for (int i = 0; i < 6; i++) {
      final x = size.width * (0.18 + i * 0.13) - shift * 0.55;
      canvas.drawLine(
        Offset(x, size.height * 0.36),
        Offset(x, size.height * 0.80),
        gridPaint,
      );
    }
  }

  void _drawCappadocia(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.20;
    final circles = [
      (Offset(0.70, 0.21), 0.14),
      (Offset(0.86, 0.34), 0.10),
      (Offset(0.58, 0.42), 0.08),
    ];

    for (final circle in circles) {
      final center = Offset(
        size.width * circle.$1.dx - shift * (circle.$1.dx + 0.2),
        size.height * circle.$1.dy,
      );
      final radius = size.width * circle.$2;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.18),
              style.accent.withValues(alpha: 0.06),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
      canvas.drawLine(
        Offset(center.dx, center.dy + radius),
        Offset(center.dx, center.dy + radius + size.height * 0.06),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.09)
          ..strokeWidth = 1.0,
      );
    }

    final valleyPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * 0.84)
      ..quadraticBezierTo(
        size.width * 0.18 - shift * 0.25,
        size.height * 0.68,
        size.width * 0.38,
        size.height * 0.83,
      )
      ..quadraticBezierTo(
        size.width * 0.58 - shift * 0.16,
        size.height * 0.65,
        size.width,
        size.height * 0.82,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, valleyPaint);
  }

  void _drawLondon(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.13;
    final rainPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 22; i++) {
      final x = size.width * ((i * 0.071) % 1.0) - shift * 0.7;
      final y = size.height * (0.10 + (i % 7) * 0.09);
      canvas.drawLine(Offset(x, y), Offset(x - 10, y + 24), rainPaint);
    }

    final bridgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.13)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final y = size.height * 0.70;
    final path = Path()
      ..moveTo(size.width * 0.12 - shift, y)
      ..quadraticBezierTo(
        size.width * 0.50 - shift,
        y - size.height * 0.17,
        size.width * 0.88 - shift,
        y,
      )
      ..moveTo(size.width * 0.16 - shift, y)
      ..lineTo(size.width * 0.86 - shift, y);
    canvas.drawPath(path, bridgePaint);

    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.20 + i * 0.14) - shift;
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y - size.height * 0.08),
        bridgePaint,
      );
    }
  }

  void _drawAnkara(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.15;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final startX = size.width * 0.25 - shift;
    final baseY = size.height * 0.70;
    for (int i = 0; i < 6; i++) {
      final x = startX + i * 22;
      canvas.drawRect(Rect.fromLTWH(x, baseY - 60, 8, 60), paint);
    }
    canvas.drawRect(Rect.fromLTWH(startX - 6, baseY - 68, 130, 8), paint);
  }

  void _drawIzmir(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.16;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final y = size.height * 0.72;
    final path = Path()
      ..moveTo(0, y)
      ..quadraticBezierTo(
        size.width * 0.25 - shift,
        y - 15,
        size.width * 0.5 - shift,
        y,
      )
      ..quadraticBezierTo(size.width * 0.75 - shift, y + 15, size.width, y);
    canvas.drawPath(path, wavePaint);

    final towerX = size.width * 0.72 - shift * 0.7;
    final towerPath = Path()
      ..moveTo(towerX - 12, y)
      ..lineTo(towerX - 12, y - 80)
      ..lineTo(towerX - 6, y - 90)
      ..lineTo(towerX + 6, y - 90)
      ..lineTo(towerX + 12, y - 80)
      ..lineTo(towerX + 12, y)
      ..moveTo(towerX - 6, y - 90)
      ..lineTo(towerX, y - 110)
      ..lineTo(towerX + 6, y - 90);
    canvas.drawPath(towerPath, paint);
  }

  void _drawAntalya(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.18;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    final sunCenter = Offset(size.width * 0.78 - shift, size.height * 0.24);
    canvas.drawCircle(
      sunCenter,
      size.width * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );

    final cliffPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.20 - shift,
        size.height * 0.58,
        size.width * 0.35 - shift,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.60 - shift,
        size.height * 0.85,
        size.width,
        size.height * 0.85,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(cliffPath, paint);
  }

  void _drawTrabzon(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.14;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.09)
      ..style = PaintingStyle.fill;

    final mPath1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.42)
      ..lineTo(size.width * 0.45 - shift, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.38)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(mPath1, paint);

    final mPath2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.65)
      ..lineTo(size.width * 0.58 - shift, size.height * 0.50)
      ..lineTo(size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      mPath2,
      paint..color = Colors.white.withValues(alpha: 0.12),
    );

    final fogPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.20 - shift, size.height * 0.75),
      Offset(size.width * 0.80 - shift, size.height * 0.70),
      fogPaint,
    );
  }

  void _drawDubai(Canvas canvas, Size size, _DestinationPaintStyle style) {
    final shift = pageOffset * size.width * 0.17;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.11)
      ..style = PaintingStyle.fill;

    final y = size.height * 0.72;
    final sailX = size.width * 0.74 - shift * 0.6;
    final sailPath = Path()
      ..moveTo(sailX - 20, y)
      ..quadraticBezierTo(sailX, y - 90, sailX, y - 110)
      ..quadraticBezierTo(sailX + 15, y - 45, sailX + 22, y)
      ..moveTo(sailX, y - 110)
      ..lineTo(sailX + 22, y);
    canvas.drawPath(sailPath, paint);

    for (int i = 0; i < 4; i++) {
      final w = size.width * 0.05;
      final h = size.height * (0.08 + i * 0.03);
      final left = size.width * (0.15 + i * 0.12) - shift * 0.45;
      canvas.drawRect(Rect.fromLTWH(left, y - h, w, h), paint);
    }
  }

  @override
  bool shouldRepaint(DestinationGradientPainter oldDelegate) {
    return oldDelegate.city != city || oldDelegate.pageOffset != pageOffset;
  }
}

enum _DestinationIdentity {
  paris,
  tokyo,
  newYork,
  cappadocia,
  london,
  ankara,
  izmir,
  antalya,
  trabzon,
  dubai,
}

class _DestinationPaintStyle {
  const _DestinationPaintStyle({
    required this.identity,
    required this.gradient,
    required this.accent,
  });

  final _DestinationIdentity identity;
  final List<Color> gradient;
  final Color accent;

  factory _DestinationPaintStyle.fromCity(String city) {
    switch (city.toLowerCase()) {
      case 'paris':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.paris,
          gradient: [Color(0xFF3B2332), Color(0xFF8C4D3F), Color(0xFF17121B)],
          accent: Color(0xFFFFA267),
        );
      case 'tokyo':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.tokyo,
          gradient: [Color(0xFF160D2E), Color(0xFF25204B), Color(0xFF070B16)],
          accent: AppColors.airlineRed,
        );
      case 'new york':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.newYork,
          gradient: [Color(0xFF182538), Color(0xFF2D4A63), Color(0xFF080B12)],
          accent: Color(0xFF79B9E9),
        );
      case 'kapadokya':
      case 'cappadocia':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.cappadocia,
          gradient: [Color(0xFF331412), Color(0xFF9A3F2E), Color(0xFF120D12)],
          accent: Color(0xFFFF7B4A),
        );
      case 'londra':
      case 'london':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.london,
          gradient: [Color(0xFF1E2631), Color(0xFF465161), Color(0xFF080B12)],
          accent: Color(0xFFBAC6D4),
        );
      case 'dubai':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.dubai,
          gradient: [Color(0xFF322016), Color(0xFF9B6B35), Color(0xFF0D1119)],
          accent: Color(0xFFFFC36A),
        );
      case 'ankara':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.ankara,
          gradient: [Color(0xFF172235), Color(0xFF3B526D), Color(0xFF070B12)],
          accent: Color(0xFF9BB5D8),
        );
      case 'izmir':
      case 'i̇zmir':
      case 'İzmir':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.izmir,
          gradient: [Color(0xFF163040), Color(0xFFB06445), Color(0xFF071018)],
          accent: Color(0xFFFFA45B),
        );
      case 'antalya':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.antalya,
          gradient: [Color(0xFF0C2B36), Color(0xFF237B78), Color(0xFF081018)],
          accent: Color(0xFF58D5C9),
        );
      case 'trabzon':
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.trabzon,
          gradient: [Color(0xFF102A22), Color(0xFF365D4E), Color(0xFF07100D)],
          accent: Color(0xFF6ED19C),
        );
      default:
        return const _DestinationPaintStyle(
          identity: _DestinationIdentity.paris,
          gradient: [Color(0xFF172235), Color(0xFF39445C), Color(0xFF070B12)],
          accent: AppColors.airlineRed,
        );
    }
  }
}
