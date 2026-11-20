import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pill_button.dart';
import '../models/avatar_customization.dart';
import '../widgets/avatar_customization_panel.dart';
import '../widgets/avatar_viewport.dart';

class AvatarCustomizationScreen extends StatefulWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  State<AvatarCustomizationScreen> createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState extends State<AvatarCustomizationScreen> {
  static const _defaultProfileId = 'aura';
  static const _defaultToneIndex = 2;
  static const _defaultHeightCm = 178.0;
  static const _defaultChestCm = 88.0;
  static const _defaultWaistCm = 64.0;

  AvatarCustomizationSection _section = AvatarCustomizationSection.model;
  AvatarFrame _frame = AvatarFrame.full;
  String _profileId = _defaultProfileId;
  String _bodyShape = 'Athletic';
  int _toneIndex = _defaultToneIndex;
  int _yawDegrees = 0;
  double _heightCm = _defaultHeightCm;
  double _chestCm = _defaultChestCm;
  double _waistCm = _defaultWaistCm;

  AvatarProfile get _profile => AvatarCustomizationOptions.profiles.firstWhere(
    (option) => option.id == _profileId,
  );

  void _showIntegrationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _resetToDefaults() {
    setState(() {
      _section = AvatarCustomizationSection.model;
      _frame = AvatarFrame.full;
      _profileId = _defaultProfileId;
      _bodyShape = 'Athletic';
      _toneIndex = _defaultToneIndex;
      _yawDegrees = 0;
      _heightCm = _defaultHeightCm;
      _chestCm = _defaultChestCm;
      _waistCm = _defaultWaistCm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text('CUSTOMIZE'),
        centerTitle: true,
        titleTextStyle: AppTextStyles.label.copyWith(
          letterSpacing: 1.4,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 375,
                child: AvatarViewport(
                  avatarCode: _profile.name,
                  heightCm: _heightCm.round(),
                  chestCm: _chestCm.round(),
                  waistCm: _waistCm.round(),
                  frame: _frame,
                  yawDegrees: _yawDegrees,
                  onFrameChanged: (value) => setState(() => _frame = value),
                  onYawChanged: (value) =>
                      setState(() => _yawDegrees = value % 360),
                  onRecenter: () => setState(() => _yawDegrees = 0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
                child: AvatarCustomizationPanel(
                  section: _section,
                  profileId: _profileId,
                  toneIndex: _toneIndex,
                  bodyShape: _bodyShape,
                  heightCm: _heightCm,
                  chestCm: _chestCm,
                  waistCm: _waistCm,
                  onSectionChanged: (value) => setState(() => _section = value),
                  onProfileChanged: (value) =>
                      setState(() => _profileId = value),
                  onToneChanged: (value) => setState(() => _toneIndex = value),
                  onBodyShapeChanged: (value) =>
                      setState(() => _bodyShape = value),
                  onHeightChanged: (value) => setState(() => _heightCm = value),
                  onChestChanged: (value) => setState(() => _chestCm = value),
                  onWaistChanged: (value) => setState(() => _waistCm = value),
                  onMeshInfo: () => _showIntegrationMessage(
                    'Subdivision geometry requires the Unity avatar integration.',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: PillButton(
                  label: 'Apply to studio viewport',
                  icon: Icons.check_circle_outline_rounded,
                  expand: true,
                  onPressed: () => _showIntegrationMessage(
                    'Avatar changes cannot be applied until Unity is connected.',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: PillButton(
                  label: 'Reset to atelier default',
                  variant: PillButtonVariant.tonal,
                  expand: true,
                  onPressed: _resetToDefaults,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
