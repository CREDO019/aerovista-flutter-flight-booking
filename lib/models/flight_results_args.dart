import 'destination_model.dart';

class FlightResultsArgs {
  const FlightResultsArgs({this.destinationCode, this.destination});

  factory FlightResultsArgs.fromDestination(DestinationModel destination) {
    return FlightResultsArgs(
      destinationCode: destination.airportCode,
      destination: destination,
    );
  }

  final String? destinationCode;
  final DestinationModel? destination;
}
