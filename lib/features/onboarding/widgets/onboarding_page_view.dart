import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'onboarding_page_model.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.pages,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<OnboardingPageModel> pages;
  final ValueChanged<int> onPageChanged;

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _pageOffset = widget.controller.page ?? 0.0;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.pages.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return OnboardingPageWidget(
          index: index,
          pageOffset: _pageOffset,
          model: widget.pages[index],
        );
      },
    );
  }
}

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({
    super.key,
    required this.index,
    required this.pageOffset,
    required this.model,
  });

  final int index;
  final double pageOffset;
  final OnboardingPageModel model;

  @override
  Widget build(BuildContext context) {
    final double relativePos = index - pageOffset;
    final double opacity = (1.0 - relativePos.abs()).clamp(0.0, 1.0);
    final double scale = 1.0 - (relativePos.abs() * 0.12);
    final double translationY = relativePos.abs() * 32.0;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translationY),
        child: Transform.scale(
          scale: scale,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center(child: model.visual)),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      model.subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.54),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
