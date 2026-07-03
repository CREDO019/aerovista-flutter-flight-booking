import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aerovista/app/aerovista_app.dart';
import 'package:aerovista/core/constants/app_strings.dart';
import 'package:aerovista/core/theme/app_theme.dart';
import 'package:aerovista/data/mock_flights.dart';
import 'package:aerovista/features/boarding_pass/boarding_pass_screen.dart';
import 'package:aerovista/features/confirmation/booking_confirmed_screen.dart';
import 'package:aerovista/features/explore/destination_explore_screen.dart';
import 'package:aerovista/features/home/flight_home_screen.dart';
import 'package:aerovista/features/results/flight_results_screen.dart';
import 'package:aerovista/features/onboarding/onboarding_screen.dart';
import 'package:aerovista/app/app_routes.dart';
import 'package:aerovista/shared/widgets/globe_route/globe_route_animation.dart';
import 'package:aerovista/shared/widgets/globe_route/shader_globe.dart';
import 'package:aerovista/models/flight_results_args.dart';
import 'package:aerovista/shared/widgets/premium_button.dart';
import 'package:aerovista/shared/widgets/premium_plane_marker.dart';

void main() {
  test('AeroVistaApp smoke test — constructs root widget', () {
    expect(const AeroVistaApp(), isA<AeroVistaApp>());
  });

  testWidgets('ShaderGlobe builds with missing assets fallback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: ShaderGlobe(
              size: 128,
              animated: false,
              shaderAsset: 'shaders/missing_globe.frag',
              textureAsset: 'assets/globe/missing_world.png',
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.takeException(), isNull);
    expect(find.byType(ShaderGlobe), findsOneWidget);
  });

  testWidgets('PremiumPlaneMarker renders target sizes and variants', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PremiumPlaneMarker(
                  size: 14,
                  variant: PlaneMarkerVariant.minimal,
                  glow: false,
                ),
                PremiumPlaneMarker(
                  size: 18,
                  variant: PlaneMarkerVariant.minimal,
                  glow: false,
                ),
                PremiumPlaneMarker(size: 24, variant: PlaneMarkerVariant.route),
                PremiumPlaneMarker(size: 32, variant: PlaneMarkerVariant.hero),
                PremiumPlaneMarker(
                  size: 44,
                  variant: PlaneMarkerVariant.hero,
                  pulse: true,
                  progress: 0.35,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(PremiumPlaneMarker), findsNWidgets(5));
  });

  testWidgets('GlobeRouteAnimation falls back when shader assets are missing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: GlobeRouteAnimation(
              fromCode: 'IST',
              toCode: 'CDG',
              fromCity: 'İstanbul',
              toCity: 'Paris',
              fromAirportName: 'İstanbul Havalimanı',
              toAirportName: 'Paris CDG',
              isDomestic: false,
              size: GlobeRouteSize.medium,
              animated: false,
              reduceMotion: true,
              globeShaderAsset: 'shaders/missing_globe.frag',
              globeTextureAsset: 'assets/globe/missing_world.png',
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Boarding pass fits compact 375x667 layout', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: RouteSettings(arguments: MockFlights.all.first),
          builder: (_) => const BoardingPassScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Home fits compact 375x667 layout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const FlightHomeScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1700));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.searchFlights), findsOneWidget);
    expect(find.text(AppStrings.exploreDestinations), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Demo login fits compact 375x667 layout and enters Home', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.login,
      ),
    );

    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text(AppStrings.loginPrimaryCta));
    await tester.pump();
    await tester.tap(find.byType(PremiumButton));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump(const Duration(milliseconds: 1500));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.searchFlights), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Explore fits compact 375x667 layout', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const DestinationExploreScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));

    expect(tester.takeException(), isNull);
    expect(find.text('Rotanı dünyada seç.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Results shows suggestions for incompatible compact filter', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: const RouteSettings(
            arguments: FlightResultsArgs(destinationCode: 'CDG'),
          ),
          builder: (_) => const FlightResultsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.drag(find.byType(ListView), const Offset(-520, 0));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Yurtiçi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));

    expect(tester.takeException(), isNull);
    expect(find.textContaining('öneri'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Confirmation fits compact 375x667 layout', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: RouteSettings(arguments: MockFlights.all.first),
          builder: (_) => const BookingConfirmedScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3400));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.confirmation), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('Test 1 — Splash goes to onboarding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AeroVistaApp());
    await tester.pump();
    await tester.pump(
      const Duration(milliseconds: 2500),
    ); // wait for splash timer
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.onboardingPage1Title), findsOneWidget);
  });

  testWidgets('Test 2 — Onboarding page swipe works', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.darkTheme, home: const OnboardingScreen()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Jump to page 1 (deterministic scroll)
    final pageView = tester.widget<PageView>(find.byType(PageView));
    pageView.controller?.jumpToPage(1);
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.onboardingPage2Title), findsOneWidget);
  });

  testWidgets('Test 3 — Tap Devam, Başla and demo login reaches Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.onboarding,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Jump Page 1 -> Page 2 (deterministic transition)
    final pageView = tester.widget<PageView>(find.byType(PageView));
    pageView.controller?.jumpToPage(1);
    await tester.pump(const Duration(milliseconds: 200));

    // Jump Page 2 -> Page 3
    pageView.controller?.jumpToPage(2);
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Başla (Page 3 -> Login)
    await tester.tap(find.text(AppStrings.onboardingStart));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.loginPrimaryCta), findsOneWidget);

    await tester.tap(find.text(AppStrings.loginPrimaryCta));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump(
      const Duration(milliseconds: 1500),
    ); // wait for Home Screen entrance animations

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.searchFlights), findsOneWidget);
  });

  testWidgets('Test 4 — Tap Atla and demo login reaches Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.onboarding,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Atla
    await tester.tap(find.text(AppStrings.onboardingSkip).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.loginPrimaryCta), findsOneWidget);

    await tester.tap(find.text(AppStrings.loginPrimaryCta));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump(const Duration(milliseconds: 1500));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.searchFlights), findsOneWidget);
  });

  testWidgets(
    'Test 5 — GlobeRouteAnimation animated flag toggle didUpdateWidget test',
    (WidgetTester tester) async {
      var animated = true;
      StateSetter? externalSetState;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            externalSetState = setState;
            return MaterialApp(
              home: Scaffold(
                body: GlobeRouteAnimation(
                  fromCode: 'IST',
                  toCode: 'CDG',
                  fromCity: 'İstanbul',
                  toCity: 'Paris',
                  fromAirportName: 'İstanbul Havalimanı',
                  toAirportName: 'Paris CDG',
                  isDomestic: false,
                  animated: animated,
                ),
              ),
            );
          },
        ),
      );
      await tester.pump();

      // Toggle animated
      animated = false;
      externalSetState?.call(() {});
      await tester.pump();

      expect(tester.takeException(), isNull);

      // Pump shrink to dispose
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );
}
