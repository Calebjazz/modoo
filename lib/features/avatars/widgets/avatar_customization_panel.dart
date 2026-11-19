import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/avatar_customization.dart';

class AvatarCustomizationPanel extends StatelessWidget {
  const AvatarCustomizationPanel({
    super.key,
    required this.section,
    required this.profileId,
    required this.toneIndex,
    required this.bodyShape,
    required this.heightCm,
    required this.chestCm,
    required this.waistCm,
    required this.onSectionChanged,
    required this.onProfileChanged,
    required this.onToneChanged,
    required this.onBodyShapeChanged,
    required this.onHeightChanged,
    required this.onChestChanged,
    required this.onWaistChanged,
    required this.onMeshInfo,
  });

  final AvatarCustomizationSection section;
  final String profileId;
  final int toneIndex;
  final String bodyShape;
  final double heightCm;
  final double chestCm;
  final double waistCm;
  final ValueChanged<AvatarCustomizationSection> onSectionChanged;
  final ValueChanged<String> onProfileChanged;
  final ValueChanged<int> onToneChanged;
  final ValueChanged<String> onBodyShapeChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onChestChanged;
  final ValueChanged<double> onWaistChanged;
  final VoidCallback onMeshInfo;

  @override
  Widget build(BuildContext context) {
    final profile = AvatarCustomizationOptions.profiles.firstWhere(
      (option) => option.id == profileId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final option in AvatarCustomizationSection.values) ...[
                if (option != AvatarCustomizationSection.values.first)
                  const SizedBox(width: 8),
                _SectionButton(
                  section: option,
                  selected: section == option,
                  onTap: () => onSectionChanged(option),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 17),
        switch (section) {
          AvatarCustomizationSection.model => _ModelOptions(
            profile: profile,
            toneIndex: toneIndex,
            onProfileChanged: onProfileChanged,
            onToneChanged: onToneChanged,
            onMeshInfo: onMeshInfo,
          ),
          AvatarCustomizationSection.bodyShape => _BodyShapeOptions(
            selectedShape: bodyShape,
            onShapeChanged: onBodyShapeChanged,
          ),
          AvatarCustomizationSection.proportions => _ProportionOptions(
            heightCm: heightCm,
            chestCm: chestCm,
            waistCm: waistCm,
            onHeightChanged: onHeightChanged,
            onChestChanged: onChestChanged,
            onWaistChanged: onWaistChanged,
          ),
        },
      ],
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final AvatarCustomizationSection section;
  final bool selected;
  final VoidCallback onTap;

  String get label => switch (section) {
    AvatarCustomizationSection.model => 'Model & Gender',
    AvatarCustomizationSection.bodyShape => 'Body Shape',
    AvatarCustomizationSection.proportions => 'Proportion',
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.black : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.white : AppColors.black,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModelOptions extends StatelessWidget {
  const _ModelOptions({
    required this.profile,
    required this.toneIndex,
    required this.onProfileChanged,
    required this.onToneChanged,
    required this.onMeshInfo,
  });

  final AvatarProfile profile;
  final int toneIndex;
  final ValueChanged<String> onProfileChanged;
  final ValueChanged<int> onToneChanged;
  final VoidCallback onMeshInfo;

  @override
  Widget build(BuildContext context) {
    final tone = AvatarCustomizationOptions.tones[toneIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabelRow(
          title: 'Base anatomical rig',
          detail: 'Active: ${profile.label}',
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              for (final option in AvatarCustomizationOptions.profiles)
                Expanded(
                  child: _ProfileOption(
                    profile: option,
                    selected: option.id == profile.id,
                    onTap: () => onProfileChanged(option.id),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _LabelRow(
          title: 'Greyscale tone palette',
          detail:
              'Tone #${(toneIndex + 1).toString().padLeft(2, '0')} (${tone.name})',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 0; i < AvatarCustomizationOptions.tones.length; i++)
              Expanded(
                child: Center(
                  child: _ToneSwatch(
                    tone: AvatarCustomizationOptions.tones[i],
                    selected: i == toneIndex,
                    onTap: () => onToneChanged(i),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onMeshInfo,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 12, 11),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUBDIVISION GEOMETRY',
                          style: AppTextStyles.label,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'LOD DETAILS PENDING UNITY INTEGRATION',
                          style: AppTextStyles.eyebrow,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.polyline_rounded, size: 17),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.profile,
    required this.selected,
    required this.onTap,
  });

  final AvatarProfile profile;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
            child: Text(
              profile.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                color: selected ? AppColors.white : AppColors.grey,
                fontSize: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToneSwatch extends StatelessWidget {
  const _ToneSwatch({
    required this.tone,
    required this.selected,
    required this.onTap,
  });

  final AvatarTone tone;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: tone.name,
      child: Tooltip(
        message: tone.name,
        child: Material(
          color: tone.color,
          shape: CircleBorder(
            side: BorderSide(
              color: selected ? AppColors.black : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 43,
              height: 43,
              child: selected
                  ? Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: tone.color.computeLuminance() > 0.5
                            ? AppColors.black
                            : AppColors.white,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyShapeOptions extends StatelessWidget {
  const _BodyShapeOptions({
    required this.selectedShape,
    required this.onShapeChanged,
  });

  final String selectedShape;
  final ValueChanged<String> onShapeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _LabelRow(title: 'Body configuration', detail: 'Local selection'),
        const SizedBox(height: 10),
        for (final shape in AvatarCustomizationOptions.bodyShapes) ...[
          _SelectableRow(
            label: shape.toUpperCase(),
            selected: shape == selectedShape,
            onTap: () => onShapeChanged(shape),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 5),
        Text(
          'Body shape changes will apply after the avatar system is connected.',
          style: AppTextStyles.eyebrow.copyWith(letterSpacing: 0.6),
        ),
      ],
    );
  }
}

class _ProportionOptions extends StatelessWidget {
  const _ProportionOptions({
    required this.heightCm,
    required this.chestCm,
    required this.waistCm,
    required this.onHeightChanged,
    required this.onChestChanged,
    required this.onWaistChanged,
  });

  final double heightCm;
  final double chestCm;
  final double waistCm;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onChestChanged;
  final ValueChanged<double> onWaistChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DimensionSlider(
          label: 'Height',
          value: heightCm,
          min: 150,
          max: 200,
          onChanged: onHeightChanged,
        ),
        _DimensionSlider(
          label: 'Chest',
          value: chestCm,
          min: 70,
          max: 120,
          onChanged: onChestChanged,
        ),
        _DimensionSlider(
          label: 'Waist',
          value: waistCm,
          min: 50,
          max: 100,
          onChanged: onWaistChanged,
        ),
        Text(
          'Proportions are preview controls only; Unity is not connected.',
          style: AppTextStyles.eyebrow.copyWith(letterSpacing: 0.6),
        ),
      ],
    );
  }
}

class _DimensionSlider extends StatelessWidget {
  const _DimensionSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(fontSize: 9),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(
            '${value.round()} CM',
            textAlign: TextAlign.right,
            style: AppTextStyles.label.copyWith(fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _SelectableRow extends StatelessWidget {
  const _SelectableRow({
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
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: selected ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.label.copyWith(letterSpacing: 0.9),
          ),
        ),
        Flexible(
          child: Text(
            detail.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.eyebrow.copyWith(letterSpacing: 0.7),
          ),
        ),
      ],
    );
  }
}
