import '../models/destination_model.dart';

/// Static mock destination data for AeroVista.
/// 10 destinations: 5 international + 5 domestic (Türkiye).
class MockDestinations {
  MockDestinations._();

  static const List<DestinationModel> all = [
    // ── International ─────────────────────────────────────────────────────────
    DestinationModel(
      id: 'd001',
      city: 'Paris',
      country: 'Fransa',
      airportCode: 'CDG',
      airportName: 'Charles de Gaulle Havalimanı',
      subtitle: 'Zarif sokaklar ve şehir ışıkları.',
      startingPrice: 599,
      isDomestic: false,
      imageAssetPath: 'assets/destinations/paris.jpg',
      visualStyle: DestinationVisualStyle.paris,
    ),
    DestinationModel(
      id: 'd002',
      city: 'Tokyo',
      country: 'Japonya',
      airportCode: 'NRT',
      airportName: 'Narita Uluslararası Havalimanı',
      subtitle: 'Gelenek, neon ve gelecek aynı rotada.',
      startingPrice: 1190,
      isDomestic: false,
      imageAssetPath: 'assets/destinations/tokyo.jpg',
      visualStyle: DestinationVisualStyle.tokyo,
    ),
    DestinationModel(
      id: 'd003',
      city: 'New York',
      country: 'ABD',
      airportCode: 'JFK',
      airportName: 'John F. Kennedy Uluslararası Havalimanı',
      subtitle: 'Metropol enerjisi ve gökdelen ritmi.',
      startingPrice: 849,
      isDomestic: false,
      imageAssetPath: 'assets/destinations/new_york.jpg',
      visualStyle: DestinationVisualStyle.newYork,
    ),
    DestinationModel(
      id: 'd004',
      city: 'Londra',
      country: 'Birleşik Krallık',
      airportCode: 'LHR',
      airportName: 'Heathrow Havalimanı',
      subtitle: 'Yağmur, tarih ve şehir zarafeti.',
      startingPrice: 479,
      isDomestic: false,
      imageAssetPath: 'assets/destinations/london.jpg',
      visualStyle: DestinationVisualStyle.london,
    ),
    DestinationModel(
      id: 'd005',
      city: 'Dubai',
      country: 'BAE',
      airportCode: 'DXB',
      airportName: 'Dubai Uluslararası Havalimanı',
      subtitle: 'Çölde parıldayan modern şehir.',
      startingPrice: 389,
      isDomestic: false,
      imageAssetPath: 'assets/destinations/dubai.jpg',
      visualStyle: DestinationVisualStyle.dubai,
    ),

    // ── Yurtiçi — Türkiye ─────────────────────────────────────────────────────
    DestinationModel(
      id: 'd006',
      city: 'Ankara',
      country: 'Türkiye',
      airportCode: 'ESB',
      airportName: 'Esenboğa Havalimanı',
      subtitle: 'Başkent ritmi ve sade şehir kaçamağı.',
      startingPrice: 129,
      isDomestic: true,
      imageAssetPath: 'assets/destinations/ankara.jpg',
      visualStyle: DestinationVisualStyle.ankara,
    ),
    DestinationModel(
      id: 'd007',
      city: 'İzmir',
      country: 'Türkiye',
      airportCode: 'ADB',
      airportName: 'Adnan Menderes Havalimanı',
      subtitle: 'Ege havası, sahil yürüyüşleri ve gün batımı.',
      startingPrice: 145,
      isDomestic: true,
      imageAssetPath: 'assets/destinations/izmir.jpg',
      visualStyle: DestinationVisualStyle.izmir,
    ),
    DestinationModel(
      id: 'd008',
      city: 'Antalya',
      country: 'Türkiye',
      airportCode: 'AYT',
      airportName: 'Antalya Havalimanı',
      subtitle: 'Akdeniz ışığı, deniz ve sıcak kaçamaklar.',
      startingPrice: 119,
      isDomestic: true,
      imageAssetPath: 'assets/destinations/antalya.jpg',
      visualStyle: DestinationVisualStyle.antalya,
    ),
    DestinationModel(
      id: 'd009',
      city: 'Trabzon',
      country: 'Türkiye',
      airportCode: 'TZX',
      airportName: 'Trabzon Havalimanı',
      subtitle: 'Karadeniz yeşili ve sisli yayla rotaları.',
      startingPrice: 159,
      isDomestic: true,
      imageAssetPath: 'assets/destinations/trabzon.jpg',
      visualStyle: DestinationVisualStyle.trabzon,
    ),
    DestinationModel(
      id: 'd010',
      city: 'Kapadokya',
      country: 'Türkiye',
      airportCode: 'ASR',
      airportName: 'Kayseri Erkilet Havalimanı',
      subtitle: 'Balonlar, vadiler and sabah ışığı.',
      startingPrice: 89,
      isDomestic: true,
      imageAssetPath: 'assets/destinations/cappadocia.jpg',
      visualStyle: DestinationVisualStyle.cappadocia,
    ),
  ];

  /// Returns all domestic destinations.
  static List<DestinationModel> get domestic =>
      all.where((d) => d.isDomestic).toList();

  /// Returns all international destinations.
  static List<DestinationModel> get international =>
      all.where((d) => !d.isDomestic).toList();
}
