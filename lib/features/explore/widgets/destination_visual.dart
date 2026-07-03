import 'package:flutter/material.dart';
import '../../../models/destination_model.dart';

/// Local visual metadata for destination cards.
class DestinationVisual {
  const DestinationVisual({
    required this.assetPath,
    required this.assetAvailable,
    required this.moodLabel,
    required this.accent,
  });

  final String assetPath;
  final bool assetAvailable;
  final String moodLabel;
  final Color accent;

  factory DestinationVisual.forModel(DestinationModel model) {
    final assetPath = model.imageAssetPath ?? '';
    final assetAvailable = model.imageAssetPath != null;

    switch (model.visualStyle) {
      case DestinationVisualStyle.paris:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Şık şehir molası',
          accent: const Color(0xFFFFB37C),
        );
      case DestinationVisualStyle.tokyo:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Neon gece rotası',
          accent: const Color(0xFFFF4E68),
        );
      case DestinationVisualStyle.newYork:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Metropol enerjisi',
          accent: const Color(0xFF8FD3FF),
        );
      case DestinationVisualStyle.cappadocia:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Sıcak vadi manzarası',
          accent: const Color(0xFFFF8A54),
        );
      case DestinationVisualStyle.london:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Serin şehir kaçamağı',
          accent: const Color(0xFFBFD0E4),
        );
      case DestinationVisualStyle.ankara:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Sakin başkent ritmi',
          accent: const Color(0xFF9BB5D8),
        );
      case DestinationVisualStyle.izmir:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Ege gün batımı',
          accent: const Color(0xFFFFA45B),
        );
      case DestinationVisualStyle.antalya:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Akdeniz ışığı',
          accent: const Color(0xFF58D5C9),
        );
      case DestinationVisualStyle.trabzon:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Karadeniz yeşili',
          accent: const Color(0xFF6ED19C),
        );
      case DestinationVisualStyle.dubai:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Modern çöl ışıltısı',
          accent: const Color(0xFFFFC36A),
        );
      case DestinationVisualStyle.fallback:
        return DestinationVisual(
          assetPath: assetPath,
          assetAvailable: assetAvailable,
          moodLabel: 'Özel rota',
          accent: const Color(0xFFE63946),
        );
    }
  }
}
