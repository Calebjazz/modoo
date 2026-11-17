import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.savedLooks,
    required this.garments,
    required this.avatars,
  });

  final int savedLooks;
  final int garments;
  final int avatars;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(28),
    ),
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
    child: Row(
      children: [
        _Stat(value: '$savedLooks', label: 'SAVED LOOKS'),
        _Stat(value: '$garments', label: 'GARMENTS', highlighted: true),
        _Stat(value: '$avatars', label: '3D AVATARS'),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    this.highlighted = false,
  });

  final String value;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFE9E9E9) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.title.copyWith(fontSize: 20)),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.eyebrow.copyWith(
                fontSize: 9,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
