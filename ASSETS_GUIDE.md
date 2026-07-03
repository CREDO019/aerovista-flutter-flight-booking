# Destination Photo Integration Guide

This guide details the asset-based visual design system of the **AeroVista** horizontal explore cards. It outlines files, style directions, compression requirements, and the automatic fail-safe fallback architecture.

---

## 1. Asset Directory & Required Files

All photos are stored locally and loaded using standard `Image.asset`. No HTTP network calls are made.

**Target Directory:**
`assets/destinations/`

**Expected Image Files:**
* `paris.jpg` (Eiffel Tower & twilight mood)
* `tokyo.jpg` (Shibuya Crossing night skyline & neon)
* `new_york.jpg` (Manhattan skyscrapers at sunset)
* `london.jpg` (Tower Bridge under dramatic rain)
* `cappadocia.jpg` (Hot air balloons over rock valleys at sunrise)
* `ankara.jpg` (Capital skyline / clean geometry)
* `izmir.jpg` (Aegean seaside & sunset reflections)
* `antalya.jpg` (Coastal cliffs & yacht marina harbor)
* `trabzon.jpg` (Karadeniz Uzungöl green lake & misty forest)

---

## 2. Style Recommendations for New Assets

When adding or replacing destination visuals:
1. **Aspect Ratio**: Prefer vertical layout photography or high-resolution wide photos with clear central details. The cards use `BoxFit.cover` with a slight scale multiplier (`1.08`), cropping margins during active parallax motion.
2. **Atmosphere & Lighting**: Select dark, twilight, dawn, or high-contrast night shots. Avoid overly bright daytime photography to maintain the dark Lounge aesthetic of AeroVista.
3. **Brand Coloring**: Select images that feature warm oranges, golds, deep blues, and teals that match the AeroVista brand system and visual highlights.
4. **Legibility**: Ensure no noisy or bright details are in the top-left or bottom-left corners where text (city names, descriptions, and CTAs) is displayed.

---

## 3. Compression & Performance Best Practices

To maintain high rendering performance (60/120fps) on physical devices:
* **Dimensions**: Limit max height/width to **1024px** or **1200px**.
* **File Format**: Use `.jpg` with medium-high compression (quality 80-85%).
* **File Size**: Aim for under **150KB** per image.
* **Avoid Backdrop Filters**: Avoid putting heavy blurs or custom filters over the photo layer on scroll to prevent frame-rate stuttering.

---

## 4. Fail-Safe Fallback Mechanism

If any image file is missing from the bundle or cannot be loaded at runtime, the app will **never crash** or show a red error screen.
* **Mechanism**: The card background is wrapped in an `errorBuilder` on `Image.asset`.
* **Behavior**: If the loader catches an asset exception, it immediately renders the `DestinationGradientPainter` custom painter as a backup.
* **Visuals**: The fallback painter draws custom abstract vector landmarks (e.g., Anıtkabir columns for Ankara, seaside waves for İzmir, hot air balloons for Cappadocia) over a localized color gradient background.
