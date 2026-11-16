import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickAccessItem {
  const QuickAccessItem({
    required this.icon,
    required this.title,
    required this.caption,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String caption;
  final VoidCallback onTap;
}

/// Row of shortcut tiles (Wardrobe, Saved Looks, Pose Lab).
class QuickAccessRow extends StatelessWidget {
  const QuickAccessRow({super.key, required this.items});

  final List<QuickAccessItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: _QuickAccessTile(item: items[i])),
        ],
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({required this.item});

  final QuickAccessItem item;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: AppColors.border),
    );

    return Material(
      color: AppColors.white,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 8, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 18),
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tileTitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                item.caption.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.eyebrow.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
