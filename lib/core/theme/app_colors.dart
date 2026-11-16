import 'package:flutter/material.dart';

/// Strictly monochrome palette (CLAUDE.md §7). No accent colours.
abstract final class AppColors {
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF808080);
  static const border = Color(0xFFE6E6E6);
  static const surface = Color(0xFFF4F4F4);
  static const placeholderLight = Color(0xFFE9E9E9);
  static const placeholderLightIcon = Color(0xFFB4B4B4);
  static const placeholderDark = Color(0xFF1C1C1C);
  static const placeholderDarkIcon = Color(0xFF555555);
}
