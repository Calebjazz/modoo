import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Inline, centered error shown under the form (e.g. wrong password).
class AuthMessage extends StatelessWidget {
  const AuthMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.label.copyWith(letterSpacing: 0.2, fontSize: 12),
        ),
      ),
    );
  }
}
