import 'dart:math' as math;
import 'dart:ui';

import 'airport_coordinates.dart';
import 'world_map_data.dart';
import 'world_projection.dart';

enum GlobeRouteSize { compact, medium, large, hero }

class GlobeRouteData {
  const GlobeRouteData({
    required this.fromCode,
    required this.toCode,
    required this.fromCity,
    required this.toCity,
    required this.fromAirportName,
    required this.toAirportName,
    required this.isDomestic,
  });

  final String fromCode;
  final String toCode;
  final String fromCity;
  final String toCity;
  final String fromAirportName;
  final String toAirportName;
  final bool isDomestic;

  @override
  bool operator ==(Object other) {
    return other is GlobeRouteData &&
        other.fromCode == fromCode &&
        other.toCode == toCode &&
        other.fromCity == fromCity &&
        other.toCity == toCity &&
        other.fromAirportName == fromAirportName &&
        other.toAirportName == toAirportName &&
        other.isDomestic == isDomestic;
  }

  @override
  int get hashCode => Object.hash(
    fromCode,
    toCode,
    fromCity,
    toCity,
    fromAirportName,
    toAirportName,
    isDomestic,
  );
}

class RouteCurve {
  const RouteCurve({
    required this.from,
    required this.control1,
    required this.control2,
    required this.to,
    required this.distanceKm,
  });

  final Offset from;
  final Offset control1;
  final Offset control2;
  final Offset to;
  final double distanceKm;
}

class ProjectedLineSegment {
  const ProjectedLineSegment(this.p1, this.p2, this.alphaMultiplier);
  final Offset p1;
  final Offset p2;
  final double alphaMultiplier;
}

class ProjectedBorderGroup {
  const ProjectedBorderGroup(this.region, this.segments);
  final GlobeRegion region;
  final List<ProjectedLineSegment> segments;
}

class ProjectedGridGroup {
  const ProjectedGridGroup(this.isMajor, this.segments);
  final bool isMajor;
  final List<ProjectedLineSegment> segments;
}

class ProjectedCurrentGroup {
  const ProjectedCurrentGroup(this.segments);
  final List<ProjectedLineSegment> segments;
}

class GlobeRouteGeometry {
  const GlobeRouteGeometry({
    required this.center,
    required this.radius,
    required this.globeRect,
    required this.globePath,
    required this.viewCenterLat,
    required this.viewCenterLng,
    required this.routeSideAngle,
    required this.fromPoint,
    required this.toPoint,
    required this.curve,
    required this.continentPaths,
    required this.borderGroups,
    required this.gridGroups,
    required this.currentGroups,
    required this.turkeyFocusPath,
    required this.planeSize,
    required this.nodeSize,
    required this.labelFontSize,
    required this.labelOffset,
    required this.routeStrokeWidth,
    required this.successCheckSize,
  });

  final Offset center;
  final double radius;
  final Rect globeRect;
  final Path globePath;
  final double viewCenterLat;
  final double viewCenterLng;
  final double routeSideAngle;
  final Offset fromPoint;
  final Offset toPoint;
  final RouteCurve curve;
  final List<MapEntry<GlobeRegion, Path>> continentPaths;
  final List<ProjectedBorderGroup> borderGroups;
  final List<ProjectedGridGroup> gridGroups;
  final List<ProjectedCurrentGroup> currentGroups;
  final Path? turkeyFocusPath;

  // Sizing configurations computed per resolution size preset
  final double planeSize;
  final double nodeSize;
  final double labelFontSize;
  final double labelOffset;
  final double routeStrokeWidth;
  final double successCheckSize;
}

class GlobeGeometryBuilder {
  static GlobeRouteGeometry build({
    required Size size,
    required GlobeRouteData route,
    required GlobeRouteSize sizePreset,
    required bool reserveLabelSpace,
    required bool highQuality,
    required bool reduceBorders,
  }) {
    // 1. Calculate dimensions based on GlobeRouteSize preset
    final labelSpace = reserveLabelSpace ? 42.0 : 0.0;
    final globeHeight = math.max(24.0, size.height - labelSpace);

    final isCompact = sizePreset == GlobeRouteSize.compact;
    final isMedium = sizePreset == GlobeRouteSize.medium;

    final globeSize = math.min(
      size.width * (isCompact ? 0.94 : (isMedium ? 0.92 : 0.90)),
      globeHeight * (isCompact ? 1.02 : (isMedium ? 0.98 : 0.94)),
    );
    final radius = globeSize / 2;
    final center = Offset(
      size.width / 2,
      globeHeight * (isCompact ? 0.47 : 0.46),
    );
    final globeRect = Rect.fromCircle(center: center, radius: radius);
    final globePath = Path()..addOval(globeRect);

    // 2. Resolve parameters based on preset & Task 1 and Task 2 sizing rules
    final double nodeSize;
    final double labelFontSize;
    final double labelOffset;
    final double routeStrokeWidth;
    final double successCheckSize;
    final double planeSize;

    switch (sizePreset) {
      case GlobeRouteSize.compact:
        planeSize = _clampDouble(radius * 0.18, 14.0, 16.0);
        nodeSize = 3.6;
        labelFontSize = 10.5;
        labelOffset = 20.0;
        routeStrokeWidth = 1.45;
        successCheckSize = 34.0;
        break;
      case GlobeRouteSize.medium:
        planeSize = _clampDouble(radius * 0.17, 18.0, 20.0);
        nodeSize = 4.4;
        labelFontSize = 12.0;
        labelOffset = 24.0;
        routeStrokeWidth = 1.95;
        successCheckSize = 38.0;
        break;
      case GlobeRouteSize.large:
        planeSize = _clampDouble(radius * 0.165, 22.0, 24.0);
        nodeSize = 5.0;
        labelFontSize = 13.5;
        labelOffset = 29.0;
        routeStrokeWidth = 2.25;
        successCheckSize = 42.0;
        break;
      case GlobeRouteSize.hero:
        planeSize = _clampDouble(radius * 0.160, 24.0, 28.0);
        nodeSize = 5.8;
        labelFontSize = 15.0;
        labelOffset = 33.0;
        routeStrokeWidth = 2.55;
        successCheckSize = 46.0;
        break;
    }

    // 3. Projections
    final fromAirport = AirportCoordinates.forCode(
      route.fromCode,
      isOrigin: true,
    );
    final toAirport = AirportCoordinates.forCode(route.toCode, isOrigin: false);
    final orientation = GlobeViewOrientation.forRoute(
      from: fromAirport.point,
      to: toAirport.point,
      isDomestic: route.isDomestic,
    );
    final projection = GlobeProjection(
      centerLat: orientation.centerLat,
      centerLng: orientation.centerLng,
      radius: radius,
      center: center,
    );

    final fromPoint =
        projection.project(fromAirport.point)?.offset ??
        projection.projectToVisibleEdge(fromAirport.point);
    final toPoint =
        projection.project(toAirport.point)?.offset ??
        projection.projectToVisibleEdge(toAirport.point);

    // 4. Side angle
    final midpoint = Offset(
      (fromPoint.dx + toPoint.dx) / 2,
      (fromPoint.dy + toPoint.dy) / 2,
    );
    final vector = midpoint - center;
    final routeSideAngle = vector.distance < 1
        ? -math.pi * 0.12
        : math.atan2(vector.dy, vector.dx);

    // 5. Route Curve with Exaggeration for short/domestic routes to avoid overlap (Task 4)
    final chord = toPoint - fromPoint;
    final distance = math.max(chord.distance, 1.0);
    var normal = Offset(-chord.dy / distance, chord.dx / distance);
    if (normal.dy > -0.12) normal = -normal;

    final routeDistance = globeDistanceKm(fromAirport.point, toAirport.point);
    final screenFactor = (distance / (radius * 1.8)).clamp(0.0, 1.0);
    final distanceFactor = (routeDistance / 9600).clamp(0.0, 1.0);

    final double lift;
    if (route.isDomestic || routeDistance < 1500) {
      // Gracefully curved arc with visual breathing room for domestic / short routes
      lift = radius * (0.24 + (1.0 - screenFactor) * 0.12);
    } else {
      lift = radius * (0.18 + distanceFactor * 0.20 + screenFactor * 0.05);
    }

    final sideBend = radius * 0.055 * distanceFactor;
    final side = Offset(chord.dx / distance, chord.dy / distance);
    final bendDirection =
        normalizeLongitude(toAirport.point.lng - fromAirport.point.lng) >= 0
        ? 1.0
        : -1.0;

    final control1 =
        Offset.lerp(fromPoint, toPoint, 0.32)! +
        normal * lift * 0.88 +
        side * sideBend * bendDirection;
    final control2 =
        Offset.lerp(fromPoint, toPoint, 0.68)! +
        normal * lift * 1.08 -
        side * sideBend * bendDirection;

    final curve = RouteCurve(
      from: fromPoint,
      control1: control1,
      control2: control2,
      to: toPoint,
      distanceKm: routeDistance,
    );

    // 6. Continents
    final continentPaths = <MapEntry<GlobeRegion, Path>>[];
    for (final continent in WorldMapData.continents) {
      final path = _projectedPolygonPath(projection, continent.points);
      if (path != null) {
        continentPaths.add(MapEntry(continent.region, path));
      }
    }

    // 7. Country borders
    final borderGroups = <ProjectedBorderGroup>[];
    final skipBorders = !highQuality;
    if (!skipBorders) {
      final step = (isCompact || isMedium || reduceBorders) ? 8 : 1;
      for (var k = 0; k < WorldMapData.countryBorders.length; k += step) {
        final border = WorldMapData.countryBorders[k];
        final segments = <ProjectedLineSegment>[];
        for (var i = 0; i < border.points.length - 1; i++) {
          final start = projection.project(border.points[i]);
          final end = projection.project(border.points[i + 1]);
          if (start == null || end == null) continue;
          final fade = math.min(start.edgeFade, end.edgeFade);
          if (fade < 0.18) continue;
          segments.add(ProjectedLineSegment(start.offset, end.offset, fade));
        }
        if (segments.isNotEmpty) {
          borderGroups.add(ProjectedBorderGroup(border.region, segments));
        }
      }
    }

    // 8. Grid Lines
    final gridGroups = <ProjectedGridGroup>[];
    final showFullGrid =
        highQuality && !isCompact && !isMedium && !reduceBorders;
    final lats = showFullGrid
        ? [-66.0, -45.0, -25.0, -10.0, 10.0, 25.0, 45.0, 66.0]
        : [-45.0, 0.0, 45.0];
    final lngs = showFullGrid
        ? [
            -150.0,
            -120.0,
            -90.0,
            -60.0,
            -30.0,
            0.0,
            30.0,
            60.0,
            90.0,
            120.0,
            150.0,
          ]
        : [-90.0, 0.0, 90.0];

    // Draw lat lines
    for (final lat in lats) {
      final segments = <ProjectedLineSegment>[];
      final step = (isCompact || isMedium || reduceBorders) ? 8.0 : 4.0;
      for (var lng = -180.0; lng <= 180.0; lng += step) {
        final start = projection.project(GlobeGeoPoint(lat, lng));
        final end = projection.project(GlobeGeoPoint(lat, lng + step));
        if (start == null || end == null) continue;
        final fade = math.min(start.edgeFade, end.edgeFade);
        if (fade < 0.34) continue;
        segments.add(ProjectedLineSegment(start.offset, end.offset, fade));
      }
      if (segments.isNotEmpty) {
        gridGroups.add(ProjectedGridGroup(false, segments));
      }
    }

    // Draw equator
    if (highQuality) {
      final segments = <ProjectedLineSegment>[];
      final step = (isCompact || isMedium || reduceBorders) ? 8.0 : 4.0;
      for (var lng = -180.0; lng <= 180.0; lng += step) {
        final start = projection.project(GlobeGeoPoint(0, lng));
        final end = projection.project(GlobeGeoPoint(0, lng + step));
        if (start == null || end == null) continue;
        final fade = math.min(start.edgeFade, end.edgeFade);
        if (fade < 0.36) continue;
        segments.add(ProjectedLineSegment(start.offset, end.offset, fade));
      }
      if (segments.isNotEmpty) {
        gridGroups.add(ProjectedGridGroup(true, segments));
      }
    }

    // Draw lng lines
    for (final lng in lngs) {
      final segments = <ProjectedLineSegment>[];
      final step = (isCompact || isMedium || reduceBorders) ? 10.0 : 5.0;
      for (var lat = -78.0; lat <= 78.0; lat += step) {
        final start = projection.project(GlobeGeoPoint(lat, lng));
        final end = projection.project(GlobeGeoPoint(lat + step, lng));
        if (start == null || end == null) continue;
        final fade = math.min(start.edgeFade, end.edgeFade);
        if (fade < 0.34) continue;
        segments.add(ProjectedLineSegment(start.offset, end.offset, fade));
      }
      if (segments.isNotEmpty) {
        gridGroups.add(ProjectedGridGroup(lng == 0.0, segments));
      }
    }

    // 9. Ocean currents
    final currentGroups = <ProjectedCurrentGroup>[];
    if (highQuality && !isCompact && !isMedium) {
      final bands = [
        [
          for (var lng = -70.0; lng <= 35.0; lng += 5)
            GlobeGeoPoint(31 + math.sin((lng + 70) / 18) * 4, lng),
        ],
        [
          for (var lng = -45.0; lng <= 65.0; lng += 5)
            GlobeGeoPoint(8 + math.sin((lng + 15) / 16) * 3, lng),
        ],
        [
          for (var lng = 42.0; lng <= 150.0; lng += 5)
            GlobeGeoPoint(24 + math.sin((lng - 42) / 15) * 3.5, lng),
        ],
        [
          for (var lng = -130.0; lng <= -55.0; lng += 5)
            GlobeGeoPoint(28 + math.sin((lng + 130) / 12) * 3, lng),
        ],
      ];
      for (final band in bands) {
        final segments = <ProjectedLineSegment>[];
        for (var i = 0; i < band.length - 1; i++) {
          final start = projection.project(band[i]);
          final end = projection.project(band[i + 1]);
          if (start == null || end == null) continue;
          final fade = math.min(start.edgeFade, end.edgeFade);
          if (fade < 0.30) continue;
          segments.add(ProjectedLineSegment(start.offset, end.offset, fade));
        }
        if (segments.isNotEmpty) {
          currentGroups.add(ProjectedCurrentGroup(segments));
        }
      }
    }

    // 10. Turkey focus
    Path? turkeyFocusPath;
    final startsInTurkey = switch (route.fromCode.toUpperCase()) {
      'IST' || 'SAW' || 'ESB' || 'ADB' || 'AYT' || 'TZX' || 'ASR' => true,
      _ => false,
    };
    if (startsInTurkey) {
      turkeyFocusPath = _projectedPolygonPath(
        projection,
        WorldMapData.turkeyRegion.points,
      );
    }

    return GlobeRouteGeometry(
      center: center,
      radius: radius,
      globeRect: globeRect,
      globePath: globePath,
      viewCenterLat: orientation.centerLat,
      viewCenterLng: orientation.centerLng,
      routeSideAngle: routeSideAngle,
      fromPoint: fromPoint,
      toPoint: toPoint,
      curve: curve,
      continentPaths: continentPaths,
      borderGroups: borderGroups,
      gridGroups: gridGroups,
      currentGroups: currentGroups,
      turkeyFocusPath: turkeyFocusPath,
      planeSize: planeSize,
      nodeSize: nodeSize,
      labelFontSize: labelFontSize,
      labelOffset: labelOffset,
      routeStrokeWidth: routeStrokeWidth,
      successCheckSize: successCheckSize,
    );
  }

  static Path? _projectedPolygonPath(
    GlobeProjection projection,
    List<GlobeGeoPoint> points,
  ) {
    final projected = <Offset>[];
    for (final point in points) {
      final result = projection.project(point);
      if (result != null && result.edgeFade > 0.08) {
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
}

double _clampDouble(double value, double lowerLimit, double upperLimit) {
  return value.clamp(lowerLimit, upperLimit).toDouble();
}
