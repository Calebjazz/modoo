import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/media_placeholder.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../models/home_models.dart';

class LookCard extends StatelessWidget {
  const LookCard({
    super.key,
    required this.look,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onReapply,
  });

  static const double width = 210;

  final LookPreview look;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onReapply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MediaPlaceholder(
                  imagePath: look.imagePath,
                  icon: Icons.checkroom_outlined,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: TagChip(
                    'Look #${look.number.toString().padLeft(2, '0')}',
                    variant: TagChipVariant.dark,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: TagChip(look.line, variant: TagChipVariant.white),
                ),
                Positioned(
                  right: 10,
                  bottom: 8,
                  child: CircleIconButton(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    tooltip: isFavorite ? 'Remove favourite' : 'Favourite',
                    dark: false,
                    size: 34,
                    onPressed: onFavoriteToggle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(look.title, style: AppTextStyles.title),
                  const SizedBox(height: 4),
                  Text(
                    look.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final tag in look.tags) TagChip(tag)],
                  ),
                  const Spacer(),
                  const SizedBox(height: 14),
                  PillButton(
                    label: 'Reapply in studio',
                    icon: Icons.view_in_ar_outlined,
                    variant: PillButtonVariant.tonal,
                    expand: true,
                    onPressed: onReapply,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
