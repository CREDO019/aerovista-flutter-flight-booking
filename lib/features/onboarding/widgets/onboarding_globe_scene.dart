import 'package:flutter/material.dart';
import '../../../shared/widgets/globe_route/globe_route_animation.dart';

class OnboardingGlobeScene extends StatelessWidget {
  const OnboardingGlobeScene({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GlobeRouteAnimation(
      key: const ValueKey('onboarding-globe'),
      fromCode: 'IST',
      toCode: 'CDG',
      fromCity: 'İstanbul',
      toCity: 'Paris',
      fromAirportName: 'İstanbul Havalimanı',
      toAirportName: 'Paris Charles de Gaulle',
      isDomestic: false,
      size: GlobeRouteSize.large,
      animated: isActive,
      showLabels: false,
    );
  }
}
