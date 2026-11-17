import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/navigation_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../widgets/profile_account_dialogs.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_avatar_card.dart';
import '../widgets/profile_footer.dart';
import '../widgets/profile_hero.dart';
import '../widgets/profile_lookbook_section.dart';
import '../widgets/profile_preferences.dart';
import '../widgets/profile_section_header.dart';
import '../widgets/profile_stats.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final home = context.watch<HomeController>();
    final navigation = context.read<NavigationController>();
    final name = user?.fullName ?? 'MODOO MEMBER';
    final email = user?.email ?? '';

    return SafeArea(
      bottom: false,
      child: ColoredBox(
        color: const Color(0xFFF9F9F9),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 36),
          children: [
            ProfileHero(
              userName: name,
              email: email,
              memberNumber: user?.id,
              onEditIdentity: () =>
                  ProfileAccountDialogs.editIdentity(context, name),
              onCopyProfile: () =>
                  ProfileAccountDialogs.copyProfile(context, name, user?.id),
              onMemberCard: () => ProfileAccountDialogs.memberCard(
                context,
                name,
                email,
                user?.id,
              ),
            ),
            const SizedBox(height: 24),
            ProfileStats(
              savedLooks: home.stats.savedLooks,
              garments: home.stats.wardrobeItems,
              avatars: 1,
            ),
            const SizedBox(height: 24),
            ProfileSectionHeader(
              icon: Icons.accessibility_new_rounded,
              title: 'MY 3D MODELS',
              trailing: Text(
                'ACTIVE: ${home.activeAvatar.code}',
                style: const TextStyle(fontSize: 10, color: AppColors.grey),
              ),
            ),
            const SizedBox(height: 12),
            ProfileAvatarCard(
              avatar: home.activeAvatar,
              onOpenStudio: () => navigation.goTo(AppTab.studio),
            ),
            const SizedBox(height: 28),
            ProfileLookbookSection(
              looks: home.recentLooks.take(2).toList(),
              totalCount: home.stats.savedLooks,
              onViewAll: () => navigation.goTo(AppTab.looks),
              onTestFit: () => navigation.goTo(AppTab.studio),
            ),
            const SizedBox(height: 28),
            const ProfilePreferences(),
            const SizedBox(height: 24),
            ProfileActions(
              onSync: () => ProfileAccountDialogs.unavailable(
                context,
                'Cloud sync is not available in this local-only Flutter app.',
              ),
              onExport: () => ProfileAccountDialogs.unavailable(
                context,
                '4K export needs rendered lookbook assets, which are not '
                'available in this Flutter profile preview.',
              ),
              onSecurity: () => ProfileAccountDialogs.unavailable(
                context,
                'WebGL browser permissions do not apply to this native Flutter '
                'app. No browser permissions are requested.',
              ),
            ),
            const SizedBox(height: 28),
            ProfileFooter(
              onSignOut: () async {
                navigation.goTo(AppTab.home);
                await context.read<AuthController>().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
