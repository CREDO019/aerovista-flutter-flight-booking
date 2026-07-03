import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Which visual style to use.
///
/// All three variants share the same aircraft silhouette.
/// They differ only in glow intensity and canvas scale.
enum PlaneMarkerVariant { minimal, route, hero }

/// A premium top-view aircraft marker, drawn entirely in [CustomPainter].
///
/// The aircraft nose points **right** (positive-x) in the default orientation.
/// Rotate via [angle] or [rotation] to follow a route tangent.
class PremiumPlaneMarker extends StatelessWidget {
  const PremiumPlaneMarker({
    super.key,
    this.size = 24,
    this.rotation = 0,
    this.angle,
    this.variant = PlaneMarkerVariant.route,
    this.glow,
    this.showGlow,
    this.pulse = false,
    this.showPulse,
    this.progress = 0,
    this.pulseValue,
    this.color,
    this.glowColor,
  });

  final double size;

  /// Rotation in radians applied by [Transform.rotate]. Nose points right at 0.
  final double rotation;

  /// Alternative to [rotation]; if provided, takes priority.
  final double? angle;

  final PlaneMarkerVariant variant;

  /// Override glow. Defaults per-variant when null.
  final bool? glow;

  /// Alias for [glow] kept for API compatibility.
  final bool? showGlow;

  final bool pulse;

  /// Alias for [pulse] kept for API compatibility.
  final bool? showPulse;

  /// Pulse/progress animation value in [0, 1].
  final double progress;

  /// Alias for [progress] kept for API compatibility.
  final double? pulseValue;

  final Color? color;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final resolvedGlow = _resolveGlow(variant, glow, showGlow);
    final resolvedPulse = showPulse ?? pulse;
    final extent = size * _canvasScaleFor(variant, resolvedGlow, resolvedPulse);

    return SizedBox.square(
      dimension: extent,
      child: Transform.rotate(
        angle: angle ?? rotation,
        child: CustomPaint(
          painter: PremiumPlaneMarkerPainter(
            size: size,
            variant: variant,
            glow: resolvedGlow,
            pulse: resolvedPulse,
            progress: pulseValue ?? progress,
            color: color,
            glowColor: glowColor,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] backing [PremiumPlaneMarker].
///
/// Also exposes [paintMarker] as a static method so route painters can draw the
/// marker directly on their canvas without instantiating a widget.
class PremiumPlaneMarkerPainter extends CustomPainter {
  const PremiumPlaneMarkerPainter({
    this.size = 24,
    this.rotation = 0,
    this.angle,
    this.variant = PlaneMarkerVariant.route,
    this.glow,
    this.showGlow,
    this.pulse = false,
    this.showPulse,
    this.progress = 0,
    this.pulseValue,
    this.color,
    this.glowColor,
  });

  final double size;
  final double rotation;
  final double? angle;
  final PlaneMarkerVariant variant;
  final bool? glow;
  final bool? showGlow;
  final bool pulse;
  final bool? showPulse;
  final double progress;
  final double? pulseValue;
  final Color? color;
  final Color? glowColor;

  // ─── Static entry-point for canvas-based painters ──────────────────────────

  static void paintMarker(
    Canvas canvas, {
    required Offset center,
    double rotation = 0,
    double? angle,
    double size = 22,
    PlaneMarkerVariant variant = PlaneMarkerVariant.route,
    Color? color,
    Color? glowColor,
    bool? glow,
    bool? showGlow,
    bool pulse = false,
    bool? showPulse,
    double progress = 0,
    double? pulseValue,
  }) {
    final bodyColor = color ?? AppColors.airlineRed;
    final auraColor = glowColor ?? bodyColor;
    final resolvedGlow = _resolveGlow(variant, glow, showGlow);
    final resolvedPulse = showPulse ?? pulse;
    final resolvedProgress = pulseValue ?? progress;

    if (resolvedPulse) {
      _paintPulse(canvas, center, size, auraColor, resolvedProgress, variant);
    }

    if (resolvedGlow) {
      _paintGlow(canvas, center, size, auraColor, variant);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle ?? rotation);
    _paintAircraft(canvas, size, bodyColor, variant);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size canvasSize) {
    paintMarker(
      canvas,
      center: Offset(canvasSize.width / 2, canvasSize.height / 2),
      rotation: rotation,
      angle: angle,
      size: size,
      variant: variant,
      color: color,
      glowColor: glowColor,
      glow: glow,
      showGlow: showGlow,
      pulse: pulse,
      showPulse: showPulse,
      progress: progress,
      pulseValue: pulseValue,
    );
  }

  // ─── Pulse ring ─────────────────────────────────────────────────────────────

  static void _paintPulse(
    Canvas canvas,
    Offset center,
    double size,
    Color color,
    double progress,
    PlaneMarkerVariant variant,
  ) {
    final wave = 0.5 + 0.5 * math.sin(progress * math.pi * 2);
    final radius = size * (_pulseBaseRadiusFor(variant) + wave * 0.30);
    final alpha = _pulseAlphaFor(variant) * (1 - wave * 0.25);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.7, size * 0.030)
        ..color = color.withValues(alpha: alpha),
    );
  }

  // ─── Soft glow halo ─────────────────────────────────────────────────────────

  static void _paintGlow(
    Canvas canvas,
    Offset center,
    double size,
    Color color,
    PlaneMarkerVariant variant,
  ) {
    final radius = size * _glowRadiusFor(variant);
    final glowRect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: _glowAlphaFor(variant)),
            color.withValues(alpha: _glowAlphaFor(variant) * 0.30),
            color.withValues(alpha: 0),
          ],
          stops: const [0, 0.40, 1],
        ).createShader(glowRect),
    );
  }

  // ─── Aircraft silhouette ────────────────────────────────────────────────────
  //
  // Coordinate system: local canvas centered at (0,0).
  // Nose points right (+x). All coordinates are multiples of [size].
  // Normalized equivalents given as comments (−1..1 range, width = 2*size).

  static void _paintAircraft(
    Canvas canvas,
    double size,
    Color color,
    PlaneMarkerVariant variant,
  ) {
    // Build the three sub-paths.
    final body = _bodyPath(size);
    final wings = _wingsPath(size);
    final tail = _tailPath(size);

    // -- 1. Drop shadow: darker crimson, blurred, offset slightly down-right --
    final shadowPaint = Paint()
      ..color = Color.lerp(color, AppColors.deepRed, 0.55)!
          .withValues(alpha: 0.45)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        math.max(0.8, size * 0.055),
      );
    final shadowDelta = Offset(size * 0.032, size * 0.045);
    canvas.drawPath(tail.shift(shadowDelta), shadowPaint);
    canvas.drawPath(wings.shift(shadowDelta), shadowPaint);
    canvas.drawPath(body.shift(shadowDelta), shadowPaint);

    // -- 2. Tail fins (behind wings visually) --------------------------------
    final tailPaint = Paint()
      ..color = Color.lerp(color, AppColors.deepRed, 0.18)!
      ..style = PaintingStyle.fill;
    canvas.drawPath(tail, tailPaint);

    // -- 3. Main wings --------------------------------------------------------
    final wingShaderRect = Rect.fromLTWH(
      -size * 0.50,
      -size * 0.72,
      size * 0.80,
      size * 1.44,
    );
    final wingPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(color, Colors.white, 0.10)!,
          color,
          Color.lerp(color, AppColors.deepRed, 0.22)!,
        ],
      ).createShader(wingShaderRect);
    canvas.drawPath(wings, wingPaint);

    // -- 4. Fuselage ----------------------------------------------------------
    final bodyShaderRect = Rect.fromLTWH(
      -size * 0.80,
      -size * 0.14,
      size * 1.76,
      size * 0.28,
    );
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(color, Colors.white, 0.28)!,
          color,
          Color.lerp(color, AppColors.deepRed, 0.35)!,
        ],
      ).createShader(bodyShaderRect);
    canvas.drawPath(body, bodyPaint);

    // -- 5. Single highlight stroke along upper fuselage ----------------------
    //   Only drawn for route/hero or when size is large enough to matter.
    if (variant != PlaneMarkerVariant.minimal || size >= 20) {
      _paintFuselageHighlight(canvas, size);
    }
  }

  /// A single thin highlight arc along the upper surface of the fuselage.
  /// Creates depth without cluttering the silhouette.
  static void _paintFuselageHighlight(Canvas canvas, double size) {
    final highlight = Path()
      ..moveTo(size * 0.88, 0)
      ..cubicTo(
        size * 0.60, -size * 0.070,
        size * 0.20, -size * 0.105,
        -size * 0.35, -size * 0.075,
      );

    canvas.drawPath(
      highlight,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.55, size * 0.030)
        ..strokeCap = StrokeCap.round,
    );
  }

  // ─── Path builders ──────────────────────────────────────────────────────────
  //
  // Normalized reference (multiply by size/2 to get canvas coords):
  //   nose     : (+0.92,  0.00)
  //   body top : (−0.35, −0.12)
  //   tail     : (−0.78,  0.00)
  //   body bot : (−0.35, +0.12)

  static Path _bodyPath(double s) {
    // Half-size scale: 1 normalized unit = s/2 * 2 = s pixels wide total.
    // Using s as 'half-span' for clarity — nose is at s*0.92, tail at -s*0.78.
    return Path()
      // Start at nose tip
      ..moveTo(s * 0.92, 0)
      // Upper fuselage from nose to tail
      ..cubicTo(
        s * 0.65, -s * 0.065,
        s * 0.20, -s * 0.110,
        -s * 0.35, -s * 0.115,
      )
      ..cubicTo(
        -s * 0.55, -s * 0.115,
        -s * 0.72, -s * 0.075,
        -s * 0.78, 0,
      )
      // Lower fuselage back to nose (mirror)
      ..cubicTo(
        -s * 0.72, s * 0.075,
        -s * 0.55, s * 0.115,
        -s * 0.35, s * 0.115,
      )
      ..cubicTo(
        s * 0.20, s * 0.110,
        s * 0.65, s * 0.065,
        s * 0.92, 0,
      )
      ..close();
  }

  static Path _wingsPath(double s) {
    // Upper wing:
    //   root-leading  (−0.05, −0.095)
    //   tip           (−0.48, −0.70)
    //   root-trailing ( 0.25, −0.18)
    //
    // Lower wing mirrors across y-axis.
    return Path()
      // ── upper wing ──────────────────────────────────────────────────────
      ..moveTo(-s * 0.05, -s * 0.095)
      ..lineTo(-s * 0.48, -s * 0.70)
      ..cubicTo(
        -s * 0.38, -s * 0.72,
        -s * 0.20, -s * 0.55,
        s * 0.25, -s * 0.18,
      )
      ..close()
      // ── lower wing ──────────────────────────────────────────────────────
      ..moveTo(-s * 0.05, s * 0.095)
      ..lineTo(-s * 0.48, s * 0.70)
      ..cubicTo(
        -s * 0.38, s * 0.72,
        -s * 0.20, s * 0.55,
        s * 0.25, s * 0.18,
      )
      ..close();
  }

  static Path _tailPath(double s) {
    // Upper tail:
    //   root (−0.55, −0.095)  tip (−0.86, −0.35)  re-join (−0.70, −0.10)
    // Lower tail mirrors.
    return Path()
      // ── upper tail ──────────────────────────────────────────────────────
      ..moveTo(-s * 0.55, -s * 0.095)
      ..lineTo(-s * 0.86, -s * 0.35)
      ..cubicTo(
        -s * 0.82, -s * 0.38,
        -s * 0.75, -s * 0.28,
        -s * 0.70, -s * 0.10,
      )
      ..close()
      // ── lower tail ──────────────────────────────────────────────────────
      ..moveTo(-s * 0.55, s * 0.095)
      ..lineTo(-s * 0.86, s * 0.35)
      ..cubicTo(
        -s * 0.82, s * 0.38,
        -s * 0.75, s * 0.28,
        -s * 0.70, s * 0.10,
      )
      ..close();
  }

  @override
  bool shouldRepaint(PremiumPlaneMarkerPainter oldDelegate) {
    return oldDelegate.size != size ||
        oldDelegate.rotation != rotation ||
        oldDelegate.angle != angle ||
        oldDelegate.variant != variant ||
        oldDelegate.glow != glow ||
        oldDelegate.showGlow != showGlow ||
        oldDelegate.pulse != pulse ||
        oldDelegate.showPulse != showPulse ||
        oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.color != color ||
        oldDelegate.glowColor != glowColor;
  }
}

// ─── Module-level helpers ──────────────────────────────────────────────────────

bool _resolveGlow(PlaneMarkerVariant variant, bool? glow, bool? showGlow) {
  return glow ?? showGlow ?? variant != PlaneMarkerVariant.minimal;
}

double _canvasScaleFor(PlaneMarkerVariant variant, bool glow, bool pulse) {
  // Extra canvas room needed around the aircraft for glow/pulse rings.
  if (pulse) return 2.55;
  if (!glow) {
    return switch (variant) {
      PlaneMarkerVariant.minimal => 1.55,
      _ => 1.65,
    };
  }
  return switch (variant) {
    PlaneMarkerVariant.minimal => 1.65,
    PlaneMarkerVariant.route => 2.05,
    PlaneMarkerVariant.hero => 2.25,
  };
}

double _glowRadiusFor(PlaneMarkerVariant variant) {
  return switch (variant) {
    PlaneMarkerVariant.minimal => 0.60,
    PlaneMarkerVariant.route => 0.82,
    PlaneMarkerVariant.hero => 1.00,
  };
}

double _glowAlphaFor(PlaneMarkerVariant variant) {
  return switch (variant) {
    PlaneMarkerVariant.minimal => 0.07,
    PlaneMarkerVariant.route => 0.14,
    PlaneMarkerVariant.hero => 0.20,
  };
}

double _pulseBaseRadiusFor(PlaneMarkerVariant variant) {
  return switch (variant) {
    PlaneMarkerVariant.minimal => 0.72,
    PlaneMarkerVariant.route => 0.86,
    PlaneMarkerVariant.hero => 0.98,
  };
}

double _pulseAlphaFor(PlaneMarkerVariant variant) {
  return switch (variant) {
    PlaneMarkerVariant.minimal => 0.055,
    PlaneMarkerVariant.route => 0.075,
    PlaneMarkerVariant.hero => 0.095,
  };
}
