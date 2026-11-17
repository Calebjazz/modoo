import 'package:flutter/material.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key, required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      children: [
        TextButton(
          onPressed: onSignOut,
          style: TextButton.styleFrom(foregroundColor: AppColors.grey),
          child: Text(
            'SIGN OUT OF ATELIER',
            style: AppTextStyles.eyebrow.copyWith(letterSpacing: 1.4),
          ),
        ),
        Text(
          '${AppInfo.name}  //  V${AppInfo.version}',
          style: AppTextStyles.eyebrow.copyWith(
            color: AppColors.border,
            fontSize: 9,
          ),
        ),
      ],
    ),
  );
}
