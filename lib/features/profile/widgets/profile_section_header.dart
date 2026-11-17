import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 17, color: AppColors.black),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: AppTextStyles.label.copyWith(
            fontSize: 11,
            letterSpacing: 1.05,
          ),
        ),
      ),
      ?trailing,
    ],
  );
}
