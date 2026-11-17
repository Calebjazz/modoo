import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({
    super.key,
    required this.onSync,
    required this.onExport,
    required this.onSecurity,
  });

  final VoidCallback onSync;
  final VoidCallback onExport;
  final VoidCallback onSecurity;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(28),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Column(
      children: [
        _ActionRow(
          icon: Icons.sync_rounded,
          label: 'Sync Wardrobe with Cloud',
          trailing: 'OFFLINE',
          onPressed: onSync,
        ),
        _ActionRow(
          icon: Icons.camera_alt_outlined,
          label: 'Export 3D Lookbook (4K)',
          onPressed: onExport,
        ),
        _ActionRow(
          icon: Icons.security_rounded,
          label: 'Security & WebGL Permissions',
          onPressed: onSecurity,
          showDivider: false,
        ),
      ],
    ),
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.trailing,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final String? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 48,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.tileTitle.copyWith(fontSize: 14),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextStyles.eyebrow.copyWith(fontSize: 8),
                )
              else
                const Icon(Icons.chevron_right_rounded, color: AppColors.grey),
            ],
          ),
        ),
      ),
      if (showDivider)
        const Divider(height: 1, thickness: 1, color: AppColors.border),
    ],
  );
}
