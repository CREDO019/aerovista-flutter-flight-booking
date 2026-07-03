import 'package:flutter/material.dart';

class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.visual,
  });

  final String title;
  final String subtitle;
  final Widget visual;
}
