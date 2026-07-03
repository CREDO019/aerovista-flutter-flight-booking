import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../premium_plane_marker.dart';
import 'globe_route_models.dart';
import 'world_map_data.dart';

/// Static painter for the globe background layer.
///
/// Draws all non-changing visual components (sphere body, ocean surface,
/// continents, border lines, grid lines, terminator shadow, highlights, rim,
/// and static node endpoints with labels).
class StaticGlobePainter extends CustomPainter {
  const StaticGlobePainter({
    required this.geometry,
    required this.route,
    required this.compact,
    required this.highQuality,
    required this.isDomestic,
  });

  final GlobeRouteGeometry geometry;
  final GlobeRouteData route;
  final bool compact;
  final bool highQuality;
  final bool isDomestic;

  @override
  void paint(Canvas canvas, Size size) {
    final center = geometry.center;
    final radius = geometry.radius;
    final globeRect = geometry.globeRect;
    final globePath = geometry.globePath;
    final routeSideAngle = geometry.routeSideAngle;

    _drawAtmosphere(canvas, center, radius, routeSideAngle);
    _drawSphere(canvas, globeRect, center, radius);

    canvas.save();
    canvas.clipPath(globePath);
    _drawOceanSurface(canvas, globeRect, center, radius);
    _drawOceanCurrentBands(canvas);
    _drawContinents(canvas, globeRect);
    _drawGrid(canvas);
    _drawTurkeyFocus(canvas);
    _drawCountryBorders(canvas);
    _drawRouteIllumination(
      canvas,
      geometry.fromPoint,
      geometry.toPoint,
      radius,
    );
    _drawTerminator(canvas, globeRect, center, radius);
    _drawHorizonFade(canvas, globeRect, center, radius);
    _drawSpecularHighlight(canvas, center, radius);
    canvas.restore();

    _drawRim(canvas, globeRect, center, radius, routeSideAngle);

    // Static endpoint nodes and airport codes drawn completely statically
    _drawNode(canvas, geometry.curve.from, 1.0, false, geometry.nodeSize);
    _drawNode(canvas, geometry.curve.to, 1.0, true, geometry.nodeSize);

    _drawEndpointCode(
      canvas,
      node: geometry.curve.from,
      code: route.fromCode,
      globeCenter: geometry.center,
      arrival: false,
      opacity: 1.0,
      labelFontSize: geometry.labelFontSize,
      labelOffset: geometry.labelOffset,
    );
    _drawEndpointCode(
      canvas,
      node: geometry.curve.to,
      code: route.toCode,
      globeCenter: geometry.center,
      arrival: true,
      opacity: 1.0,
      labelFontSize: geometry.labelFontSize,
      labelOffset: geometry.labelOffset,
    );
  }

  void _drawAtmosphere(
    Canvas canvas,
    Offset center,
    double radius,
    double routeSideAngle,
  ) {
    canvas.drawCircle(
      center,
      radius * 1.22,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.42),
          radius: 1.12,
          colors: [
            const Color(0xFF8FBED7).withValues(alpha: compact ? 0.10 : 0.13),
            const Color(0xFF2A6FBA).withValues(alpha: compact ? 0.08 : 0.10),
            const Color(0xFF071527).withValues(alpha: compact ? 0.06 : 0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.46, 0.72, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.22)),
    );
    canvas.drawCircle(
      center,
      radius * 1.10,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF2A6FBA).withValues(alpha: compact ? 0.035 : 0.052),
            Colors.transparent,
          ],
          stops: const [0.62, 0.84, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.10)),
    );
    canvas.drawCircle(
      center,
      radius * 1.035,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 2.8 : 3.8
        ..color = const Color(0xFF9FC9DE).withValues(alpha: 0.040)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.045),
      routeSideAngle - 0.34,
      0.68,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 2.8 : 3.8
        ..strokeCap = StrokeCap.round
        ..color = AppColors.airlineRed.withValues(
          alpha: compact ? 0.055 : 0.075,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.5),
    );
  }

  void _drawRim(
    Canvas canvas,
    Rect rect,
    Offset center,
    double radius,
    double routeSideAngle,
  ) {
    canvas.drawOval(
      rect.inflate(compact ? 0.5 : 0.8),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 0.92 : 1.18
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: compact ? 0.25 : 0.32),
            const Color(0xFF9DD1EC).withValues(alpha: compact ? 0.13 : 0.18),
            AppColors.airlineRed.withValues(alpha: compact ? 0.11 : 0.15),
            Colors.white.withValues(alpha: 0.035),
          ],
          stops: const [0.0, 0.38, 0.68, 1.0],
        ).createShader(rect),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.01),
      routeSideAngle - math.pi * 0.13,
      math.pi * 0.34,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 1.8 : 2.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.airlineRed.withValues(alpha: compact ? 0.085 : 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );
  }

  void _drawSphere(Canvas canvas, Rect rect, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.42, -0.48),
          radius: 1.06,
          colors: const [
            Color(0xFF385674),
            Color(0xFF173553),
            Color(0xFF071B2E),
            Color(0xFF02050B),
          ],
          stops: const [0.0, 0.32, 0.70, 1.0],
        ).createShader(rect),
    );

    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.31),
      radius * 0.58,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                const Color(
                  0xFFD9F0FF,
                ).withValues(alpha: compact ? 0.105 : 0.145),
                Colors.white.withValues(alpha: 0.00),
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(
                  center.dx - radius * 0.25,
                  center.dy - radius * 0.31,
                ),
                radius: radius * 0.58,
              ),
            ),
    );

    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy + radius * 0.14),
      radius * 0.88,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.black.withValues(alpha: 0.00),
                Colors.black.withValues(alpha: 0.32),
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(
                  center.dx + radius * 0.45,
                  center.dy + radius * 0.14,
                ),
                radius: radius * 0.88,
              ),
            ),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.26, 0.30),
          radius: 0.92,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: compact ? 0.10 : 0.13),
            Colors.black.withValues(alpha: compact ? 0.24 : 0.30),
          ],
          stops: const [0.50, 0.78, 1.0],
        ).createShader(rect),
    );
  }

  void _drawOceanSurface(
    Canvas canvas,
    Rect rect,
    Offset center,
    double radius,
  ) {
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.045),
            Colors.transparent,
            AppColors.airlineRed.withValues(alpha: 0.040),
          ],
        ).createShader(rect),
    );

    final dotPaint = Paint()
      ..color = const Color(
        0xFFC8E9F8,
      ).withValues(alpha: compact ? 0.014 : 0.021);
    for (var i = 0; i < 46; i++) {
      final angle = i * 2.3999632297;
      final distance = radius * (0.16 + ((i * 37) % 72) / 100);
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      if ((point - center).distance < radius * 0.92) {
        canvas.drawCircle(point, compact ? 0.38 : 0.56, dotPaint);
      }
    }

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.45 : 0.6
      ..color = const Color(
        0xFF9CC7DF,
      ).withValues(alpha: compact ? 0.030 : 0.045)
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 5; i++) {
      final inset = radius * (0.22 + i * 0.105);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - inset),
        -math.pi * (0.95 - i * 0.06),
        math.pi * 0.34,
        false,
        arcPaint,
      );
    }
  }

  void _drawOceanCurrentBands(Canvas canvas) {
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.34 : 0.48
      ..strokeCap = StrokeCap.round;

    for (final group in geometry.currentGroups) {
      final baseColor = const Color(
        0xFFB7DFF0,
      ).withValues(alpha: compact ? 0.030 : 0.044);
      for (final segment in group.segments) {
        bandPaint.color = baseColor.withValues(
          alpha: baseColor.a * segment.alphaMultiplier,
        );
        canvas.drawLine(segment.p1, segment.p2, bandPaint);
      }
    }
  }

  void _drawContinents(Canvas canvas, Rect globeRect) {
    final landShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: compact ? 0.16 : 0.20)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.8);
    final landHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: compact ? 0.030 : 0.045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 1.10 : 1.45
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final entry in geometry.continentPaths) {
      final path = entry.value;
      final region = entry.key;
      final landPaint = _landPaintFor(region, globeRect);
      final coastPaint = _coastPaintFor(region);
      canvas.drawPath(
        path.shift(Offset(0, compact ? 0.45 : 0.65)),
        landShadowPaint,
      );
      canvas.drawPath(path, landPaint);
      canvas.drawPath(path, landHighlightPaint);
      canvas.drawPath(path, coastPaint);
    }
  }

  Paint _landPaintFor(GlobeRegion region, Rect globeRect) {
    final routeRegionBoost =
        isDomestic &&
        (region == GlobeRegion.europe ||
            region == GlobeRegion.middleEast ||
            region == GlobeRegion.turkey);
    final alphaBoost = routeRegionBoost ? 1.16 : 1.0;
    final base = switch (region) {
      GlobeRegion.europe => const Color(0xFFA9C2CF),
      GlobeRegion.asia => const Color(0xFF9AB4C1),
      GlobeRegion.africa => const Color(0xFF91ABBA),
      GlobeRegion.northAmerica => const Color(0xFFA5BEC9),
      GlobeRegion.southAmerica => const Color(0xFF94AFBD),
      GlobeRegion.middleEast => const Color(0xFFA2BCC8),
      GlobeRegion.turkey => const Color(0xFFA9C4D0),
      GlobeRegion.polar => const Color(0xFFBACBD2),
      GlobeRegion.oceania => const Color(0xFF8FAAB7),
    };
    final topAlpha = (compact ? 0.25 : 0.32) * alphaBoost;
    final midAlpha = (compact ? 0.18 : 0.24) * alphaBoost;
    final lowAlpha = (compact ? 0.13 : 0.18) * alphaBoost;

    return Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(base, Colors.white, 0.18)!.withValues(alpha: topAlpha),
          base.withValues(alpha: midAlpha),
          Color.lerp(base, Colors.black, 0.22)!.withValues(alpha: lowAlpha),
        ],
        stops: const [0.0, 0.52, 1.0],
      ).createShader(globeRect)
      ..style = PaintingStyle.fill;
  }

  Paint _coastPaintFor(GlobeRegion region) {
    final routeRegionBoost =
        isDomestic &&
        (region == GlobeRegion.europe || region == GlobeRegion.middleEast);
    final alpha = switch (region) {
      GlobeRegion.polar => compact ? 0.12 : 0.16,
      GlobeRegion.europe || GlobeRegion.middleEast =>
        (compact ? 0.22 : 0.29) * (routeRegionBoost ? 1.12 : 1.0),
      _ => compact ? 0.18 : 0.25,
    };

    return Paint()
      ..color = const Color(0xFFD2E7EF).withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.46 : 0.62
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
  }

  Paint _borderPaintFor(GlobeRegion region) {
    final routeRegionBoost =
        isDomestic &&
        (region == GlobeRegion.europe ||
            region == GlobeRegion.middleEast ||
            region == GlobeRegion.turkey);
    final baseAlpha = switch (region) {
      GlobeRegion.turkey => compact ? 0.18 : 0.25,
      GlobeRegion.europe || GlobeRegion.middleEast => compact ? 0.145 : 0.205,
      GlobeRegion.polar => compact ? 0.075 : 0.10,
      _ => compact ? 0.115 : 0.165,
    };

    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.42 : 0.58
      ..color = const Color(
        0xFFD3E6F0,
      ).withValues(alpha: baseAlpha * (routeRegionBoost ? 1.12 : 1.0))
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  void _drawTurkeyFocus(Canvas canvas) {
    if (!isDomestic) return;
    final path = geometry.turkeyFocusPath;
    if (path == null) return;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.airlineRed.withValues(
          alpha: compact ? 0.055 : 0.070,
        ),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 0.56 : 0.72
        ..color = AppColors.softRed.withValues(alpha: compact ? 0.18 : 0.24),
    );
  }

  void _drawCountryBorders(Canvas canvas) {
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final group in geometry.borderGroups) {
      final baseColor = _borderPaintFor(group.region).color;
      borderPaint.strokeWidth = compact ? 0.42 : 0.58;
      for (final segment in group.segments) {
        borderPaint.color = baseColor.withValues(
          alpha: baseColor.a * segment.alphaMultiplier,
        );
        canvas.drawLine(segment.p1, segment.p2, borderPaint);
      }
    }
  }

  void _drawGrid(Canvas canvas) {
    final minorGridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.34 : 0.46
      ..strokeCap = StrokeCap.round;
    final majorGridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.42 : 0.58
      ..strokeCap = StrokeCap.round;

    for (final group in geometry.gridGroups) {
      final baseColor = const Color(0xFFD8F1FF).withValues(
        alpha: group.isMajor
            ? (compact ? 0.038 : 0.052)
            : (compact ? 0.024 : 0.034),
      );
      final activePaint = group.isMajor ? majorGridPaint : minorGridPaint;
      for (final segment in group.segments) {
        activePaint.color = baseColor.withValues(
          alpha: baseColor.a * segment.alphaMultiplier,
        );
        canvas.drawLine(segment.p1, segment.p2, activePaint);
      }
    }
  }

  void _drawRouteIllumination(
    Canvas canvas,
    Offset fromPoint,
    Offset toPoint,
    double radius,
  ) {
    final mid = Offset(
      (fromPoint.dx + toPoint.dx) / 2,
      (fromPoint.dy + toPoint.dy) / 2,
    );
    canvas.drawCircle(
      mid,
      radius * (isDomestic ? 0.34 : 0.42),
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.airlineRed.withValues(alpha: compact ? 0.040 : 0.055),
                const Color(
                  0xFF6CA9D6,
                ).withValues(alpha: compact ? 0.026 : 0.036),
                Colors.transparent,
              ],
              stops: const [0.0, 0.46, 1.0],
            ).createShader(
              Rect.fromCircle(
                center: mid,
                radius: radius * (isDomestic ? 0.34 : 0.42),
              ),
            ),
    );
  }

  void _drawTerminator(Canvas canvas, Rect rect, Offset center, double radius) {
    canvas.drawOval(
      Rect.fromLTWH(
        rect.left + rect.width * 0.33,
        rect.top - rect.height * 0.03,
        rect.width * 0.80,
        rect.height * 1.06,
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: compact ? 0.10 : 0.12),
            Colors.black.withValues(alpha: compact ? 0.38 : 0.46),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(rect),
    );
    final lowerRight = Offset(
      center.dx + radius * 0.38,
      center.dy + radius * 0.42,
    );
    canvas.drawCircle(
      lowerRight,
      radius * 0.86,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.black.withValues(alpha: compact ? 0.18 : 0.24),
                Colors.black.withValues(alpha: compact ? 0.08 : 0.12),
                Colors.transparent,
              ],
              stops: const [0.0, 0.58, 1.0],
            ).createShader(
              Rect.fromCircle(center: lowerRight, radius: radius * 0.86),
            ),
    );
  }

  void _drawHorizonFade(
    Canvas canvas,
    Rect rect,
    Offset center,
    double radius,
  ) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF061321).withValues(alpha: compact ? 0.05 : 0.07),
            Colors.black.withValues(alpha: compact ? 0.20 : 0.26),
          ],
          stops: const [0.64, 0.83, 1.0],
        ).createShader(rect),
    );
  }

  void _drawSpecularHighlight(Canvas canvas, Offset center, double radius) {
    final highlightCenter = Offset(
      center.dx - radius * 0.24,
      center.dy - radius * 0.34,
    );
    canvas.save();
    canvas.translate(highlightCenter.dx, highlightCenter.dy);
    canvas.rotate(-0.34);
    final highlightRect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 0.92,
      height: radius * 0.30,
    );
    canvas.drawOval(
      highlightRect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE5F7FF).withValues(alpha: compact ? 0.10 : 0.14),
            const Color(0xFFB7DFF0).withValues(alpha: compact ? 0.035 : 0.052),
            Colors.transparent,
          ],
          stops: const [0.0, 0.48, 1.0],
        ).createShader(highlightRect),
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(-radius * 0.06, -radius * 0.015),
        width: radius * 0.72,
        height: radius * 0.18,
      ),
      math.pi * 1.05,
      math.pi * 0.45,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 0.55 : 0.75
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: compact ? 0.050 : 0.075),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(StaticGlobePainter old) {
    return old.geometry != geometry ||
        old.compact != compact ||
        old.highQuality != highQuality ||
        old.isDomestic != isDomestic;
  }
}

/// Animated overlay painter for the route, plane, endpoint nodes, and code pills.
class GlobeRouteOverlayPainter extends CustomPainter {
  const GlobeRouteOverlayPainter({
    required this.geometry,
    required this.route,
    required this.planeProgress,
    required this.routeDrawProgress,
    required this.fadeProgress,
    required this.arrivalPulse,
    required this.compact,
    required this.playOnce,
    required this.highQuality,
  });

  final GlobeRouteGeometry geometry;
  final GlobeRouteData route;
  final double planeProgress;
  final double routeDrawProgress;
  final double fadeProgress;
  final double arrivalPulse;
  final bool compact;
  final bool playOnce;
  final bool highQuality;

  @override
  void paint(Canvas canvas, Size size) {
    final eased = planeProgress.clamp(0.0, 1.0);
    final drawProgress = math.max(routeDrawProgress, eased).clamp(0.0, 1.0);
    final fade = fadeProgress * (playOnce ? 1.0 : _edgeFade(eased));
    final curve = geometry.curve;

    final plane = _cubic(
      eased,
      curve.from,
      curve.control1,
      curve.control2,
      curve.to,
    );
    final tangent = _stableCubicTangent(
      eased,
      curve.from,
      curve.control1,
      curve.control2,
      curve.to,
    );
    final angle = math.atan2(tangent.dy, tangent.dx);
    final tangentLength = tangent.distance;
    final planeLift = tangentLength <= 0
        ? Offset.zero
        : Offset(-tangent.dy / tangentLength, tangent.dx / tangentLength) *
              math.min(2.8, geometry.planeSize * 0.12);
    final planeCenter = plane + planeLift;

    _drawRouteSegments(canvas, curve, eased, drawProgress, fade);
    _drawEndpointAnnotations(canvas, fadeProgress.clamp(0.0, 1.0));
    _drawPlaneTrail(canvas, curve, eased, fade);

    if (fade > 0.02) {
      PremiumPlaneMarkerPainter.paintMarker(
        canvas,
        center: planeCenter,
        rotation: angle,
        size: geometry.planeSize,
        variant: compact ? PlaneMarkerVariant.route : PlaneMarkerVariant.hero,
        color: AppColors.softRed,
        glowColor: AppColors.airlineRed,
        glow: true,
        pulse: !compact && highQuality,
        progress: planeProgress,
      );
    }
  }

  void _drawPlaneTrail(
    Canvas canvas,
    RouteCurve curve,
    double planeProgress,
    double fade,
  ) {
    if (fade <= 0.02 || planeProgress <= 0.08) return;

    const samples = 5;
    for (var i = 0; i < samples; i++) {
      final sampleT = (planeProgress - (i + 1) * 0.020)
          .clamp(0.0, 1.0)
          .toDouble();
      final point = _cubic(
        sampleT,
        curve.from,
        curve.control1,
        curve.control2,
        curve.to,
      );
      final alpha = fade * (0.10 - i * 0.014);
      if (alpha <= 0) continue;

      canvas.drawCircle(
        point,
        math.max(0.65, geometry.routeStrokeWidth * (1.25 - i * 0.10)),
        Paint()..color = AppColors.softRed.withValues(alpha: alpha),
      );
    }
  }

  void _drawEndpointAnnotations(Canvas canvas, double opacity) {
    final nodeOpacity = math.max(0.72, opacity);
    _drawNode(
      canvas,
      geometry.curve.from,
      nodeOpacity,
      false,
      geometry.nodeSize,
    );
    _drawNode(canvas, geometry.curve.to, nodeOpacity, true, geometry.nodeSize);

    if (playOnce && arrivalPulse > 0.02) {
      canvas.drawCircle(
        geometry.curve.to,
        geometry.nodeSize * (2.0 + arrivalPulse * 0.9),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.85, geometry.routeStrokeWidth * 0.36)
          ..color = AppColors.softRed.withValues(alpha: 0.18 * arrivalPulse),
      );
    }

    _drawEndpointCode(
      canvas,
      node: geometry.curve.from,
      code: route.fromCode,
      globeCenter: geometry.center,
      arrival: false,
      opacity: nodeOpacity,
      labelFontSize: geometry.labelFontSize,
      labelOffset: geometry.labelOffset,
    );
    _drawEndpointCode(
      canvas,
      node: geometry.curve.to,
      code: route.toCode,
      globeCenter: geometry.center,
      arrival: true,
      opacity: nodeOpacity,
      labelFontSize: geometry.labelFontSize,
      labelOffset: geometry.labelOffset,
    );
  }

  void _drawRouteSegments(
    Canvas canvas,
    RouteCurve curve,
    double planeProgress,
    double drawProgress,
    double fade,
  ) {
    final ghostPaint = Paint()
      ..color = Colors.white.withValues(alpha: compact ? 0.075 : 0.095)
      ..strokeWidth =
          geometry.routeStrokeWidth *
          0.30 // proportional ghost line
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // A single blurred route glow stroke to maintain the premium aesthetics cheaply
    final glowPaint = Paint()
      ..color = AppColors.airlineRed.withValues(alpha: 0.11 * fade)
      ..strokeWidth =
          geometry.routeStrokeWidth *
          1.45 // proportional glow
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    _sampleRoute(canvas, curve, 0, 1, ghostPaint, dashed: true);
    _sampleRoute(canvas, curve, 0, drawProgress, glowPaint);
    _sampleRouteGradient(canvas, curve, 0, planeProgress, fade);
  }

  void _sampleRoute(
    Canvas canvas,
    RouteCurve curve,
    double start,
    double end,
    Paint paint, {
    bool dashed = false,
    Offset offset = Offset.zero,
  }) {
    const steps = 60;
    final startStep = (start * steps).floor();
    final endStep = (end * steps).ceil().clamp(startStep + 1, steps);
    for (var i = startStep; i < endStep; i++) {
      if (dashed && i % 5 == 3) continue;
      final a = (i / steps).clamp(start, end);
      final b = ((i + 1) / steps).clamp(start, end);
      canvas.drawLine(
        _cubic(a, curve.from, curve.control1, curve.control2, curve.to) +
            offset,
        _cubic(b, curve.from, curve.control1, curve.control2, curve.to) +
            offset,
        paint,
      );
    }
  }

  void _sampleRouteGradient(
    Canvas canvas,
    RouteCurve curve,
    double start,
    double end,
    double fade,
  ) {
    if (end <= start || fade <= 0) return;
    const steps = 60;
    final startStep = (start * steps).floor();
    final endStep = (end * steps).ceil().clamp(startStep + 1, steps);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = geometry.routeStrokeWidth;

    for (var i = startStep; i < endStep; i++) {
      final a = (i / steps).clamp(start, end);
      final b = ((i + 1) / steps).clamp(start, end);
      final local = end == 0 ? 0.0 : (b / end).clamp(0.0, 1.0);
      paint.color = Color.lerp(
        AppColors.airlineRed,
        Colors.white,
        0.10 + local * 0.16,
      )!.withValues(alpha: 0.68 * fade);
      canvas.drawLine(
        _cubic(a, curve.from, curve.control1, curve.control2, curve.to),
        _cubic(b, curve.from, curve.control1, curve.control2, curve.to),
        paint,
      );
    }
  }

  Offset _cubic(double t, Offset p0, Offset p1, Offset p2, Offset p3) {
    final u = 1 - t;
    return Offset(
      u * u * u * p0.dx +
          3 * u * u * t * p1.dx +
          3 * u * t * t * p2.dx +
          t * t * t * p3.dx,
      u * u * u * p0.dy +
          3 * u * u * t * p1.dy +
          3 * u * t * t * p2.dy +
          t * t * t * p3.dy,
    );
  }

  Offset _cubicTangent(double t, Offset p0, Offset p1, Offset p2, Offset p3) {
    final u = 1 - t;
    return Offset(
      3 * u * u * (p1.dx - p0.dx) +
          6 * u * t * (p2.dx - p1.dx) +
          3 * t * t * (p3.dx - p2.dx),
      3 * u * u * (p1.dy - p0.dy) +
          6 * u * t * (p2.dy - p1.dy) +
          3 * t * t * (p3.dy - p2.dy),
    );
  }

  Offset _stableCubicTangent(
    double t,
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
  ) {
    final clamped = t.clamp(0.02, 0.98);
    var tangent = _cubicTangent(clamped, p0, p1, p2, p3);
    if (tangent.distance < 0.001) {
      tangent = p3 - p0;
    }
    if ((tangent.dx * (p3.dx - p0.dx) + tangent.dy * (p3.dy - p0.dy)) < 0) {
      tangent = -tangent;
    }
    return tangent;
  }

  double _edgeFade(double value) {
    final start = Curves.easeOut.transform((value / 0.10).clamp(0.0, 1.0));
    final end = Curves.easeIn.transform(((1 - value) / 0.14).clamp(0.0, 1.0));
    return math.min(start, end);
  }

  @override
  bool shouldRepaint(GlobeRouteOverlayPainter old) {
    return old.geometry != geometry ||
        old.planeProgress != planeProgress ||
        old.routeDrawProgress != routeDrawProgress ||
        old.fadeProgress != fadeProgress ||
        old.arrivalPulse != arrivalPulse ||
        old.compact != compact ||
        old.playOnce != playOnce ||
        old.highQuality != highQuality;
  }
}

@Deprecated('Use GlobeRouteOverlayPainter for new route overlay code.')
class AnimatedGlobeRoutePainter extends GlobeRouteOverlayPainter {
  const AnimatedGlobeRoutePainter({
    required super.geometry,
    required super.route,
    required super.planeProgress,
    required super.routeDrawProgress,
    required super.fadeProgress,
    required super.arrivalPulse,
    required super.compact,
    required super.playOnce,
    required super.highQuality,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// File-level static drawing helpers for Globe Node elements (Visual Scale Fixes)
// ─────────────────────────────────────────────────────────────────────────────

void _drawNode(
  Canvas canvas,
  Offset center,
  double value,
  bool arrival,
  double nodeSize,
) {
  canvas.drawCircle(
    center,
    nodeSize + 2.9,
    Paint()..color = AppColors.airlineRed.withValues(alpha: 0.065 * value),
  );
  canvas.drawCircle(
    center,
    nodeSize + 1.2,
    Paint()..color = Colors.black.withValues(alpha: 0.24),
  );
  canvas.drawCircle(
    center,
    nodeSize,
    Paint()..color = Colors.white.withValues(alpha: 0.34),
  );
  canvas.drawCircle(
    center,
    nodeSize * 0.56,
    Paint()..color = AppColors.softRed.withValues(alpha: 0.92),
  );
}

void _drawEndpointCode(
  Canvas canvas, {
  required Offset node,
  required String code,
  required Offset globeCenter,
  required bool arrival,
  required double opacity,
  required double labelFontSize,
  required double labelOffset,
}) {
  if (opacity <= 0.02) return;

  final vector = node - globeCenter;
  final distance = vector.distance;
  final direction = distance > 1
      ? vector / distance
      : Offset(arrival ? 1 : -1, -0.25);
  final anchor = node + direction * labelOffset;
  final width = math.max(labelFontSize * 3.75, 44.0);
  final height = labelFontSize * 1.58;
  final rect = Rect.fromCenter(center: anchor, width: width, height: height);
  final radius = Radius.circular(height / 2);

  canvas.drawRRect(
    RRect.fromRectAndRadius(rect.shift(Offset(0, 1.0)), radius),
    Paint()
      ..color = Colors.black.withValues(alpha: 0.26 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0),
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(rect, radius),
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0B1C2D).withValues(alpha: 0.72 * opacity),
          const Color(0xFF020712).withValues(alpha: 0.66 * opacity),
        ],
      ).createShader(rect),
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(rect.deflate(0.45), radius),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.65
      ..color = (arrival ? AppColors.softRed : const Color(0xFFD5ECF7))
          .withValues(alpha: (arrival ? 0.42 : 0.24) * opacity),
  );

  final textPainter = TextPainter(
    text: TextSpan(
      text: code.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.88 * opacity),
        fontSize: labelFontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: width - 4);
  textPainter.paint(
    canvas,
    Offset(
      rect.center.dx - textPainter.width / 2,
      rect.center.dy - textPainter.height / 2,
    ),
  );
}
