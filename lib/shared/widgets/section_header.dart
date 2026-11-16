import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Overline + large uppercase title, with an optional trailing widget.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow.toUpperCase(), style: AppTextStyles.eyebrow),
              const SizedBox(height: 6),
              Text(title.toUpperCase(), style: AppTextStyles.sectionTitle),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
