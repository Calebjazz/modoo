import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../models/home_models.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName, required this.avatar});

  final String userName;
  final ActiveAvatarSummary avatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'STUDIO ATELIER // ARCHIVE ${DateTime.now().year}',
                style: AppTextStyles.eyebrow,
              ),
            ),
            const TagChip('Offline', variant: TagChipVariant.white),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'WELCOME BACK,\n${userName.toUpperCase()}',
          style: AppTextStyles.display,
        ),
        const SizedBox(height: 10),
        const Text(
          'Wear it your way. Realistic 3D garment cloth simulation ready.',
          style: AppTextStyles.lead,
        ),
        const SizedBox(height: 16),
        _AvatarLine(avatar: avatar),
      ],
    );
  }
}

class _AvatarLine extends StatelessWidget {
  const _AvatarLine({required this.avatar});

  final ActiveAvatarSummary avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.accessibility_new_rounded, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'MODEL: ${avatar.code} // ${avatar.type} // '
                      '${avatar.bodyShape} // ${avatar.heightCm}CM'
                  .toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
