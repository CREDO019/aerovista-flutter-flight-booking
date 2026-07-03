/// Represents a single flight in AeroVista.
/// All data is mock / local — no real API is used.
class FlightModel {
  const FlightModel({
    required this.id,
    required this.fromCity,
    required this.fromCode,
    required this.fromAirportName,
    required this.fromCountry,
    required this.toCity,
    required this.toCode,
    required this.toAirportName,
    required this.toCountry,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.durationMinutes,
    required this.flightNumber,
    required this.cabin,
    required this.price,
    required this.gate,
    required this.seat,
    required this.isDomestic,
    required this.departurePeriod,
    required this.stops,
    required this.baggage,
    this.recommendedScore = 0,
  });

  final String id;

  // ── Origin ──────────────────────────────────────────────────────────────────
  /// Origin city name, e.g. "İstanbul"
  final String fromCity;

  /// IATA origin code, e.g. "IST"
  final String fromCode;

  /// Full airport name, e.g. "İstanbul Havalimanı"
  final String fromAirportName;

  /// Country of origin, e.g. "Türkiye"
  final String fromCountry;

  // ── Destination ─────────────────────────────────────────────────────────────
  /// Destination city name, e.g. "Paris"
  final String toCity;

  /// IATA destination code, e.g. "CDG"
  final String toCode;

  /// Full destination airport name, e.g. "Charles de Gaulle Havalimanı"
  final String toAirportName;

  /// Destination country, e.g. "Fransa"
  final String toCountry;

  // ── Timing ──────────────────────────────────────────────────────────────────
  /// Departure time string, e.g. "10:45"
  final String departureTime;

  /// Arrival time string, e.g. "14:20"
  final String arrivalTime;

  /// Human-readable duration, e.g. "3 sa 35 dk"
  final String duration;

  /// Duration in minutes for En Hızlı sort, e.g. 215
  final int durationMinutes;

  // ── Classification ──────────────────────────────────────────────────────────
  /// Flight identifier, e.g. "TK 0042"
  final String flightNumber;

  /// Class of service, e.g. "Ekonomi"
  final String cabin;

  /// Price in USD
  final int price;

  /// Departure gate, e.g. "B14"
  final String gate;

  /// Assigned seat, e.g. "12A"
  final String seat;

  /// True if origin and destination are both in Türkiye
  final bool isDomestic;

  /// One of: 'sabah' | 'öğle' | 'akşam' | 'gece'
  final String departurePeriod;

  /// Number of stops. 0 = direct (Direkt)
  final int stops;

  /// Baggage allowance string, e.g. "1 × 23 kg"
  final String baggage;

  /// Optional score for recommended ordering. Higher is better.
  final int recommendedScore;
}
