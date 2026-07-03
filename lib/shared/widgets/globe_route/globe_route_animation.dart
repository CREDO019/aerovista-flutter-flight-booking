import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../premium_plane_marker.dart';
import 'globe_route_models.dart';
export 'globe_route_models.dart';
import 'globe_route_painter.dart';
import 'shader_globe.dart';

/// Cinematic Globe Route Animation Widget.
///
/// Performance Optimization:
///   - Splits the shader globe surface from the dynamic Flutter route overlay.
///   - Precomputes all geometry once per size/route change to avoid expensive
///     projection loops inside the repaint cycle.
///   - Supports GlobeRouteSize presets (compact, medium, large, hero).
class GlobeRouteAnimation extends StatefulWidget {
  const GlobeRouteAnimation({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.fromCity,
    required this.toCity,
    required this.fromAirportName,
    required this.toAirportName,
    required this.isDomestic,
    this.size = GlobeRouteSize.large,
    this.height,
    this.playOnce = false,
    this.showLabels = true,
    this.highQuality = true,
    this.reduceMotion = false,
    this.animated = true,
    this.reduceBorders = false,
    this.globeShaderAsset = ShaderGlobe.defaultShaderAsset,
    this.globeTextureAsset = ShaderGlobe.defaultTextureAsset,
  });

  final String fromCode;
  final String toCode;
  final String fromCity;
  final String toCity;
  final String fromAirportName;
  final String toAirportName;
  final bool isDomestic;
  final GlobeRouteSize size;
  final double? height;
  final bool playOnce;
  final bool showLabels;
  final bool highQuality;
  final bool reduceMotion;
  final bool animated;
  final bool reduceBorders;
  final String globeShaderAsset;
  final String globeTextureAsset;

  double get effectiveHeight {
    if (height != null) return height!;
    switch (size) {
      case GlobeRouteSize.compact:
        return 165.0;
      case GlobeRouteSize.medium:
        return 225.0;
      case GlobeRouteSize.large:
        return 300.0;
      case GlobeRouteSize.hero:
        return 360.0;
    }
  }

  @override
  State<GlobeRouteAnimation> createState() => _GlobeRouteAnimationState();
}

class _GlobeRouteAnimationState extends State<GlobeRouteAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  GlobeRouteGeometry? _cachedGeometry;
  Size? _cachedSize;
  GlobeRouteData? _cachedRoute;
  GlobeRouteSize? _cachedSizePreset;
  bool? _cachedHighQuality;
  bool? _cachedReduceBorders;

  @override
  void initState() {
    super.initState();
    _createController();
  }

  @override
  void didUpdateWidget(covariant GlobeRouteAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    final routeChanged =
        oldWidget.fromCode != widget.fromCode ||
        oldWidget.toCode != widget.toCode ||
        oldWidget.isDomestic != widget.isDomestic ||
        oldWidget.size != widget.size ||
        oldWidget.highQuality != widget.highQuality ||
        oldWidget.reduceBorders != widget.reduceBorders;

    final durationChanged = _getDurationMs(oldWidget) != _getDurationMs(widget);

    if (routeChanged || durationChanged) {
      _controller.stop();
      _controller.dispose();
      _createController();
    } else if (oldWidget.animated != widget.animated ||
        oldWidget.reduceMotion != widget.reduceMotion ||
        oldWidget.playOnce != widget.playOnce) {
      _syncAnimationState();
    }
  }

  int _getDurationMs(GlobeRouteAnimation w) {
    return w.reduceMotion
        ? 1200
        : (w.playOnce
              ? 1900
              : w.size == GlobeRouteSize.compact
              ? 4500
              : 5500);
  }

  void _createController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _getDurationMs(widget)),
    );
    _syncAnimationState();
  }

  void _syncAnimationState() {
    if (!mounted) return;

    if (!widget.animated || widget.reduceMotion) {
      _controller.stop();
      _controller.value = widget.playOnce ? 1.0 : 0.75;
      return;
    }

    if (widget.playOnce) {
      _controller
        ..reset()
        ..forward();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  GlobeRouteGeometry _getGeometry(Size size, GlobeRouteData route) {
    if (_cachedGeometry != null &&
        _cachedSize == size &&
        _cachedRoute == route &&
        _cachedSizePreset == widget.size &&
        _cachedHighQuality == widget.highQuality &&
        _cachedReduceBorders == widget.reduceBorders) {
      return _cachedGeometry!;
    }
    _cachedSize = size;
    _cachedRoute = route;
    _cachedSizePreset = widget.size;
    _cachedHighQuality = widget.highQuality;
    _cachedReduceBorders = widget.reduceBorders;
    _cachedGeometry = GlobeGeometryBuilder.build(
      size: size,
      route: route,
      sizePreset: widget.size,
      reserveLabelSpace:
          widget.showLabels && widget.size != GlobeRouteSize.compact,
      highQuality: widget.highQuality,
      reduceBorders: widget.reduceBorders,
    );
    return _cachedGeometry!;
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final route = GlobeRouteData(
      fromCode: widget.fromCode,
      toCode: widget.toCode,
      fromCity: widget.fromCity,
      toCity: widget.toCity,
      fromAirportName: widget.fromAirportName,
      toAirportName: widget.toAirportName,
      isDomestic: widget.isDomestic,
    );

    final isCompact = widget.size == GlobeRouteSize.compact;

    return SizedBox(
      height: widget.effectiveHeight,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final geometry = _getGeometry(size, route);
          final checkSize = geometry.successCheckSize;

          return Stack(
            children: [
              // Layer A - GPU shader globe surface with local fallback.
              Positioned.fromRect(
                rect: geometry.globeRect,
                child: ShaderGlobe(
                  size: geometry.globeRect.width,
                  rotation: _radians(geometry.viewCenterLng),
                  centerLat: geometry.viewCenterLat,
                  animated: widget.animated && !isCompact,
                  reduceMotion: widget.reduceMotion,
                  opacity: isCompact ? 0.94 : 1.0,
                  highQuality: widget.highQuality,
                  shaderAsset: widget.globeShaderAsset,
                  textureAsset: widget.globeTextureAsset,
                ),
              ),

              // Layer B - Animated route overlay
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final values = _animationValues(_controller.value);
                      return CustomPaint(
                        painter: GlobeRouteOverlayPainter(
                          geometry: geometry,
                          route: route,
                          planeProgress: values.planeProgress,
                          routeDrawProgress: values.routeDrawProgress,
                          fadeProgress: values.fadeProgress,
                          arrivalPulse: values.arrivalPulse,
                          compact: isCompact,
                          playOnce: widget.playOnce,
                          highQuality: widget.highQuality,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Static labels and kind badges
              if (widget.showLabels && !isCompact)
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.sm,
                  child: _GlobeRouteLabels(
                    route: route,
                    sizePreset: widget.size,
                  ),
                ),
              Positioned(
                top: isCompact ? 5 : AppSpacing.sm,
                right: isCompact ? 6 : AppSpacing.md,
                child: _RouteKindBadge(
                  isDomestic: widget.isDomestic,
                  sizePreset: widget.size,
                ),
              ),

              // Success check - positioned dynamically near the arrival node
              if (widget.playOnce)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final arrivalPulse = _animationValues(
                      _controller.value,
                    ).arrivalPulse;
                    if (arrivalPulse <= 0) return const SizedBox.shrink();

                    // Center checking circle on the destination coordinates
                    final leftPos = geometry.toPoint.dx - (checkSize / 2);
                    final topPos =
                        geometry.toPoint.dy -
                        (checkSize / 2) -
                        (isCompact ? 12 : 20);

                    return Positioned(
                      left: leftPos,
                      top: topPos,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: arrivalPulse,
                          child: Transform.scale(
                            scale: 0.85 + arrivalPulse * 0.15,
                            child: _ArrivalCheck(size: checkSize),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  _GlobeAnimationValues _animationValues(double raw) {
    final motionWindow = widget.playOnce
        ? (raw / 0.86).clamp(0.0, 1.0)
        : (raw / 0.88).clamp(0.0, 1.0);
    final planeProgress = Curves.easeInOutCubic.transform(motionWindow);
    final routeDrawProgress = Curves.easeOutCubic.transform(
      (motionWindow + 0.075).clamp(0.0, 1.0),
    );
    final fadeProgress = Curves.easeOutCubic.transform(
      (raw / 0.18).clamp(0.0, 1.0),
    );
    final arrivalPulse = widget.playOnce
        ? Curves.easeOutCubic.transform(((raw - 0.82) / 0.18).clamp(0.0, 1.0))
        : raw > 0.86
        ? Curves.easeOutCubic.transform(((raw - 0.86) / 0.14).clamp(0.0, 1.0))
        : 0.0;
    return _GlobeAnimationValues(
      planeProgress: planeProgress,
      routeDrawProgress: routeDrawProgress,
      fadeProgress: fadeProgress,
      arrivalPulse: arrivalPulse,
    );
  }
}

double _radians(double degrees) => degrees * math.pi / 180.0;

class _GlobeAnimationValues {
  const _GlobeAnimationValues({
    required this.planeProgress,
    required this.routeDrawProgress,
    required this.fadeProgress,
    required this.arrivalPulse,
  });

  final double planeProgress;
  final double routeDrawProgress;
  final double fadeProgress;
  final double arrivalPulse;
}

class _GlobeRouteLabels extends StatelessWidget {
  const _GlobeRouteLabels({required this.route, required this.sizePreset});

  final GlobeRouteData route;
  final GlobeRouteSize sizePreset;

  @override
  Widget build(BuildContext context) {
    final isCompact = sizePreset == GlobeRouteSize.compact;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _AirportLabel(
            code: route.fromCode,
            city: route.fromCity,
            airportName: route.fromAirportName,
            sizePreset: sizePreset,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 4 : 8),
          child: PremiumPlaneMarker(
            size: isCompact ? 13 : 15,
            variant: PlaneMarkerVariant.minimal,
            glow: false,
          ),
        ),
        Expanded(
          child: _AirportLabel(
            code: route.toCode,
            city: route.toCity,
            airportName: route.toAirportName,
            sizePreset: sizePreset,
            alignRight: true,
          ),
        ),
      ],
    );
  }
}

class _AirportLabel extends StatelessWidget {
  const _AirportLabel({
    required this.code,
    required this.city,
    required this.airportName,
    required this.sizePreset,
    this.alignRight = false,
  });

  final String code;
  final String city;
  final String airportName;
  final GlobeRouteSize sizePreset;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final isCompact = sizePreset == GlobeRouteSize.compact;
    final isMedium = sizePreset == GlobeRouteSize.medium;
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          code,
          style: AppTextStyles.subtitle.copyWith(
            color: Colors.white,
            fontSize: isCompact ? 14 : (isMedium ? 16 : 18),
            letterSpacing: 1.2,
          ),
        ),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.66),
            fontSize: isCompact ? 9 : (isMedium ? 9.5 : 10),
          ),
        ),
        Text(
          airportName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignRight ? TextAlign.end : TextAlign.start,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.42),
            fontSize: isCompact ? 8 : (isMedium ? 8.5 : 9),
          ),
        ),
      ],
    );
  }
}

class _RouteKindBadge extends StatelessWidget {
  const _RouteKindBadge({required this.isDomestic, required this.sizePreset});

  final bool isDomestic;
  final GlobeRouteSize sizePreset;

  @override
  Widget build(BuildContext context) {
    final color = isDomestic
        ? const Color(0xFF2A9D8F)
        : const Color(0xFF2A6FBA);
    final isCompact = sizePreset == GlobeRouteSize.compact;
    final isMedium = sizePreset == GlobeRouteSize.medium;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 7 : 9,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        isDomestic ? 'Yurtiçi Uçuş' : 'Yurtdışı Uçuş',
        style: AppTextStyles.caption.copyWith(
          color: Colors.white.withValues(alpha: 0.82),
          fontSize: isCompact ? 8.5 : (isMedium ? 9.0 : 9.5),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ArrivalCheck extends StatelessWidget {
  const _ArrivalCheck({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.airlineRed, AppColors.deepRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.32),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.check_rounded, color: Colors.white, size: size * 0.52),
    );
  }
}
