import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlobeGeoPoint {
  const GlobeGeoPoint(this.lat, this.lng);

  final double lat;
  final double lng;
}

class GlobeProjectedPoint {
  const GlobeProjectedPoint({
    required this.offset,
    required this.depth,
    required this.edgeFade,
  });

  final Offset offset;
  final double depth;
  final double edgeFade;
}

class GlobeProjection {
  const GlobeProjection({
    required this.centerLat,
    required this.centerLng,
    required this.radius,
    required this.center,
  });

  final double centerLat;
  final double centerLng;
  final double radius;
  final Offset center;

  GlobeProjectedPoint? project(GlobeGeoPoint point) {
    final lat = _radians(point.lat);
    final lon = _radians(normalizeLongitude(point.lng - centerLng));
    final centerLatRad = _radians(centerLat);
    final sinLat = math.sin(lat);
    final cosLat = math.cos(lat);
    final sinCenterLat = math.sin(centerLatRad);
    final cosCenterLat = math.cos(centerLatRad);
    final cosLon = math.cos(lon);

    final depth = sinCenterLat * sinLat + cosCenterLat * cosLat * cosLon;
    if (depth < -0.04) return null;

    final x = radius * cosLat * math.sin(lon);
    final y =
        -radius * (cosCenterLat * sinLat - sinCenterLat * cosLat * cosLon);
    final edgeFade = ((depth + 0.06) / 0.36).clamp(0.0, 1.0);
    return GlobeProjectedPoint(
      offset: center + Offset(x, y),
      depth: depth,
      edgeFade: edgeFade,
    );
  }

  Offset projectToVisibleEdge(GlobeGeoPoint point) {
    final lat = _radians(point.lat);
    final lon = _radians(normalizeLongitude(point.lng - centerLng));
    final centerLatRad = _radians(centerLat);
    final x = radius * math.cos(lat) * math.sin(lon);
    final y =
        -radius *
        (math.cos(centerLatRad) * math.sin(lat) -
            math.sin(centerLatRad) * math.cos(lat) * math.cos(lon));
    final vector = Offset(x, y);
    final distance = vector.distance;
    if (distance <= radius * 0.88) return center + vector;
    return center + vector / distance * radius * 0.88;
  }
}

class GlobeViewOrientation {
  const GlobeViewOrientation({
    required this.centerLat,
    required this.centerLng,
  });

  final double centerLat;
  final double centerLng;

  factory GlobeViewOrientation.forRoute({
    required GlobeGeoPoint from,
    required GlobeGeoPoint to,
    required bool isDomestic,
  }) {
    if (isDomestic || _isTurkeyPair(from, to)) {
      return const GlobeViewOrientation(centerLat: 39.4, centerLng: 34.4);
    }

    final crossesAtlantic = from.lng < -45 || to.lng < -45;
    if (crossesAtlantic) {
      return GlobeViewOrientation(
        centerLat: ((from.lat + to.lat) / 2 + 6).clamp(34.0, 52.0),
        centerLng: _midLongitude(from.lng, to.lng),
      );
    }

    final reachesEastAsia = from.lng > 95 || to.lng > 95;
    if (reachesEastAsia) {
      return GlobeViewOrientation(
        centerLat: ((from.lat + to.lat) / 2 + 3).clamp(30.0, 46.0),
        centerLng: _midLongitude(from.lng, to.lng),
      );
    }

    final reachesGulf = from.lng > 45 || to.lng > 45;
    if (reachesGulf) {
      return GlobeViewOrientation(
        centerLat: ((from.lat + to.lat) / 2 - 2).clamp(27.0, 42.0),
        centerLng: _midLongitude(from.lng, to.lng),
      );
    }

    return GlobeViewOrientation(
      centerLat: ((from.lat + to.lat) / 2).clamp(36.0, 48.0),
      centerLng: _midLongitude(from.lng, to.lng),
    );
  }

  static bool _isTurkeyPair(GlobeGeoPoint a, GlobeGeoPoint b) {
    bool insideTurkey(GlobeGeoPoint point) {
      return point.lat >= 35 &&
          point.lat <= 43 &&
          point.lng >= 25 &&
          point.lng <= 43;
    }

    return insideTurkey(a) && insideTurkey(b);
  }
}

Offset? projectLatLngToGlobe({
  required double lat,
  required double lng,
  required double centerLat,
  required double centerLng,
  required double radius,
  required Offset center,
}) {
  return GlobeProjection(
    centerLat: centerLat,
    centerLng: centerLng,
    radius: radius,
    center: center,
  ).project(GlobeGeoPoint(lat, lng))?.offset;
}

double normalizeLongitude(double lng) {
  var value = lng;
  while (value > 180) {
    value -= 360;
  }
  while (value < -180) {
    value += 360;
  }
  return value;
}

double globeDistanceKm(GlobeGeoPoint a, GlobeGeoPoint b) {
  const earthRadiusKm = 6371.0;
  final dLat = _radians(b.lat - a.lat);
  final dLng = _radians(normalizeLongitude(b.lng - a.lng));
  final lat1 = _radians(a.lat);
  final lat2 = _radians(b.lat);
  final h =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return earthRadiusKm * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
}

double _midLongitude(double fromLng, double toLng) {
  final delta = normalizeLongitude(toLng - fromLng);
  return normalizeLongitude(fromLng + delta / 2);
}

double _radians(double degrees) => degrees * math.pi / 180;
