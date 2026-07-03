import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shader_globe_painter.dart';

class ShaderGlobe extends StatefulWidget {
  const ShaderGlobe({
    super.key,
    required this.size,
    this.rotation = 0,
    this.centerLat = 39.4,
    this.animated = true,
    this.reduceMotion = false,
    this.opacity = 1,
    this.highQuality = true,
    this.shaderAsset = defaultShaderAsset,
    this.textureAsset = defaultTextureAsset,
  });

  static const defaultShaderAsset = 'shaders/premium_globe.frag';
  static const defaultTextureAsset = 'assets/globe/world_premium_map.png';

  final double size;
  final double rotation;
  final double centerLat;
  final bool animated;
  final bool reduceMotion;
  final double opacity;
  final bool highQuality;
  final String shaderAsset;
  final String textureAsset;

  @override
  State<ShaderGlobe> createState() => _ShaderGlobeState();
}

class _ShaderGlobeState extends State<ShaderGlobe>
    with SingleTickerProviderStateMixin {
  static final Map<String, Future<ui.FragmentProgram?>> _programCache = {};
  static final Map<String, Future<ui.Image?>> _textureCache = {};

  late final AnimationController _controller;
  late Future<_ShaderGlobeResources> _resourcesFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 34),
    );
    _resourcesFuture = _loadResources();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant ShaderGlobe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shaderAsset != widget.shaderAsset ||
        oldWidget.textureAsset != widget.textureAsset) {
      _resourcesFuture = _loadResources();
    }
    if (oldWidget.animated != widget.animated ||
        oldWidget.reduceMotion != widget.reduceMotion) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncAnimation() {
    if (!widget.animated || widget.reduceMotion) {
      _controller.stop();
      _controller.value = 0;
      return;
    }
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  Future<_ShaderGlobeResources> _loadResources() async {
    final program = await _programFor(widget.shaderAsset);
    final texture = await _textureFor(widget.textureAsset);
    return _ShaderGlobeResources(program: program, texture: texture);
  }

  static Future<ui.FragmentProgram?> _programFor(String asset) {
    return _programCache.putIfAbsent(asset, () async {
      try {
        return await ui.FragmentProgram.fromAsset(asset);
      } catch (_) {
        return null;
      }
    });
  }

  static Future<ui.Image?> _textureFor(String asset) {
    return _textureCache.putIfAbsent(asset, () async {
      try {
        final data = await rootBundle.load(asset);
        final bytes = data.buffer.asUint8List();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        codec.dispose();
        return frame.image;
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimension = math.max(0.0, widget.size);
    return SizedBox.square(
      dimension: dimension,
      child: RepaintBoundary(
        child: FutureBuilder<_ShaderGlobeResources>(
          future: _resourcesFuture,
          builder: (context, snapshot) {
            final resources = snapshot.data;
            if (resources == null || !resources.isReady) {
              return _fallback(dimension);
            }
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final phase = widget.animated && !widget.reduceMotion
                    ? _controller.value
                    : 0.0;
                final drift = math.sin(phase * math.pi * 2) * 0.042;
                return CustomPaint(
                  size: Size.square(dimension),
                  painter: PremiumGlobeShaderPainter(
                    program: resources.program!,
                    texture: resources.texture!,
                    time: phase * math.pi * 2,
                    rotation: widget.rotation + drift,
                    centerLat: widget.centerLat,
                    opacity: widget.opacity,
                    rimStrength: widget.highQuality ? 1.0 : 0.72,
                    atmosphereStrength: widget.highQuality ? 1.0 : 0.74,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _fallback(double dimension) {
    final phase = widget.animated && !widget.reduceMotion
        ? _controller.value
        : 0.0;
    final drift = math.sin(phase * math.pi * 2) * 0.028;
    return OptimizedFallbackGlobe(
      size: dimension,
      rotation: widget.rotation + drift,
      centerLat: widget.centerLat,
      opacity: widget.opacity,
      highQuality: widget.highQuality,
    );
  }
}

class _ShaderGlobeResources {
  const _ShaderGlobeResources({required this.program, required this.texture});

  final ui.FragmentProgram? program;
  final ui.Image? texture;

  bool get isReady => program != null && texture != null;
}
