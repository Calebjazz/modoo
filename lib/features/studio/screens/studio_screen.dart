import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../outfits/controllers/outfits_controller.dart';
import '../../outfits/widgets/outfit_dialogs.dart';
import '../controllers/studio_controller.dart';
import '../widgets/studio_garment_picker.dart';
import '../widgets/studio_viewport.dart';

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  static void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }

  static void _showUnavailable(BuildContext context, String feature) =>
      _message(
        context,
        '$feature requires the Unity preview, which is offline.',
      );

  static Future<void> _save(BuildContext context) async {
    final studio = context.read<StudioController>();
    final outfits = context.read<OutfitsController>();
    if (studio.mountedGarments.isEmpty) {
      _message(context, 'Mount at least one garment before saving.');
      return;
    }
    final editing = studio.editing;
    final request = await OutfitDialogs.save(
      context,
      initialName: editing?.name ?? '',
      canUpdate: editing != null,
    );
    if (request == null || !context.mounted) return;
    try {
      final saved = editing != null && !request.asNew
          ? await outfits.update(
              editing.copyWith(
                name: request.name,
                avatarId: studio.avatarId,
                garmentIds: studio.mountedGarmentIds,
              ),
            )
          : await outfits.create(
              name: request.name,
              avatarId: studio.avatarId,
              garmentIds: studio.mountedGarmentIds,
            );
      studio.markSaved(saved);
      if (context.mounted) _message(context, 'Saved "${saved.name}" to Looks.');
    } catch (error) {
      if (context.mounted) _message(context, 'Could not save outfit: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final studio = context.watch<StudioController>();
    final avatarLabel = studio.avatarId == 'AURA' ? 'FEM [AURA]' : 'MASC [KAI]';
    final editing = studio.editing;

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
                    onSelected: (value) => studio.setAvatar(
                      value == 'FEM [AURA]' ? 'AURA' : 'KAI',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 10,
                  child: _ChoiceSegment(
                    choices: const ['FRONT', 'SIDE', 'BACK'],
                    selected: studio.view,
                    onSelected: studio.setView,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoPill(
                  icon: editing == null
                      ? Icons.tune_rounded
                      : Icons.edit_outlined,
                  label: editing == null
                      ? 'PROP: S-02 STD'
                      : 'EDITING: ${editing.name.toUpperCase()}',
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
                viewName: studio.view,
                zoomPercent: studio.zoomPercent,
                mountedGarments: studio.mountedGarments,
                onZoomIn: studio.zoomIn,
                onZoomOut: studio.zoomOut,
                onRemoveGarment: studio.remove,
                onDropGarment: studio.fit,
                onFeatureTap: (feature) => _showUnavailable(context, feature),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 13),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'LOCAL PREVIEW · GARMENTS ARE NOT RENDERED IN 3D YET',
                    style: AppTextStyles.eyebrow.copyWith(fontSize: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StudioGarmentPicker(
              category: studio.category,
              mountedGarments: studio.mountedGarments,
              onCategoryChanged: studio.setCategory,
              onGarmentSelected: studio.fit,
              onGarmentRemoved: studio.remove,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                TextButton.icon(
                  onPressed: studio.resetLook,
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
                  onPressed: () => _showUnavailable(context, 'Preview capture'),
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
                    onPressed: () => _save(context),
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
