import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/models/home_models.dart';

class ProfileSimulationCard extends StatelessWidget {
  const ProfileSimulationCard({
    super.key,
    required this.look,
    required this.onTestFit,
  });

  final LookPreview look;
  final VoidCallback onTestFit;

  @override
  Widget build(BuildContext context) => Container(
    width: 174,
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(
            height: 126,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(
                  color: Color(0xFFF1F1F1),
                  child: Center(
                    child: Icon(
                      Icons.checkroom_rounded,
                      size: 48,
                      color: Color(0xFFB4B4B4),
                    ),
                  ),
                ),
                Positioned(
                  left: 7,
                  top: 7,
                  child: Chip(
                    label: Text(look.line.toUpperCase()),
                    visualDensity: VisualDensity.compact,
                    labelStyle: AppTextStyles.eyebrow.copyWith(fontSize: 8),
                    backgroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          look.title.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(
          'PREVIEW  //  ${look.number.toString().padLeft(2, '0')}',
          style: AppTextStyles.eyebrow.copyWith(fontSize: 9),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 30,
          child: FilledButton.icon(
            onPressed: onTestFit,
            icon: const Icon(Icons.view_in_ar_rounded, size: 13),
            label: Text(
              'TEST FIT',
              style: AppTextStyles.button.copyWith(
                color: AppColors.white,
                fontSize: 9,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    ),
  );
}
