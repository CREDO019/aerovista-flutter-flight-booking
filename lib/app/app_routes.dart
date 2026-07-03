import 'package:flutter/material.dart';
import '../features/splash/animated_splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/demo_login_screen.dart';
import '../features/home/flight_home_screen.dart';
import '../features/explore/destination_explore_screen.dart';
import '../features/results/flight_results_screen.dart';
import '../features/boarding_pass/boarding_pass_screen.dart';
import '../features/confirmation/booking_confirmed_screen.dart';

/// Central route registry for AeroVista.
///
/// Add new routes here as new screens are built. Keeping route names
/// as typed constants avoids typo-related navigation bugs.
class AppRoutes {
  AppRoutes._();

  // ── Route name constants ──────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String results = '/results';
  static const String boardingPass = '/boarding-pass';
  static const String confirmation = '/confirmation';

  // ── Route map ─────────────────────────────────────────────────────────────
  /// Passed directly to [MaterialApp.routes].
  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const AnimatedSplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const DemoLoginScreen(),
    home: (_) => const FlightHomeScreen(),
    explore: (_) => const DestinationExploreScreen(),
    results: (_) => const FlightResultsScreen(),
    boardingPass: (_) => const BoardingPassScreen(),
    confirmation: (_) => const BookingConfirmedScreen(),
  };
}
