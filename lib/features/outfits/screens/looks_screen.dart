import 'package:flutter/material.dart';

import '../../../core/navigation/navigation_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/looks_sample_data.dart';
import '../widgets/saved_look_card.dart';

import 'package:provider/provider.dart';

class LooksScreen extends StatelessWidget {
  const LooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = context.read<NavigationController>();

    void unavailable(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 32),
        children: [
          Container(
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'SAVED LOOKS (15)',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => unavailable(
                      'Outfit creator suite is not available in this preview.',
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(
                        'OUTFIT CREATOR\nSUITE',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.grey,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'CURATED LOOKS',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(fontSize: 15),
                  ),
                ),
                Text(
                  'ARCHIVE 2025',
                  style: AppTextStyles.eyebrow.copyWith(
                    fontSize: 9,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => unavailable('Archive filters are ready.'),
                  icon: const Icon(Icons.tune_rounded, size: 19),
                  tooltip: 'Filter looks',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (
            var index = 0;
            index < LooksSampleData.looks.length;
            index++
          ) ...[
            SavedLookCard(
              look: LooksSampleData.looks[index],
              onEdit: () =>
                  unavailable('Editing ${LooksSampleData.looks[index].title}.'),
              onMore: () => unavailable(
                'Look options are not available in this preview.',
              ),
              onStudio: () => navigation.goTo(AppTab.studio),
              onDress: () => unavailable(
                '${LooksSampleData.looks[index].title} selected for the avatar.',
              ),
            ),
            if (index != LooksSampleData.looks.length - 1)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => unavailable(
              'Create new ensemble is not available in this preview.',
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('CREATE NEW ENSEMBLE'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              foregroundColor: AppColors.black,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: AppTextStyles.label,
            ),
          ),
        ],
      ),
    );
  }
}
