import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/media_placeholder.dart';
import '../../../shared/widgets/pill_button.dart';
import '../models/saved_look.dart';

class SavedLookCard extends StatelessWidget {
  const SavedLookCard({
    super.key,
    required this.look,
    required this.onEdit,
    required this.onMore,
    required this.onStudio,
    required this.onDress,
  });

  final SavedLook look;
  final VoidCallback onEdit;
  final VoidCallback onMore;
  final VoidCallback onStudio;
  final VoidCallback onDress;

  @override
  Widget build(BuildContext context) {
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
                        child: Container(
                          height: 30,
                          constraints: const BoxConstraints(maxWidth: 230),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'LOOK ${look.number.toString().padLeft(2, '0')}'
                            ' // ${look.title.toUpperCase()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          look.date,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.grey,
                            fontSize: 9,
                          ),
                        ),
                      ),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${look.itemCount} ITEMS TAGGED',
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
                          Text(look.title, style: AppTextStyles.title),
                          const SizedBox(height: 4),
                          Text(
                            look.description,
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
                    IconButton(
                      onPressed: onEdit,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit look',
                    ),
                    IconButton(
                      onPressed: onMore,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.more_vert, size: 18),
                      tooltip: 'More options',
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
                        icon: Icons.download_outlined,
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
