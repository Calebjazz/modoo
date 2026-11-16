import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/navigation_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;

    Future<void> signOut() async {
      context.read<NavigationController>().goTo(AppTab.home);
      await context.read<AuthController>().signOut();
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ACCOUNT', style: AppTextStyles.eyebrow),
            const SizedBox(height: 10),
            Text(
              (user?.fullName ?? '').toUpperCase(),
              style: AppTextStyles.display,
            ),
            const SizedBox(height: 6),
            Text(user?.email ?? '', style: AppTextStyles.lead),
            const SizedBox(height: 20),
            Text(
              'Saved avatars, outfits, preferences and settings will live here.',
              style: AppTextStyles.body.copyWith(color: AppColors.grey),
            ),
            const Spacer(),
            PillButton(
              label: 'Sign out',
              icon: Icons.logout_rounded,
              variant: PillButtonVariant.tonal,
              expand: true,
              onPressed: signOut,
            ),
          ],
        ),
      ),
    );
  }
}
