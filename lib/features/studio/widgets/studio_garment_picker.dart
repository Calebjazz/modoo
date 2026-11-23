import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/studio_garment.dart';

class StudioGarmentPicker extends StatelessWidget {
  const StudioGarmentPicker({
    super.key,
    required this.category,
    required this.mountedGarments,
    required this.onCategoryChanged,
    required this.onGarmentSelected,
    required this.onGarmentRemoved,
  });

  final StudioGarmentCategory category;
  final Map<StudioGarmentSlot, StudioGarment> mountedGarments;
  final ValueChanged<StudioGarmentCategory> onCategoryChanged;
  final ValueChanged<StudioGarment> onGarmentSelected;
  final ValueChanged<StudioGarmentSlot> onGarmentRemoved;

  @override
  Widget build(BuildContext context) {
    final items = StudioPreviewCatalog.items
        .where((item) => item.category == category)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final value in StudioGarmentCategory.values) ...[
                if (value != StudioGarmentCategory.values.first)
                  const SizedBox(width: 7),
                _CategoryButton(
                  label:
                      '${value.label} [${StudioPreviewCatalog.countIn(value)}]',
                  selected: category == value,
                  onTap: () => onCategoryChanged(value),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            const Icon(
              Icons.touch_app_outlined,
              size: 14,
              color: AppColors.grey,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                'TAP TO FIT · DRAG ONTO PREVIEW',
                style: AppTextStyles.eyebrow.copyWith(fontSize: 8),
              ),
            ),
            Text(
              'SAMPLE PICKS',
              style: AppTextStyles.eyebrow.copyWith(fontSize: 8),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 142,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final item = items[index];
              return _GarmentCard(
                garment: item,
                isMounted: mountedGarments[item.slot]?.id == item.id,
                onSelected: () => onGarmentSelected(item),
                onRemoved: () => onGarmentRemoved(item.slot),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.black : AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.white : AppColors.grey,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _GarmentCard extends StatelessWidget {
  const _GarmentCard({
    required this.garment,
    required this.isMounted,
    required this.onSelected,
    required this.onRemoved,
  });

  final StudioGarment garment;
  final bool isMounted;
  final VoidCallback onSelected;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    final card = SizedBox(
      width: 128,
      child: Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isMounted ? AppColors.black : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelected,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.placeholderLight),
                    Center(
                      child: Icon(
                        garment.icon,
                        size: 48,
                        color: AppColors.placeholderDarkIcon,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: _PreviewBadge(
                        label: isMounted ? 'Worn' : 'Preview only',
                        selected: isMounted,
                      ),
                    ),
                    if (isMounted)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: IconButton(
                          tooltip: 'Remove ${garment.name}',
                          onPressed: onRemoved,
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 15,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.white,
                            fixedSize: const Size(26, 26),
                            minimumSize: const Size(26, 26),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 7, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      garment.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label.copyWith(letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            garment.material.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.eyebrow.copyWith(fontSize: 7),
                          ),
                        ),
                        Text(
                          garment.finish.toUpperCase(),
                          style: AppTextStyles.eyebrow.copyWith(fontSize: 7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Draggable<StudioGarment>(
      data: garment,
      feedback: Material(
        color: AppColors.white,
        elevation: 4,
        child: SizedBox(
          width: 128,
          height: 142,
          child: Center(
            child: Icon(garment.icon, size: 44, color: AppColors.grey),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: card),
      child: card,
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: selected ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          color: selected ? AppColors.white : AppColors.black,
          fontSize: 6,
        ),
      ),
    );
  }
}
