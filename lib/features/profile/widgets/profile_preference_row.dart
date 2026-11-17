import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfilePreferenceRow extends StatelessWidget {
  const ProfilePreferenceRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.tileTitle),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            child,
          ],
        ),
      ),
      if (showDivider)
        const Divider(height: 1, thickness: 1, color: AppColors.border),
    ],
  );
}
