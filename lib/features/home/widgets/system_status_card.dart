import 'package:flutter/material.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Honest integration status. Update the values as each phase lands.
class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('SYSTEM STATUS', style: AppTextStyles.label),
              ),
              Text(
                '${AppInfo.name} v${AppInfo.version}',
                style: AppTextStyles.eyebrow,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _StatusTile(
                  label: '3D engine',
                  value: 'Unity · Not connected',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatusTile(
                  label: 'Local data',
                  value: 'SQLite · Pending',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.eyebrow.copyWith(fontSize: 9),
          ),
          const SizedBox(height: 4),
          Text(value.toUpperCase(), style: AppTextStyles.label),
        ],
      ),
    );
  }
}
