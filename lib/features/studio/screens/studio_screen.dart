import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pill_button.dart';
import '../models/studio_garment.dart';
import '../widgets/studio_garment_picker.dart';
import '../widgets/studio_viewport.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  static final _initialGarments = <StudioGarmentSlot, StudioGarment>{
    StudioGarmentSlot.outerwear: StudioPreviewCatalog.items[8],
    StudioGarmentSlot.top: StudioPreviewCatalog.items[1],
    StudioGarmentSlot.bottom: StudioPreviewCatalog.items[3],
  };

  String _avatar = 'AURA';
  String _view = 'FRONT';
  int _zoomPercent = 100;
  StudioGarmentCategory _category = StudioGarmentCategory.tops;
  Map<StudioGarmentSlot, StudioGarment> _mountedGarments = {
    ..._initialGarments,
  };

  void _fitGarment(StudioGarment garment) {
    setState(() {
      _mountedGarments = {..._mountedGarments, garment.slot: garment};
    });
  }

  void _removeGarment(StudioGarmentSlot slot) {
    setState(() {
      _mountedGarments = Map.of(_mountedGarments)..remove(slot);
    });
  }

  void _showUnavailable(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$feature requires the Unity preview, which is offline.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showSaveUnavailable() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Outfit saving is unavailable until outfit storage is implemented.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final avatarLabel = _avatar == 'AURA' ? 'FEM [AURA]' : 'MASC [KAI]';

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 11,
                  child: _ChoiceSegment(
                    choices: const ['FEM [AURA]', 'MASC [KAI]'],
                    selected: avatarLabel,
                    onSelected: (value) => setState(
                      () => _avatar = value == 'FEM [AURA]' ? 'AURA' : 'KAI',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 10,
                  child: _ChoiceSegment(
                    choices: const ['FRONT', 'SIDE', 'BACK'],
                    selected: _view,
                    onSelected: (value) => setState(() => _view = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const _InfoPill(
                  icon: Icons.tune_rounded,
                  label: 'PROP: S-02 STD',
                ),
                const Spacer(),
                const _InfoPill(
                  icon: Icons.rotate_right_rounded,
                  label: 'FREE ORBIT',
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 292,
              child: StudioViewport(
                avatarName: avatarLabel,
                viewName: _view,
                zoomPercent: _zoomPercent,
                mountedGarments: _mountedGarments,
                onZoomIn: () => setState(
                  () => _zoomPercent = (_zoomPercent + 10).clamp(70, 130),
                ),
                onZoomOut: () => setState(
                  () => _zoomPercent = (_zoomPercent - 10).clamp(70, 130),
                ),
                onRemoveGarment: _removeGarment,
                onDropGarment: _fitGarment,
                onFeatureTap: _showUnavailable,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 13),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'LOCAL PREVIEW · SELECTIONS ARE NOT SAVED OR RENDERED IN 3D',
                    style: AppTextStyles.eyebrow.copyWith(fontSize: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StudioGarmentPicker(
              category: _category,
              mountedGarments: _mountedGarments,
              onCategoryChanged: (value) => setState(() => _category = value),
              onGarmentSelected: _fitGarment,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _mountedGarments = {..._initialGarments}),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('RESET LOOK'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.grey,
                    textStyle: AppTextStyles.button,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    minimumSize: const Size(0, 40),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Capture preview',
                  onPressed: () => _showUnavailable('Preview capture'),
                  icon: const Icon(Icons.camera_alt_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: PillButton(
                    label: 'Save outfit',
                    icon: Icons.bookmark_border_rounded,
                    expand: true,
                    onPressed: _showSaveUnavailable,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceSegment extends StatelessWidget {
  const _ChoiceSegment({
    required this.choices,
    required this.selected,
    required this.onSelected,
  });

  final List<String> choices;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          for (final choice in choices)
            Expanded(
              child: Semantics(
                button: true,
                selected: selected == choice,
                child: Material(
                  color: selected == choice
                      ? AppColors.black
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => onSelected(choice),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 8,
                      ),
                      child: Text(
                        choice,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          color: selected == choice
                              ? AppColors.white
                              : AppColors.grey,
                          fontSize: 8,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 8)),
        ],
      ),
    );
  }
}
