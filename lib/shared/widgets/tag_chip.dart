import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum TagChipVariant { light, dark, white }

/// Small uppercase technical label, e.g. "BLAZER M-9" or "LOOK #01".
class TagChip extends StatelessWidget {
  const TagChip(
    this.text, {
    super.key,
    this.variant = TagChipVariant.light,
    this.leading,
  });

  final String text;
  final TagChipVariant variant;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      TagChipVariant.light => (AppColors.surface, AppColors.black),
      TagChipVariant.dark => (AppColors.black, AppColors.white),
      TagChipVariant.white => (AppColors.white, AppColors.black),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: variant == TagChipVariant.white
            ? Border.all(color: AppColors.border)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            IconTheme(
              data: IconThemeData(color: foreground, size: 12),
              child: leading!,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small filled dot used inside chips and status lines.
class StatusDot extends StatelessWidget {
  const StatusDot({super.key, this.color, this.size = 6});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? IconTheme.of(context).color ?? AppColors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
