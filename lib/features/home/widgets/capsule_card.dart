import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/media_placeholder.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../models/home_models.dart';

class CapsuleCard extends StatelessWidget {
  const CapsuleCard({super.key, required this.capsule, required this.onOpen});

  final CapsulePreview capsule;
  final VoidCallback onOpen;

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 190,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MediaPlaceholder(
                    imagePath: capsule.imagePath,
                    dark: true,
                    icon: Icons.checkroom_outlined,
                  ),
                  Positioned(
                    left: 16,
                    right: 110,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CAPSULE ${_two(capsule.number)} // DROP ${_two(capsule.drop)}',
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          capsule.title.toUpperCase(),
                          style: AppTextStyles.overlayTitle,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 14,
                    bottom: 16,
                    child: TagChip(
                      '${capsule.pieceCount} pieces',
                      variant: TagChipVariant.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 2, 2),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(child: TagChip(capsule.fabric)),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          capsule.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CircleIconButton(
                  icon: Icons.arrow_forward_rounded,
                  tooltip: 'Open ${capsule.title}',
                  onPressed: onOpen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
