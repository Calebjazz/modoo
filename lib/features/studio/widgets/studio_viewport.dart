import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../models/studio_garment.dart';

class StudioViewport extends StatelessWidget {
  const StudioViewport({
    super.key,
    required this.avatarName,
    required this.viewName,
    required this.zoomPercent,
    required this.mountedGarments,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRemoveGarment,
    required this.onDropGarment,
    required this.onFeatureTap,
  });

  final String avatarName;
  final String viewName;
  final int zoomPercent;
  final Map<StudioGarmentSlot, StudioGarment> mountedGarments;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final ValueChanged<StudioGarmentSlot> onRemoveGarment;
  final ValueChanged<StudioGarment> onDropGarment;
  final ValueChanged<String> onFeatureTap;

  @override
  Widget build(BuildContext context) {
    return DragTarget<StudioGarment>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => onDropGarment(details.data),
      builder: (context, candidates, rejected) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const CustomPaint(painter: _StudioBackdropPainter()),
              Positioned(
                left: 10,
                top: 10,
                right: 60,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final entry in mountedGarments.entries)
                      _MountedGarmentChip(
                        garment: entry.value,
                        onRemove: () => onRemoveGarment(entry.key),
                      ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: zoomPercent / 100,
                      child: Icon(
                        Icons.accessibility_new_rounded,
                        size: 130,
                        color: AppColors.black.withValues(alpha: 0.88),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 138,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.18),
                        border: Border.all(
                          color: AppColors.black.withValues(alpha: 0.34),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(100, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 8,
                child: _ZoomControl(
                  zoomPercent: zoomPercent,
                  onZoomIn: onZoomIn,
                  onZoomOut: onZoomOut,
                ),
              ),
              Positioned(
                right: 8,
                top: 118,
                child: Column(
                  children: [
                    _ViewportAction(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Key',
                      onTap: () => onFeatureTap('Studio lighting'),
                    ),
                    const SizedBox(height: 7),
                    _ViewportAction(
                      icon: Icons.accessibility_new_rounded,
                      label: 'Pose',
                      onTap: () => onFeatureTap('Pose controls'),
                    ),
                    const SizedBox(height: 7),
                    _ViewportAction(
                      icon: Icons.grain_rounded,
                      label: 'Mesh',
                      onTap: () => onFeatureTap('Mesh controls'),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: TagChip(
                  'Preview only · Unity offline',
                  variant: TagChipVariant.dark,
                  leading: const StatusDot(color: AppColors.white),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 13,
                child: Center(
                  child: Text(
                    '$avatarName · $viewName',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.black.withValues(alpha: 0.58),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              if (candidates.isNotEmpty)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.35),
                      border: Border.all(color: AppColors.black, width: 2),
                    ),
                    child: const Center(
                      child: TagChip(
                        'Drop to select for preview',
                        variant: TagChipVariant.dark,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MountedGarmentChip extends StatelessWidget {
  const _MountedGarmentChip({required this.garment, required this.onRemove});

  final StudioGarment garment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StatusDot(size: 5),
            const SizedBox(width: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 105),
              child: Text(
                '${garment.slotLabel}: ${garment.name}'.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label.copyWith(fontSize: 8),
              ),
            ),
            IconButton(
              tooltip: 'Remove ${garment.name} from preview',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints.tightFor(width: 25, height: 25),
              padding: EdgeInsets.zero,
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomControl extends StatelessWidget {
  const _ZoomControl({
    required this.zoomPercent,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  final int zoomPercent;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          IconButton(
            tooltip: 'Zoom in',
            visualDensity: VisualDensity.compact,
            onPressed: onZoomIn,
            icon: const Icon(Icons.add_rounded, size: 19),
          ),
          Text(
            '$zoomPercent%',
            style: AppTextStyles.label.copyWith(fontSize: 8),
          ),
          IconButton(
            tooltip: 'Zoom out',
            visualDensity: VisualDensity.compact,
            onPressed: onZoomOut,
            icon: const Icon(Icons.remove_rounded, size: 19),
          ),
        ],
      ),
    );
  }
}

class _ViewportAction extends StatelessWidget {
  const _ViewportAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$label controls require Unity',
      child: Material(
        color: AppColors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17),
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.label.copyWith(fontSize: 6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudioBackdropPainter extends CustomPainter {
  const _StudioBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE7E7E7), BlendMode.src);

    final wall = Paint()..color = const Color(0xFFF3F3F3);
    final arch = Path()
      ..moveTo(0, size.height * 0.64)
      ..lineTo(0, size.height * 0.35)
      ..cubicTo(
        0,
        size.height * 0.12,
        size.width * 0.18,
        0,
        size.width * 0.5,
        0,
      )
      ..cubicTo(
        size.width * 0.82,
        0,
        size.width,
        size.height * 0.12,
        size.width,
        size.height * 0.35,
      )
      ..lineTo(size.width, size.height * 0.64)
      ..close();
    canvas.drawPath(arch, wall);

    final arcPaint = Paint()
      ..color = const Color(0xFFD4D4D4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromLTWH(
        -size.width * 0.16,
        -size.height * 0.42,
        size.width * 1.32,
        size.height * 1.25,
      ),
      0.16,
      math.pi - 0.32,
      false,
      arcPaint,
    );

    final floorPaint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height * 0.66),
      Offset(size.width, size.height * 0.66),
      floorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StudioBackdropPainter oldDelegate) => false;
}
