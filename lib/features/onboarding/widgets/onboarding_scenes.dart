import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/premium_plane_marker.dart';
import '../../boarding_pass/widgets/qr_placeholder.dart';

/// Premium Mock Flight Console visual for Onboarding Page 2.
class OnboardingConsoleScene extends StatelessWidget {
  const OnboardingConsoleScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 170,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.38),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildMiniChip('Önerilen', true),
              const SizedBox(width: AppSpacing.xs),
              _buildMiniChip('En Uygun', false),
              const SizedBox(width: AppSpacing.xs),
              _buildMiniChip('Direkt', false),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                borderRadius: AppRadius.mdRadius,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAirport('IST', 'İstanbul'),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                              ),
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            const PremiumPlaneMarker(
                              size: 14,
                              variant: PlaneMarkerVariant.minimal,
                              glow: false,
                            ),
                          ],
                        ),
                      ),
                      _buildAirport('CDG', 'Paris'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '08:45',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '3s 25d',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.42),
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        '12:10',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? AppColors.airlineRed.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(
          color: active
              ? AppColors.airlineRed
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.54),
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAirport(String code, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

/// Premium Boarding Pass visual preview for Onboarding Page 3.
class OnboardingTicketScene extends StatelessWidget {
  const OnboardingTicketScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.38),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildColumn('YOLCU', 'ALİ YILMAZ'),
                    _buildColumn('KOLTUK', '12A'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildColumn('UÇUŞ', 'TK 1821'),
                    _buildColumn('SINIF', 'Business'),
                  ],
                ),
              ],
            ),
          ),
          // Perforated line effect
          Row(
            children: List.generate(
              15,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  height: 1.0,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Demo QR code preview
                  const QrPlaceholder(
                    size: 48,
                    padding: 5,
                    backgroundColor: Color(0xFFF7F8FA),
                    inkColor: AppColors.deepNavy,
                  ),
                  // Success check circle
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.airlineRed, AppColors.deepRed],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.airlineRed.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.36),
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
