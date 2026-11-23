import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Shows a local image when [imagePath] is provided, otherwise a neutral
/// monochrome placeholder. Real thumbnails/renders replace the placeholder
/// once licensed assets are added to the project.
class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({
    super.key,
    this.imagePath,
    this.dark = false,
    this.icon = Icons.image_outlined,
    this.caption,
  });

  final String? imagePath;
  final bool dark;
  final IconData icon;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        // File not added yet → show the neutral placeholder instead.
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    final foreground = dark
        ? AppColors.placeholderDarkIcon
        : AppColors.placeholderLightIcon;

    return ColoredBox(
      color: dark ? AppColors.placeholderDark : AppColors.placeholderLight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: foreground),
            if (caption != null) ...[
              const SizedBox(height: 10),
              Text(
                caption!.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.eyebrow.copyWith(color: foreground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
