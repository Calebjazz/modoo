import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/media_placeholder.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/tag_chip.dart';

/// Large avatar preview card. The preview area will host the Unity view
/// once the Flutter–Unity integration is proven (CLAUDE.md §11).
class StudioPreviewCard extends StatelessWidget {
  const StudioPreviewCard({
    super.key,
    required this.lookName,
    this.imagePath,
    required this.piecesMounted,
    required this.piecesTotal,
    required this.onStartStyling,
    required this.onCustomize,
    required this.onQuickDress,
  });

  final String lookName;
  final String? imagePath;
  final int piecesMounted;
  final int piecesTotal;
  final VoidCallback onStartStyling;
  final VoidCallback onCustomize;
  final VoidCallback onQuickDress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 340,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MediaPlaceholder(
                    imagePath: imagePath,
                    icon: Icons.accessibility_new_rounded,
                    caption: '3D preview · Unity pending',
                  ),
                  const Positioned(
                    top: 12,
                    left: 12,
                    child: TagChip(
                      'CAM: 360  ISO',
                      variant: TagChipVariant.white,
                      leading: Icon(Icons.threesixty_rounded),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: TagChip(
                      'PHYSICS: RIGID 60FPS',
                      variant: TagChipVariant.white,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TagChip(
                        'LOOK: ${lookName.toUpperCase()}',
                        variant: TagChipVariant.dark,
                        leading: const StatusDot(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'PIECES MOUNTED ($piecesMounted/$piecesTotal)',
                    style: AppTextStyles.eyebrow,
                  ),
                ),
                TextButton(
                  onPressed: onQuickDress,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 36),
                  ),
                  child: Text(
                    'QUICK DRESS',
                    style: AppTextStyles.label.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: PillButton(
                    label: 'Start styling',
                    trailingIcon: Icons.arrow_forward_rounded,
                    expand: true,
                    onPressed: onStartStyling,
                  ),
                ),
                const SizedBox(width: 8),
                PillButton(
                  label: 'Customize',
                  icon: Icons.tune_rounded,
                  variant: PillButtonVariant.ghost,
                  onPressed: onCustomize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
