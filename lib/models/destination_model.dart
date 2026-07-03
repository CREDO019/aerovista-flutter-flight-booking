enum DestinationVisualStyle {
  paris,
  tokyo,
  newYork,
  london,
  cappadocia,
  ankara,
  izmir,
  antalya,
  trabzon,
  dubai,
  fallback,
}

/// Represents a travel destination card in AeroVista.
/// All data is mock / local — no real API is used.
class DestinationModel {
  const DestinationModel({
    required this.id,
    required this.city,
    required this.country,
    required this.airportCode,
    required this.airportName,
    required this.subtitle,
    required this.startingPrice,
    required this.isDomestic,
    this.imageAssetPath,
    this.visualStyle = DestinationVisualStyle.fallback,
  });

  final String id;

  /// Destination city, e.g. "Paris"
  final String city;

  /// Country name, e.g. "Fransa"
  final String country;

  /// IATA airport code, e.g. "CDG"
  final String airportCode;

  /// Full airport name, e.g. "Charles de Gaulle Havalimanı"
  final String airportName;

  /// Short marketing subtitle, e.g. "Zarif sokaklar ve şehir ışıkları."
  final String subtitle;

  /// Lowest available fare in TRY/display, e.g. 599
  final int startingPrice;

  /// True if destination is in Türkiye
  final bool isDomestic;

  /// Path to local destination image asset
  final String? imageAssetPath;

  /// Architectural custom silhouette and gradient styling tag
  final DestinationVisualStyle visualStyle;
}
