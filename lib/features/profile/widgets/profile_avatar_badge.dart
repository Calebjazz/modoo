import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileAvatarBadge extends StatelessWidget {
  const ProfileAvatarBadge({super.key, required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      CircleAvatar(
        radius: 46,
        backgroundColor: AppColors.black,
        child: Text(
          initials,
          style: AppTextStyles.display.copyWith(
            color: AppColors.white,
            fontSize: 30,
          ),
        ),
      ),
      Positioned(
        right: -9,
        top: 0,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            child: Text(
              'ATELIER',
              style: AppTextStyles.label.copyWith(
                color: AppColors.white,
                fontSize: 9,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
