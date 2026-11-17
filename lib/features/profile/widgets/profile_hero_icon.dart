import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileHeroIcon extends StatelessWidget {
  const ProfileHeroIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(icon, size: 19, color: AppColors.black),
    style: IconButton.styleFrom(
      backgroundColor: const Color(0xFFEAEAEA),
      fixedSize: const Size(44, 44),
    ),
  );
}
