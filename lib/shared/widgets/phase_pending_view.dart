import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Honest placeholder for screens that belong to a later development phase.
class PhasePendingView extends StatelessWidget {
  const PhasePendingView({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.message,
    this.icon = Icons.hourglass_empty_rounded,
  });

  final String eyebrow;
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eyebrow.toUpperCase(), style: AppTextStyles.eyebrow),
            const SizedBox(height: 10),
            Text(title.toUpperCase(), style: AppTextStyles.display),
            const SizedBox(height: 12),
            Text(message, style: AppTextStyles.lead),
            const Spacer(),
            Center(
              child: Icon(
                icon,
                size: 64,
                color: AppColors.placeholderLightIcon,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
