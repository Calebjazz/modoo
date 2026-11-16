import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum PillButtonVariant { filled, tonal, ghost }

/// Rounded stadium button used for primary and secondary actions.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillButtonVariant.filled,
    this.icon,
    this.trailingIcon,
    this.expand = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final PillButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool expand;

  /// Shows a spinner and ignores taps while an action is running.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      PillButtonVariant.filled => (AppColors.black, AppColors.white),
      PillButtonVariant.tonal => (AppColors.surface, AppColors.black),
      PillButtonVariant.ghost => (Colors.transparent, AppColors.black),
    };

    return Material(
      color: background,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: loading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: loading
              ? Row(
                  mainAxisSize:
                      expand ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        color: foreground,
                      ),
                    ),
                  ],
                )
              : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.button.copyWith(color: foreground),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 16, color: foreground),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Solid black circular icon button, e.g. the capsule arrow.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 36,
    this.dark = true,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: dark ? AppColors.black : AppColors.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Icon(
              icon,
              size: size * 0.5,
              color: dark ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
