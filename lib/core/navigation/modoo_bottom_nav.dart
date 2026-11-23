import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'navigation_controller.dart';

/// Five-destination bottom bar with a raised circular Studio action.
class ModooBottomNav extends StatelessWidget {
  const ModooBottomNav({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final AppTab current;
  final ValueChanged<AppTab> onSelected;

  @override
  Widget build(BuildContext context) {
    Widget item(AppTab tab, IconData icon, String label) => Expanded(
      child: _NavItem(
        icon: icon,
        label: label,
        selected: current == tab,
        onTap: () => onSelected(tab),
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              item(AppTab.home, Icons.grid_view_outlined, 'HOME'),
              item(AppTab.wardrobe, Icons.checkroom_outlined, 'WARDROBE'),
              Expanded(
                child: _StudioItem(
                  selected: current == AppTab.studio,
                  onTap: () => onSelected(AppTab.studio),
                ),
              ),
              item(AppTab.looks, Icons.style_outlined, 'LOOKS'),
              item(AppTab.profile, Icons.person_outline_rounded, 'PROFILE'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.black : AppColors.grey;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 5),
            Text(label, style: AppTextStyles.navLabel.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _StudioItem extends StatelessWidget {
  const _StudioItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'STUDIO',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Transform.translate(
          offset: const Offset(0, -10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                ),
                child: const Icon(
                  Icons.view_in_ar_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'STUDIO',
                style: AppTextStyles.navLabel.copyWith(
                  color: selected ? AppColors.black : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
