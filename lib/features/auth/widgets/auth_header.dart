import 'package:flutter/material.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Centered brand mark, title and subtitle for the auth screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.view_in_ar_rounded,
            color: AppColors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppInfo.name,
          textAlign: TextAlign.center,
          style: AppTextStyles.label.copyWith(fontSize: 12, letterSpacing: 6),
        ),
        const SizedBox(height: 32),
        Text(
          eyebrow.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.eyebrow,
        ),
        const SizedBox(height: 10),
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.display,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.lead.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
