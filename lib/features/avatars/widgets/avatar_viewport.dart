import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../models/avatar_customization.dart';

class AvatarViewport extends StatelessWidget {
  const AvatarViewport({
    super.key,
    required this.avatarCode,
    required this.heightCm,
    required this.chestCm,
    required this.waistCm,
    required this.frame,
    required this.yawDegrees,
    required this.onFrameChanged,
    required this.onYawChanged,
    required this.onRecenter,
    required this.onMeshInfo,
  });

  final String avatarCode;
  final int heightCm;
  final int chestCm;
  final int waistCm;
  final AvatarFrame frame;
  final int yawDegrees;
  final ValueChanged<AvatarFrame> onFrameChanged;
  final ValueChanged<int> onYawChanged;
  final VoidCallback onRecenter;
  final VoidCallback onMeshInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            children: [
              const StatusDot(size: 6),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'VIEWPORT: LOCAL PREVIEW',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(letterSpacing: 1.1),
                ),
              ),
              Text(
                'FPS: --  •  FOV: 38°',
                style: AppTextStyles.eyebrow.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Color(0xFFCCCCCC)),
              Positioned(
                top: 12,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIMENSIONS // ATELIER RIG',
                      style: AppTextStyles.label.copyWith(letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'H: ${heightCm}CM • C: ${chestCm}CM • W: ${waistCm}CM',
                      style: AppTextStyles.eyebrow.copyWith(
                        color: const Color(0xFF555555),
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: _FrameControl(
                  selected: frame,
                  onSelected: onFrameChanged,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.accessibility_new_rounded,
                      size: switch (frame) {
                        AvatarFrame.full => 72.0,
                        AvatarFrame.upper => 56.0,
                        AvatarFrame.head => 42.0,
                      },
                      color: const Color(0xFF888888),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'UNITY VIEWPORT NOT CONNECTED · $avatarCode',
                      style: AppTextStyles.eyebrow.copyWith(
                        color: const Color(0xFF666666),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                bottom: 10,
                child: _ViewportTag(
                  icon: Icons.rotate_right_rounded,
                  label:
                      'POS: ${yawDegrees.toString().padLeft(3, ' ')}° Y-AXIS',
                ),
              ),
              Positioned(
                right: 16,
                bottom: 10,
                child: Row(
                  children: [
                    _RoundControl(
                      tooltip: 'Rotate left',
                      icon: Icons.rotate_left_rounded,
                      onTap: () => onYawChanged(yawDegrees - 15),
                    ),
                    const SizedBox(width: 5),
                    _RoundControl(
                      tooltip: 'Recenter avatar',
                      icon: Icons.center_focus_strong_outlined,
                      onTap: onRecenter,
                    ),
                    const SizedBox(width: 5),
                    _RoundControl(
                      tooltip: 'Rotate right',
                      icon: Icons.rotate_right_rounded,
                      onTap: () => onYawChanged(yawDegrees + 15),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                bottom: 60,
                child: IconButton(
                  tooltip: 'Mesh controls',
                  onPressed: onMeshInfo,
                  icon: const Icon(Icons.polyline_rounded, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrameControl extends StatelessWidget {
  const _FrameControl({required this.selected, required this.onSelected});

  final AvatarFrame selected;
  final ValueChanged<AvatarFrame> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final frame in AvatarFrame.values)
            _FrameOption(
              frame: frame,
              selected: selected == frame,
              onTap: () => onSelected(frame),
            ),
        ],
      ),
    );
  }
}

class _FrameOption extends StatelessWidget {
  const _FrameOption({
    required this.frame,
    required this.selected,
    required this.onTap,
  });

  final AvatarFrame frame;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.black : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Text(
            frame.label.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.white : AppColors.grey,
              fontSize: 8,
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewportTag extends StatelessWidget {
  const _ViewportTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 8)),
        ],
      ),
    );
  }
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 16)),
        ),
      ),
    );
  }
}
