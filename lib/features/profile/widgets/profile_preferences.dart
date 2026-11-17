import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_fidelity_picker.dart';
import 'profile_preference_row.dart';
import 'profile_section_header.dart';

class ProfilePreferences extends StatefulWidget {
  const ProfilePreferences({super.key});

  @override
  State<ProfilePreferences> createState() => _ProfilePreferencesState();
}

class _ProfilePreferencesState extends State<ProfilePreferences> {
  bool _clothSimulation = true;
  bool _turntableOrbit = false;
  String _fidelity = 'ULTRA';
  String _lighting = 'MONO-CONTRAST';
  static const _environments = ['MONO-CONTRAST', 'SOFT STUDIO', 'HIGH KEY'];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ProfileSectionHeader(
        icon: Icons.settings_suggest_outlined,
        title: '3D ENGINE PREFERENCES',
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            ProfilePreferenceRow(
              title: 'Cloth Simulation',
              subtitle: 'Real-time Raytraced Physics',
              child: Switch(
                value: _clothSimulation,
                onChanged: (value) => setState(() => _clothSimulation = value),
                activeTrackColor: AppColors.black,
              ),
            ),
            ProfilePreferenceRow(
              title: 'Turntable Orbit',
              subtitle: 'Auto-spin in Studio View',
              child: Switch(
                value: _turntableOrbit,
                onChanged: (value) => setState(() => _turntableOrbit = value),
                activeTrackColor: AppColors.black,
              ),
            ),
            ProfilePreferenceRow(
              title: 'Viewport Fidelity',
              subtitle: 'Dynamic Resolution Cap',
              child: ProfileFidelityPicker(
                value: _fidelity,
                onChanged: (value) => setState(() => _fidelity = value),
              ),
            ),
            ProfilePreferenceRow(
              title: 'Lighting Environment',
              subtitle: 'Virtual HDR Key & Rim',
              showDivider: false,
              child: PopupMenuButton<String>(
                onSelected: (value) => setState(() => _lighting = value),
                itemBuilder: (_) => _environments
                    .map(
                      (value) =>
                          PopupMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                child: _LightingChip(label: _lighting),
              ),
            ),
            Text(
              'Flutter preview controls only · saved in this session.',
              style: AppTextStyles.eyebrow.copyWith(fontSize: 9),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ],
  );
}

class _LightingChip extends StatelessWidget {
  const _LightingChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: const BoxDecoration(
      color: Color(0xFFF0F0F0),
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    child: Text(label, style: AppTextStyles.label.copyWith(fontSize: 9)),
  );
}
