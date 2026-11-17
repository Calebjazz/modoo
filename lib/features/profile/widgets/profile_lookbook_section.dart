import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/models/home_models.dart';
import 'profile_section_header.dart';
import 'profile_simulation_card.dart';

class ProfileLookbookSection extends StatelessWidget {
  const ProfileLookbookSection({
    super.key,
    required this.looks,
    required this.totalCount,
    required this.onViewAll,
    required this.onTestFit,
  });

  final List<LookPreview> looks;
  final int totalCount;
  final VoidCallback onViewAll;
  final VoidCallback onTestFit;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ProfileSectionHeader(
        icon: Icons.layers_outlined,
        title: 'RECENT 3D SIMULATIONS',
        trailing: TextButton(
          onPressed: onViewAll,
          child: Text(
            'VIEW ALL ($totalCount)',
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.grey),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 240,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: looks.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, index) =>
              ProfileSimulationCard(look: looks[index], onTestFit: onTestFit),
        ),
      ),
    ],
  );
}
