import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/media_placeholder.dart';
import '../../../shared/widgets/pill_button.dart';
import '../models/outfit.dart';

class SavedLookCard extends StatelessWidget {
  const SavedLookCard({
    super.key,
    required this.look,
    required this.number,
    required this.badge,
    required this.onEdit,
    required this.onMore,
    required this.onStudio,
    required this.onDress,
  });

  final Outfit look;
  final int number;

  /// Short label in the top-right pill, e.g. a date or `CURATED`.
  final String badge;
  final VoidCallback onEdit;
  final VoidCallback onMore;
  final VoidCallback onStudio;
  final VoidCallback onDress;

  @override
  Widget build(BuildContext context) {
    final itemCount = look.garments.length;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.12,
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
                  right: 10,
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _Pill(
                            label:
                                'LOOK ${number.toString().padLeft(2, '0')}'
                                ' // ${look.name.toUpperCase()}',
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(label: badge, color: AppColors.grey),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$itemCount ${itemCount == 1 ? 'ITEM' : 'ITEMS'} TAGGED',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(look.name, style: AppTextStyles.title),
                          const SizedBox(height: 4),
                          Text(
                            look.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RoundIcon(
                      icon: Icons.edit_outlined,
                      tooltip: 'Edit in studio',
                      onPressed: onEdit,
                    ),
                    const SizedBox(width: 6),
                    _RoundIcon(
                      icon: Icons.more_vert,
                      tooltip: 'More options',
                      onPressed: onMore,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: PillButton(
                        label: 'Studio View',
                        icon: Icons.view_in_ar_outlined,
                        variant: PillButtonVariant.tonal,
                        expand: true,
                        onPressed: onStudio,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PillButton(
                        label: 'Dress Avatar',
                        icon: Icons.accessibility_new_rounded,
                        expand: true,
                        onPressed: onDress,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    height: 30,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    alignment: Alignment.center,
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.label.copyWith(
        color: color,
        fontSize: 9,
        letterSpacing: 0.8,
      ),
    ),
  );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(icon, size: 16, color: AppColors.black),
    style: IconButton.styleFrom(
      backgroundColor: AppColors.surface,
      fixedSize: const Size(34, 34),
      minimumSize: const Size(34, 34),
      padding: EdgeInsets.zero,
    ),
  );
}
