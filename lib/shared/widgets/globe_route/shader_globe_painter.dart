import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'world_map_data.dart';
import 'world_projection.dart';

class PremiumGlobeShaderPainter extends CustomPainter {
  const PremiumGlobeShaderPainter({
    required this.program,
    required this.texture,
    required this.time,
    required this.rotation,
    required this.centerLat,
    required this.opacity,
    required this.rimStrength,
    required this.atmosphereStrength,
  });

  final ui.FragmentProgram program;
  final ui.Image texture;
  final double time;
  final double rotation;
  final double centerLat;
  final double opacity;
  final double rimStrength;
  final double atmosphereStrength;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader()
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, rotation)
      ..setFloat(4, -0.48)
      ..setFloat(5, 0.54)
      ..setFloat(6, 0.70)
      ..setFloat(7, rimStrength)
      ..setFloat(8, atmosphereStrength)
      ..setFloat(9, opacity)
      ..setFloat(10, _radians(centerLat))
      ..setImageSampler(0, texture);

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = shader
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(PremiumGlobeShaderPainter oldDelegate) {
    return oldDelegate.program != program ||
        oldDelegate.texture != texture ||
        oldDelegate.time != time ||
        oldDelegate.rotation != rotation ||
        oldDelegate.centerLat != centerLat ||
        oldDelegate.opacity != opacity ||
        oldDelegate.rimStrength != rimStrength ||
        oldDelegate.atmosphereStrength != atmosphereStrength;
  }
}

class OptimizedFallbackGlobe extends StatelessWidget {
  const OptimizedFallbackGlobe({
    super.key,
    required this.size,
    this.rotation = 0,
    this.centerLat = 39.4,
    this.opacity = 1,
    this.highQuality = true,
  });

  final double size;
  final double rotation;
  final double centerLat;
  final double opacity;
  final bool highQuality;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: PremiumFallbackGlobePainter(
          rotation: rotation,
          centerLat: centerLat,
          opacity: opacity,
          highQuality: highQuality,
        ),
      ),
    );
  }
}

class PremiumFallbackGlobePainter extends CustomPainter {
  const PremiumFallbackGlobePainter({
    required this.rotation,
    required this.centerLat,
    required this.opacity,
    required this.highQuality,
  });

  final double rotation;
  final double centerLat;
  final double opacity;
  final bool highQuality;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final radius = side / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final globePath = Path()..addOval(rect);

    canvas.saveLayer(Offset.zero & size, Paint());
    _drawAtmosphere(canvas, center, radius);
    _drawSphere(canvas, rect, center, radius);

    canvas.save();
    canvas.clipPath(globePath);
    _drawContinents(canvas, center, radius);
    if (highQuality) {
      _drawBorders(canvas, center, radius);
      _drawMeridians(canvas, center, radius);
    }
    _drawTerminator(canvas, rect, center, radius);
    canvas.restore();

    _drawRim(canvas, rect, radius);
    canvas.restore();
  }

  void _drawAtmosphere(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius * 1.18,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.42, -0.50),
          radius: 1.10,
          colors: [
            const Color(0xFF8EC8E8).withValues(alpha: 0.13 * opacity),
            const Color(0xFF2A6FBA).withValues(alpha: 0.08 * opacity),
            AppColors.airlineRed.withValues(alpha: 0.045 * opacity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 0.70, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.18)),
    );
  }

  void _drawSphere(Canvas canvas, Rect rect, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.46, -0.52),
          radius: 1.08,
          colors: [
            const Color(0xFF486D88).withValues(alpha: opacity),
            const Color(0xFF163958).withValues(alpha: opacity),
            const Color(0xFF071828).withValues(alpha: opacity),
            const Color(0xFF02050B).withValues(alpha: opacity),
          ],
          stops: const [0.0, 0.32, 0.70, 1.0],
        ).createShader(rect),
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.22, center.dy - radius * 0.32),
      radius * 0.58,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.13 * opacity),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(
                  center.dx - radius * 0.22,
                  center.dy - radius * 0.32,
                ),
                radius: radius * 0.58,
              ),
            ),
    );
  }

  void _drawContinents(Canvas canvas, Offset center, double radius) {
    final projection = _projection(center, radius);
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.4);
    final landPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFB8D3DC).withValues(alpha: 0.36 * opacity),
          const Color(0xFF86AABA).withValues(alpha: 0.25 * opacity),
          const Color(0xFF4D7184).withValues(alpha: 0.18 * opacity),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    final coastPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.45, radius * 0.004)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE5F5FA).withValues(alpha: 0.22 * opacity);

    for (final continent in WorldMapData.continents) {
      final path = _pathFor(projection, continent.points);
      if (path == null) continue;
      canvas.drawPath(path.shift(const Offset(0.6, 0.8)), shadowPaint);
      canvas.drawPath(path, landPaint);
      canvas.drawPath(path, coastPaint);
    }

    final turkeyPath = _pathFor(projection, WorldMapData.turkeyRegion.points);
    if (turkeyPath != null) {
      canvas.drawPath(
        turkeyPath,
        Paint()..color = AppColors.airlineRed.withValues(alpha: 0.07 * opacity),
      );
    }
  }

  void _drawBorders(Canvas canvas, Offset center, double radius) {
    final projection = _projection(center, radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.36, radius * 0.003)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFE2F4FF).withValues(alpha: 0.13 * opacity);

    for (final border in WorldMapData.countryBorders) {
      final path = _lineFor(projection, border.points);
      if (path != null) {
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawMeridians(Canvas canvas, Offset center, double radius) {
    final projection = _projection(center, radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.32, radius * 0.0026)
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFD8F1FF).withValues(alpha: 0.035 * opacity);

    for (final lat in [-45.0, 0.0, 45.0]) {
      final points = <GlobeGeoPoint>[
        for (var lng = -180.0; lng <= 180.0; lng += 8.0)
          GlobeGeoPoint(lat, lng),
      ];
      final path = _lineFor(projection, points);
      if (path != null) canvas.drawPath(path, paint);
    }

    for (final lng in [-90.0, 0.0, 90.0]) {
      final points = <GlobeGeoPoint>[
        for (var lat = -72.0; lat <= 72.0; lat += 8.0) GlobeGeoPoint(lat, lng),
      ];
      final path = _lineFor(projection, points);
      if (path != null) canvas.drawPath(path, paint);
    }
  }

  void _drawTerminator(Canvas canvas, Rect rect, Offset center, double radius) {
    canvas.drawOval(
      Rect.fromLTWH(
        rect.left + rect.width * 0.33,
        rect.top - rect.height * 0.02,
        rect.width * 0.82,
        rect.height * 1.06,
      ),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.17 * opacity),
            Colors.black.withValues(alpha: 0.46 * opacity),
          ],
          stops: const [0.0, 0.50, 1.0],
        ).createShader(rect),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.08 * opacity),
            Colors.black.withValues(alpha: 0.27 * opacity),
          ],
          stops: const [0.58, 0.82, 1.0],
        ).createShader(rect),
    );
  }

  void _drawRim(Canvas canvas, Rect rect, double radius) {
    canvas.drawOval(
      rect.deflate(0.25),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, radius * 0.010)
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.30 * opacity),
            const Color(0xFF9DD1EC).withValues(alpha: 0.17 * opacity),
            AppColors.airlineRed.withValues(alpha: 0.13 * opacity),
            Colors.white.withValues(alpha: 0.035 * opacity),
          ],
          stops: const [0.0, 0.38, 0.69, 1.0],
        ).createShader(rect),
    );
  }

  GlobeProjection _projection(Offset center, double radius) {
    return GlobeProjection(
      centerLat: centerLat,
      centerLng: _degrees(rotation),
      radius: radius * 0.95,
      center: center,
    );
  }

  Path? _pathFor(GlobeProjection projection, List<GlobeGeoPoint> points) {
    final projected = <Offset>[];
    for (final point in points) {
      final result = projection.project(point);
      if (result != null && result.edgeFade > 0.06) {
        projected.add(result.offset);
      }
    }
    if (projected.length < 3) return null;
    final path = Path();
    final firstMid = Offset.lerp(projected.last, projected.first, 0.5)!;
    path.moveTo(firstMid.dx, firstMid.dy);
    for (var i = 0; i < projected.length; i++) {
      final current = projected[i];
      final next = projected[(i + 1) % projected.length];
      final mid = Offset.lerp(current, next, 0.5)!;
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
    }
    return path..close();
  }

  Path? _lineFor(GlobeProjection projection, List<GlobeGeoPoint> points) {
    final path = Path();
    var started = false;
    for (final point in points) {
      final result = projection.project(point);
      if (result == null || result.edgeFade < 0.12) {
        started = false;
        continue;
      }
      if (!started) {
        path.moveTo(result.offset.dx, result.offset.dy);
        started = true;
      } else {
        path.lineTo(result.offset.dx, result.offset.dy);
      }
    }
    return started ? path : null;
  }

  @override
  bool shouldRepaint(PremiumFallbackGlobePainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.centerLat != centerLat ||
        oldDelegate.opacity != opacity ||
        oldDelegate.highQuality != highQuality;
  }
}

double _radians(double degrees) => degrees * math.pi / 180.0;

double _degrees(double radians) => radians * 180.0 / math.pi;
