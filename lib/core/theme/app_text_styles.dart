import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography built only on the bundled Inter weights (200 and 500).
abstract final class AppTextStyles {
  static const String fontFamily = 'Inter';

  static const _light = FontWeight.w200;
  static const _medium = FontWeight.w500;

  /// Large uppercase headline, e.g. "WELCOME BACK, ELENA".
  static const display = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 30,
    height: 1.05,
    letterSpacing: -0.8,
    color: AppColors.black,
  );

  /// Section headline, e.g. "RECENT LOOKS".
  static const sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 26,
    height: 1.05,
    letterSpacing: -0.6,
    color: AppColors.black,
  );

  /// Small spaced uppercase overline, e.g. "ATELIER ARCHIVES".
  static const eyebrow = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 10,
    height: 1.2,
    letterSpacing: 1.6,
    color: AppColors.grey,
  );

  /// Technical chip / tag label.
  static const label = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 10,
    height: 1.2,
    letterSpacing: 1.0,
    color: AppColors.black,
  );

  static const button = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 1.2,
    color: AppColors.black,
  );

  static const lead = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _light,
    fontSize: 16,
    height: 1.4,
    color: AppColors.black,
  );

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 17,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.black,
  );

  static const tileTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 14,
    height: 1.2,
    color: AppColors.black,
  );

  /// Card overlay title on dark imagery, e.g. "MONOLITH CAPSULE".
  static const overlayTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 20,
    height: 1.1,
    letterSpacing: -0.4,
    color: AppColors.white,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _light,
    fontSize: 13,
    height: 1.4,
    color: AppColors.black,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _light,
    fontSize: 12,
    height: 1.3,
    color: AppColors.black,
  );

  static const navLabel = TextStyle(
    fontFamily: fontFamily,
    fontWeight: _medium,
    fontSize: 9,
    height: 1.2,
    letterSpacing: 0.8,
  );
}
