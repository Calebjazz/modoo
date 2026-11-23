import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/navigation_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../studio/controllers/studio_controller.dart';
import '../controllers/outfits_controller.dart';
import '../data/curated_looks.dart';
import '../models/outfit.dart';
import '../widgets/outfit_dialogs.dart';
import '../widgets/saved_look_card.dart';

class LooksScreen extends StatefulWidget {
  const LooksScreen({super.key});

  @override
  State<LooksScreen> createState() => _LooksScreenState();
}

class _LooksScreenState extends State<LooksScreen> {
  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  /// `null` shows every avatar.
  String? _avatarFilter;

  bool _matches(Outfit outfit) =>
      _avatarFilter == null || outfit.avatarId == _avatarFilter;

  void _message(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          action: action,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openStudio() =>
      context.read<NavigationController>().goTo(AppTab.studio);

  void _dress(Outfit outfit) {
    final studio = context.read<StudioController>();
    studio.applyOutfit(outfit, useOutfitAvatar: false);
    _message(
      '${outfit.name} mounted on ${studio.avatarId}.',
      action: SnackBarAction(label: 'VIEW', onPressed: _openStudio),
    );
  }

  void _viewInStudio(Outfit outfit) {
    context.read<StudioController>().applyOutfit(outfit);
    _openStudio();
  }

  void _edit(Outfit outfit) {
    context.read<StudioController>().applyOutfit(outfit, edit: true);
    _openStudio();
    if (outfit.isCurated) {
      _message('Curated looks are read-only. Save Outfit creates your copy.');
    }
  }

  void _createEnsemble() {
    context.read<StudioController>().startNewEnsemble();
    _openStudio();
  }

  Future<void> _more(Outfit outfit) async {
    final outfits = context.read<OutfitsController>();
    final studio = context.read<StudioController>();
    final action = await OutfitDialogs.options(context, outfit);
    if (action == null || !mounted) return;
    try {
      switch (action) {
        case OutfitAction.rename:
          final request = await OutfitDialogs.save(
            context,
            initialName: outfit.name,
            title: 'Rename outfit',
            confirmLabel: 'RENAME',
          );
          if (request == null) return;
          await outfits.rename(outfit, request.name);
          _message('Renamed to ${request.name}.');
        case OutfitAction.duplicate:
          final copy = await outfits.create(
            name: outfit.isCurated ? outfit.name : '${outfit.name} Copy',
            avatarId: outfit.avatarId,
            garmentIds: outfit.garmentIds,
          );
          _message('${copy.name} added to your looks.');
        case OutfitAction.delete:
          if (!await OutfitDialogs.confirmDelete(context, outfit)) return;
          await outfits.delete(outfit);
          studio.forgetOutfit(outfit.id!);
          _message('${outfit.name} deleted.');
      }
    } catch (error) {
      if (mounted) _message('Could not update outfit: $error');
    }
  }

  String _dateBadge(Outfit outfit) {
    final date = outfit.updatedAt;
    if (date == null) return 'CURATED';
    return '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final outfitsController = context.watch<OutfitsController>();
    final saved = outfitsController.outfits.where(_matches).toList();
    final curated = CuratedLooks.looks.where(_matches).toList();

    Widget card(Outfit outfit, int index) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SavedLookCard(
        look: outfit,
        number: index + 1,
        badge: _dateBadge(outfit),
        onEdit: () => _edit(outfit),
        onMore: () => _more(outfit),
        onStudio: () => _viewInStudio(outfit),
        onDress: () => _dress(outfit),
      ),
    );

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 32),
        children: [
          _ModeSwitch(
            savedCount: outfitsController.savedCount,
            onCreatorSuite: _openStudio,
          ),
          const SizedBox(height: 16),
          _SectionTitle(
            title: 'MY LOOKS',
            caption: _avatarFilter ?? 'ALL AVATARS',
            trailing: _FilterButton(
              value: _avatarFilter,
              onChanged: (value) => setState(() => _avatarFilter = value),
            ),
          ),
          const SizedBox(height: 10),
          if (outfitsController.isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 1.6)),
            )
          else if (outfitsController.error != null)
            const _EmptyNote(text: 'Saved looks could not be loaded.')
          else if (saved.isEmpty)
            _EmptyNote(
              text: outfitsController.savedCount == 0
                  ? 'No saved looks yet. Dress your avatar in Studio and '
                        'tap Save Outfit.'
                  : 'No saved looks for $_avatarFilter.',
            )
          else
            for (var i = 0; i < saved.length; i++) card(saved[i], i),
          const SizedBox(height: 14),
          const _SectionTitle(title: 'CURATED LOOKS', caption: 'ARCHIVE 2025'),
          const SizedBox(height: 10),
          if (curated.isEmpty)
            _EmptyNote(text: 'No curated looks for $_avatarFilter.')
          else
            for (var i = 0; i < curated.length; i++) card(curated[i], i),
          const SizedBox(height: 6),
          Center(
            child: PillButton(
              label: 'Create new ensemble',
              icon: Icons.add,
              variant: PillButtonVariant.tonal,
              onPressed: _createEnsemble,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.savedCount, required this.onCreatorSuite});

  final int savedCount;
  final VoidCallback onCreatorSuite;

  @override
  Widget build(BuildContext context) => Container(
    height: 52,
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.all(Radius.circular(21)),
            ),
            alignment: Alignment.center,
            child: Text(
              'SAVED LOOKS ($savedCount)',
              style: AppTextStyles.label.copyWith(color: AppColors.white),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onCreatorSuite,
            borderRadius: BorderRadius.circular(21),
            child: Center(
              child: Text(
                'OUTFIT CREATOR\nSUITE',
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.grey,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.caption,
    this.trailing,
  });

  final String title;
  final String caption;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(title, style: AppTextStyles.title.copyWith(fontSize: 17)),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.eyebrow.copyWith(
            fontSize: 9,
            letterSpacing: 0.8,
          ),
        ),
      ),
      ?trailing,
    ],
  );
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _all = 'ALL';

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: 'Filter looks by avatar',
    initialValue: value ?? _all,
    onSelected: (selected) => onChanged(selected == _all ? null : selected),
    itemBuilder: (_) => const [
      PopupMenuItem(value: _all, child: Text('All avatars')),
      PopupMenuItem(value: 'AURA', child: Text('Aura (female)')),
      PopupMenuItem(value: 'KAI', child: Text('Kai (male)')),
    ],
    child: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: value == null ? AppColors.surface : AppColors.black,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.tune_rounded,
        size: 18,
        color: value == null ? AppColors.black : AppColors.white,
      ),
    ),
  );
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(color: AppColors.grey),
    ),
  );
}
