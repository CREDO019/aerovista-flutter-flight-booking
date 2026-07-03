# AeroVista ✈️

**A premium Flutter flight booking concept focused on cinematic motion UX, globe-based route discovery, and digital boarding pass experience.**

AeroVista is a fictional global flight reservation mobile app concept built with Flutter.  
The project does not use a backend, real booking system, payment infrastructure, or live flight data. Instead, it focuses on premium mobile UI, motion design, micro-interactions, custom route animations, and a polished portfolio-level user experience.

> AeroVista is a fictional concept brand. It is not affiliated with any airline, travel company, or real booking platform.

---

## Overview

AeroVista was designed as a premium flight booking concept where the journey feels cinematic from the first screen.

The app includes an animated onboarding flow, an immersive flight search lounge, destination discovery cards, functional flight filters, a premium flight results screen, Hero transition into a digital boarding pass, and a final booking confirmation experience built around a globe route animation.

The main goal of the project is to demonstrate:

- Advanced Flutter UI implementation
- Premium visual design
- Motion UX thinking
- CustomPainter-based animations
- Hero transitions
- Local mock data architecture
- Clean screen flow for portfolio presentation

---

## Preview

### Demo Video

Coming soon.

### Screenshots

> Add your screenshots into `media/screenshots/` and update the image paths below.

| Onboarding | Home | Explore |
|---|---|---|
| ![](media/screenshots/01_onboarding_globe.png) | ![](media/screenshots/02_home_lounge.png) | ![](media/screenshots/03_explore_destinations.png) |

| Results | Boarding Pass | Confirmation |
|---|---|---|
| ![](media/screenshots/04_results_flights.png) | ![](media/screenshots/06_boarding_pass.png) | ![](media/screenshots/07_booking_confirmed.png) |

---

## Key Features

### Cinematic Onboarding

A short premium onboarding flow introduces the main experience before the user reaches the home screen.

- Globe-based route preview
- Premium motion transitions
- Skip and continue actions
- Turkish UX copy
- Dark aviation-inspired visual system

---

### AeroVista Lounge Home Screen

The home screen is designed as a cinematic airport lounge interface.

- Premium dark background
- Floating flight console
- Glassmorphism panels
- Animated route preview
- Custom aircraft marker
- Turkish flight search UI
- Smooth entrance choreography

---

### Globe-Based Route Experience

One of the core visual elements of AeroVista is the globe route animation.

- Local map texture / globe visual system
- Route visualization between airports
- Custom airplane marker
- Animated flight path
- Departure and arrival nodes
- Domestic and international flight support
- Performance-focused layered rendering

---

### Destination Discovery

The Explore screen allows users to discover domestic and international destinations.

- Horizontal parallax cards
- Destination-specific visual identity
- Domestic and international route categories
- Airport code and airport name display
- Route preview
- Destination-based navigation into flight results

Example destinations:

- Paris
- Tokyo
- New York
- London
- Ankara
- İzmir
- Antalya
- Trabzon
- Kapadokya

---

### Functional Flight Filters

The flight results screen includes working local filters using mock data.

Filters include:

- Recommended
- Cheapest
- Fastest
- Morning
- Evening
- Domestic
- International
- Direct

The filtering logic works locally without any backend.

---

### Premium Flight Results

The Results screen presents flight options in a premium airline-style console.

Each card includes:

- Flight number
- Cabin
- Departure and arrival time
- Airport code and airport name
- Duration
- Baggage info
- Domestic / international badge
- Direct / stop information
- Price module
- Hero transition source for boarding pass

---

### Digital Boarding Pass

The selected flight opens into a digital boarding pass experience.

- Hero transition from flight card
- Premium boarding pass layout
- Route information
- Airport names
- Passenger details
- Seat, gate, baggage, cabin
- QR-style placeholder
- Concept ticket warning

---

### Booking Confirmation

The confirmation screen acts as the final cinematic moment of the app.

- Globe route animation
- Arrival confirmation state
- Booking reference
- Flight summary
- Premium confirmation card
- Return to boarding pass
- Back to home action

---

## Tech Stack

- **Flutter**
- **Dart**
- **Material 3**
- **flutter_animate**
- **google_fonts**
- **CustomPainter**
- **Hero animations**
- **Local mock data**

---

## Architecture

The project uses a clean feature-based Flutter structure.

```txt
lib/
├── app/
│   ├── app_routes.dart
│   └── aerovista_app.dart
│
├── core/
│   ├── constants/
│   └── theme/
│
├── data/
│   ├── mock_destinations.dart
│   └── mock_flights.dart
│
├── models/
│   ├── destination_model.dart
│   └── flight_model.dart
│
├── shared/
│   └── widgets/
│       ├── premium_button.dart
│       ├── premium_plane_marker.dart
│       └── globe_route/
│
└── features/
    ├── onboarding/
    ├── splash/
    ├── home/
    ├── explore/
    ├── results/
    ├── boarding_pass/
    └── confirmation/
