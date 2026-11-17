import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileFidelityPicker extends StatelessWidget {
  const ProfileFidelityPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  static const _options = ['MED', 'HIGH', 'ULTRA'];

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    decoration: const BoxDecoration(
      color: Color(0xFFF0F0F0),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: _options.map((option) {
        final selected = value == option;
        return GestureDetector(
          onTap: () => onChanged(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? AppColors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              option,
              style: AppTextStyles.eyebrow.copyWith(
                color: selected ? AppColors.white : AppColors.grey,
                fontSize: 9,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
