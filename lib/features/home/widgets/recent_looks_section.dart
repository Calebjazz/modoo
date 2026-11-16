import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../models/home_models.dart';
import 'look_card.dart';

/// "Recent Looks" header followed by a horizontally scrolling card row.
class RecentLooksSection extends StatelessWidget {
  const RecentLooksSection({
    super.key,
    required this.looks,
    required this.totalCount,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onReapply,
    required this.onViewAll,
    this.horizontalPadding = 20,
  });

  final List<LookPreview> looks;
  final int totalCount;
  final bool Function(String lookId) isFavorite;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<LookPreview> onReapply;
  final VoidCallback onViewAll;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SectionHeader(
            eyebrow: 'Atelier archives',
            title: 'Recent looks',
            trailing: TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                'VIEW ALL ($totalCount)',
                style: AppTextStyles.label.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < looks.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  LookCard(
                    look: looks[i],
                    isFavorite: isFavorite(looks[i].id),
                    onFavoriteToggle: () => onFavoriteToggle(looks[i].id),
                    onReapply: () => onReapply(looks[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
