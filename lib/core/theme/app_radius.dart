import 'package:flutter/material.dart';

/// AeroVista border-radius tokens.
class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 20.0;
  static const double xl = 28.0;
  static const double pill = 100.0;

  // BorderRadius helpers
  static final BorderRadius smRadius = BorderRadius.circular(sm);
  static final BorderRadius mdRadius = BorderRadius.circular(md);
  static final BorderRadius lgRadius = BorderRadius.circular(lg);
  static final BorderRadius xlRadius = BorderRadius.circular(xl);
  static final BorderRadius pillRadius = BorderRadius.circular(pill);
}
