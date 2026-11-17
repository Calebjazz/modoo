import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/models/home_models.dart';

class ProfileAvatarCard extends StatelessWidget {
  const ProfileAvatarCard({
    super.key,
    required this.avatar,
    required this.onOpenStudio,
  });

  final ActiveAvatarSummary avatar;
  final VoidCallback onOpenStudio;

  @override
  Widget build(BuildContext context) => Container(
    width: 164,
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 12,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(
            height: 124,
            width: double.infinity,
            child: ColoredBox(
              color: Color(0xFFF1F1F1),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.accessibility_new_rounded,
                      size: 54,
                      color: Color(0xFFB4B4B4),
                    ),
                    Text(
                      '3D PREVIEW PENDING',
                      style: AppTextStyles.eyebrow.copyWith(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(avatar.code, style: AppTextStyles.label),
        const SizedBox(height: 2),
        Text(
          '${avatar.heightCm} CM  //  ${avatar.type.toUpperCase()}  //  '
          '${avatar.bodyShape.toUpperCase()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.eyebrow.copyWith(fontSize: 9),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 32,
          child: FilledButton.icon(
            onPressed: onOpenStudio,
            icon: const Icon(Icons.view_in_ar_rounded, size: 14),
            label: Text(
              'IN STUDIO',
              style: AppTextStyles.button.copyWith(
                color: AppColors.white,
                fontSize: 9,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    ),
  );
}
