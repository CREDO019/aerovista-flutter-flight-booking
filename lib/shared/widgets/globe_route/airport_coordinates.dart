import 'world_projection.dart';

class AirportCoordinate {
  const AirportCoordinate({
    required this.code,
    required this.name,
    required this.point,
  });

  final String code;
  final String name;
  final GlobeGeoPoint point;
}

class AirportCoordinates {
  AirportCoordinates._();

  static const Map<String, AirportCoordinate> _coordinates = {
    'IST': AirportCoordinate(
      code: 'IST',
      name: 'İstanbul Havalimanı',
      point: GlobeGeoPoint(41.2753, 28.7519),
    ),
    'SAW': AirportCoordinate(
      code: 'SAW',
      name: 'Sabiha Gökçen Havalimanı',
      point: GlobeGeoPoint(40.8986, 29.3092),
    ),
    'ESB': AirportCoordinate(
      code: 'ESB',
      name: 'Esenboğa Havalimanı',
      point: GlobeGeoPoint(40.1281, 32.9951),
    ),
    'ADB': AirportCoordinate(
      code: 'ADB',
      name: 'Adnan Menderes Havalimanı',
      point: GlobeGeoPoint(38.2924, 27.1569),
    ),
    'AYT': AirportCoordinate(
      code: 'AYT',
      name: 'Antalya Havalimanı',
      point: GlobeGeoPoint(36.8987, 30.8005),
    ),
    'TZX': AirportCoordinate(
      code: 'TZX',
      name: 'Trabzon Havalimanı',
      point: GlobeGeoPoint(40.9951, 39.7897),
    ),
    'ASR': AirportCoordinate(
      code: 'ASR',
      name: 'Kayseri Erkilet Havalimanı',
      point: GlobeGeoPoint(38.7704, 35.4954),
    ),
    'CDG': AirportCoordinate(
      code: 'CDG',
      name: 'Charles de Gaulle Havalimanı',
      point: GlobeGeoPoint(49.0097, 2.5479),
    ),
    'NRT': AirportCoordinate(
      code: 'NRT',
      name: 'Narita Uluslararası Havalimanı',
      point: GlobeGeoPoint(35.7720, 140.3929),
    ),
    'JFK': AirportCoordinate(
      code: 'JFK',
      name: 'John F. Kennedy Uluslararası Havalimanı',
      point: GlobeGeoPoint(40.6413, -73.7781),
    ),
    'LHR': AirportCoordinate(
      code: 'LHR',
      name: 'Heathrow Havalimanı',
      point: GlobeGeoPoint(51.4700, -0.4543),
    ),
    'DXB': AirportCoordinate(
      code: 'DXB',
      name: 'Dubai Uluslararası Havalimanı',
      point: GlobeGeoPoint(25.2532, 55.3657),
    ),
  };

  static AirportCoordinate forCode(String code, {required bool isOrigin}) {
    return _coordinates[code.toUpperCase()] ??
        (isOrigin ? _coordinates['IST']! : _fallbackDestination);
  }

  static const AirportCoordinate _fallbackDestination = AirportCoordinate(
    code: 'EUR',
    name: 'Avrupa Rota Noktası',
    point: GlobeGeoPoint(45.0, 12.0),
  );
}
