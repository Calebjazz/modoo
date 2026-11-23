import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../models/home_models.dart';
import 'capsule_card.dart';

class CapsulesSection extends StatelessWidget {
  const CapsulesSection({
    super.key,
    required this.capsules,
    required this.onOpen,
  });

  final List<CapsulePreview> capsules;
  final ValueChanged<CapsulePreview> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          eyebrow: 'Digital runway',
          title: 'Curated\ncapsules',
          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'VIRTUAL\nSS${(DateTime.now().year + 1) % 100}',
              textAlign: TextAlign.right,
              style: AppTextStyles.eyebrow,
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < capsules.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          CapsuleCard(capsule: capsules[i], onOpen: () => onOpen(capsules[i])),
        ],
      ],
    );
  }
}
