import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Reusable airport identity column displayed throughout the app.
///
/// Layout:
///   IST              ← large IATA code
///   İstanbul         ← city name (secondary)
///   İstanbul Hav.    ← airport name (caption, optional, ellipsis)
///
/// Parameters:
///   [code]          — IATA code, e.g. "IST"
///   [city]          — city name, e.g. "İstanbul"
///   [airportName]   — full airport name (shown as small caption)
///   [codeSize]      — font size for the IATA code (default 32)
///   [alignRight]    — right-aligns all text (for destination side)
///   [compact]       — reduces font sizes for tight spaces
///   [showAirportName] — whether to render the third line
class AirportIdentityColumn extends StatelessWidget {
  const AirportIdentityColumn({
    super.key,
    required this.code,
    required this.city,
    this.airportName,
    this.codeSize = 32,
    this.alignRight = false,
    this.compact = false,
    this.showAirportName = true,
  });

  final String code;
  final String city;
  final String? airportName;
  final double codeSize;
  final bool alignRight;
  final bool compact;
  final bool showAirportName;

  @override
  Widget build(BuildContext context) {
    final cross = alignRight
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    final effectiveCodeSize = compact ? codeSize * 0.82 : codeSize;

    return Column(
      crossAxisAlignment: cross,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── IATA code — dominant ─────────────────────────────────────
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            code,
            style: AppTextStyles.display.copyWith(
              fontSize: effectiveCodeSize,
              letterSpacing: 1.2,
              height: 1,
            ),
          ),
        ),

        const SizedBox(height: 2),

        // ── City name — secondary ────────────────────────────────────
        Text(
          city,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: compact ? 10 : 11,
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // ── Airport name — caption (optional) ────────────────────────
        if (showAirportName && airportName != null && airportName!.isNotEmpty)
          Text(
            airportName!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.60),
              fontSize: compact ? 8 : 9,
              letterSpacing: 0.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
