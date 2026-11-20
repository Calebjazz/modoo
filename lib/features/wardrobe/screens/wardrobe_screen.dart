import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/media_placeholder.dart';
import '../../../shared/widgets/pill_button.dart';
import '../models/wardrobe_garment.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  WardrobeCategory? _category;
  final Set<String> _selectedGarments = {};
  Set<String> _selectedMaterials = {};
  String _query = '';

  List<WardrobeGarment> get _visibleGarments {
    final normalizedQuery = _query.trim().toLowerCase();
    return WardrobeCatalog.items
        .where((garment) {
          final matchesCategory =
              _category == null || garment.category == _category;
          final matchesMaterial =
              _selectedMaterials.isEmpty ||
              _selectedMaterials.contains(garment.material);
          final matchesQuery =
              normalizedQuery.isEmpty ||
              '${garment.name} ${garment.category.label} ${garment.material} '
                      '${garment.finish}'
                  .toLowerCase()
                  .contains(normalizedQuery);

          return matchesCategory && matchesMaterial && matchesQuery;
        })
        .toList(growable: false);
  }

  int _countFor(WardrobeCategory? category) {
    if (category == null) return WardrobeCatalog.items.length;
    return WardrobeCatalog.items
        .where((garment) => garment.category == category)
        .length;
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _showFilters() async {
    final availableMaterials =
        WardrobeCatalog.items
            .map((garment) => garment.material)
            .toSet()
            .toList()
          ..sort();
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) {
        final draft = Set<String>.of(_selectedMaterials);
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('FILTER ARCHIVE', style: AppTextStyles.label),
                  const SizedBox(height: 18),
                  Text(
                    'MATERIAL',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final material in availableMaterials)
                        FilterChip(
                          label: Text(material.toUpperCase()),
                          selected: draft.contains(material),
                          onSelected: (selected) => setSheetState(() {
                            if (selected) {
                              draft.add(material);
                            } else {
                              draft.remove(material);
                            }
                          }),
                          selectedColor: AppColors.black,
                          checkmarkColor: AppColors.white,
                          labelStyle: AppTextStyles.label.copyWith(
                            color: draft.contains(material)
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 8,
                          ),
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, <String>{}),
                        child: const Text('CLEAR'),
                      ),
                      const Spacer(),
                      PillButton(
                        label: 'Apply filters',
                        onPressed: () => Navigator.pop(context, draft),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _selectedMaterials = result);
    }
  }

  void _toggleSelection(WardrobeGarment garment) {
    setState(() {
      if (!_selectedGarments.add(garment.id)) {
        _selectedGarments.remove(garment.id);
      }
    });
  }

  void _createLook() {
    if (_selectedGarments.isEmpty) {
      _showNotice('Select one or more pieces to start a look.');
      return;
    }
    _showNotice(
      '3D look assembly requires Unity and garment assets, which are not connected.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final garments = _visibleGarments;
    final activeCategoryCount = WardrobeCatalog.items
        .map((garment) => garment.category)
        .toSet()
        .length;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 62, 16, 18),
                sliver: SliverList.list(
                  children: [
                    _ArchiveHeader(
                      onAdd: () => _showNotice(
                        'Add a piece after its licensed 3D garment asset is available.',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ArchiveStat(
                            label: 'Total pieces',
                            value: WardrobeCatalog.items.length
                                .toString()
                                .padLeft(2, '0'),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _ArchiveStat(
                            label: 'Categories',
                            value: activeCategoryCount.toString().padLeft(
                              2,
                              '0',
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: _ArchiveStat(
                            label: 'Custom looks',
                            value: '00',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _SearchField(
                            onChanged: (value) =>
                                setState(() => _query = value),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _FilterButton(
                          count: _selectedMaterials.length,
                          onTap: _showFilters,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 31,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _CategoryChip(
                            label: 'All',
                            count: _countFor(null),
                            selected: _category == null,
                            onTap: () => setState(() => _category = null),
                          ),
                          for (final category in WardrobeCategory.values) ...[
                            const SizedBox(width: 6),
                            _CategoryChip(
                              label: category.label,
                              count: _countFor(category),
                              selected: _category == category,
                              onTap: () => setState(() => _category = category),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (garments.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'NO PIECES MATCH YOUR SEARCH',
                        style: AppTextStyles.eyebrow,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final garment = garments[index];
                      return WardrobeGarmentCard(
                        garment: garment,
                        selected: _selectedGarments.contains(garment.id),
                        onSelect: () => _toggleSelection(garment),
                        onWear: () => _showNotice(
                          '3D fitting is unavailable until Unity garment assets are connected.',
                        ),
                        onDetails: () => _showGarmentDetails(garment),
                      );
                    }, childCount: garments.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          mainAxisExtent: 354,
                        ),
                  ),
                ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: _CreateLookBar(
              selectedCount: _selectedGarments.length,
              onTap: _createLook,
            ),
          ),
        ],
      ),
    );
  }

  void _showGarmentDetails(WardrobeGarment garment) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                garment.category.label.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 6),
              Text(garment.name, style: AppTextStyles.title),
              const SizedBox(height: 12),
              Text(
                '${garment.material} · ${garment.finish}\n'
                '${garment.description}\n'
                '3D garment asset not installed',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 18),
              PillButton(
                label: 'Close',
                variant: PillButtonVariant.tonal,
                expand: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveHeader extends StatelessWidget {
  const _ArchiveHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ARCHIVE SYSTEM // SAMPLE CATALOG',
                style: AppTextStyles.eyebrow.copyWith(letterSpacing: 1.4),
              ),
              const SizedBox(height: 4),
              Text(
                'DIGITAL\nWARDROBE',
                style: AppTextStyles.display.copyWith(
                  fontSize: 30,
                  height: 1,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: AppColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onAdd,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(Icons.add_rounded, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArchiveStat extends StatelessWidget {
  const _ArchiveStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.eyebrow.copyWith(
              fontSize: 7,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.title.copyWith(fontSize: 19)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: 'Search garments by cut, material',
          hintStyle: AppTextStyles.body.copyWith(fontSize: 11),
          prefixIcon: const Icon(Icons.search_rounded, size: 17),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 40,
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: AppColors.black),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, size: 15),
                const SizedBox(width: 6),
                Text(
                  'FILTERS${count == 0 ? '' : ' ($count)'}',
                  style: AppTextStyles.label.copyWith(
                    letterSpacing: 0.7,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            '${label.toUpperCase()} (${count.toString().padLeft(2, '0')})',
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.white : AppColors.grey,
              letterSpacing: 0.7,
              fontSize: 8,
            ),
          ),
        ),
      ),
    );
  }
}

class WardrobeGarmentCard extends StatelessWidget {
  const WardrobeGarmentCard({
    super.key,
    required this.garment,
    required this.selected,
    required this.onSelect,
    required this.onWear,
    required this.onDetails,
  });

  final WardrobeGarment garment;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onWear;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 0.76,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MediaPlaceholder(
                  icon: garment.icon,
                  caption: '3D preview pending',
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: selected
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'IN LOOK',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.white,
                              fontSize: 7,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Positioned(
                  right: 7,
                  top: 7,
                  child: Semantics(
                    button: true,
                    selected: selected,
                    label: selected
                        ? 'Remove ${garment.name} from look'
                        : 'Add ${garment.name} to look',
                    child: Material(
                      color: AppColors.white.withValues(alpha: 0.94),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onSelect,
                        child: SizedBox(
                          width: 29,
                          height: 29,
                          child: Icon(
                            selected
                                ? Icons.check_circle_outline_rounded
                                : Icons.circle_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 7,
                  right: 7,
                  bottom: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.93),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'MATERIAL: ${garment.material}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.label.copyWith(fontSize: 6),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.tune_rounded,
                          size: 11,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9, 8, 8, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          garment.category.label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.black,
                            fontSize: 8,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          garment.finish.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.eyebrow.copyWith(fontSize: 7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    garment.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(
                      fontSize: 11,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    garment.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.eyebrow.copyWith(
                      fontSize: 8,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: PillButton(
                          label: 'Wear',
                          icon: Icons.accessibility_new_rounded,
                          expand: true,
                          onPressed: onWear,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Material(
                        color: AppColors.surface,
                        shape: const CircleBorder(),
                        child: PopupMenuButton<String>(
                          tooltip: 'More options for ${garment.name}',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 34,
                            height: 34,
                          ),
                          iconSize: 16,
                          icon: const Icon(Icons.more_vert_rounded),
                          onSelected: (value) {
                            if (value == 'details') onDetails();
                            if (value == 'select') onSelect();
                            if (value == 'wear') onWear();
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'details',
                              child: Text('Details'),
                            ),
                            PopupMenuItem(
                              value: 'select',
                              child: Text('Select for look'),
                            ),
                            PopupMenuItem(value: 'wear', child: Text('Wear')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateLookBar extends StatelessWidget {
  const _CreateLookBar({required this.selectedCount, required this.onTap});

  final int selectedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = selectedCount == 0
        ? 'SELECT PIECES TO BEGIN'
        : '$selectedCount PIECE${selectedCount == 1 ? '' : 'S'} SELECTED';

    return Material(
      color: const Color(0xFF2C2C2C),
      borderRadius: BorderRadius.circular(32),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.border,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$selectedCount',
                style: AppTextStyles.label.copyWith(fontSize: 9),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                '$status\nCREATE 3D LOOK',
                maxLines: 2,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.white,
                  fontSize: 8,
                  letterSpacing: 0.3,
                  height: 1.4,
                ),
              ),
            ),
            Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('CREATOR', style: AppTextStyles.button),
                      const SizedBox(width: 7),
                      const Icon(Icons.arrow_forward_rounded, size: 15),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
