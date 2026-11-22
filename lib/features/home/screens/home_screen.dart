import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/navigation_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../avatars/screens/avatar_customization_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/capsules_section.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_access_row.dart';
import '../widgets/recent_looks_section.dart';
import '../widgets/studio_preview_card.dart';
import '../widgets/system_status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _gutter = 20.0;

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    final nav = context.read<NavigationController>();
    final firstName = context.watch<AuthController>().user?.firstName ?? '';

    void openStudio() => nav.goTo(AppTab.studio);
    void openCustomization() => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AvatarCustomizationScreen(),
      ),
    );

    Widget padded(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: _gutter),
      child: child,
    );

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            padded(HomeHeader(userName: firstName, avatar: home.activeAvatar)),
            const SizedBox(height: 20),
            padded(
              StudioPreviewCard(
                lookName: home.activeLookName,
                imagePath: home.activeLookImage,
                piecesMounted: home.piecesMounted,
                piecesTotal: home.piecesTotal,
                onStartStyling: openStudio,
                onQuickDress: openStudio,
                onCustomize: openCustomization,
              ),
            ),
            const SizedBox(height: 14),
            padded(
              QuickAccessRow(
                items: [
                  QuickAccessItem(
                    icon: Icons.checkroom_outlined,
                    title: 'Wardrobe',
                    caption: '${home.stats.wardrobeItems} ITEMS',
                    onTap: () => nav.goTo(AppTab.wardrobe),
                  ),
                  QuickAccessItem(
                    icon: Icons.style_outlined,
                    title: 'Saved Looks',
                    caption: '${home.stats.savedLooks} BUILDS',
                    onTap: () => nav.goTo(AppTab.looks),
                  ),
                  QuickAccessItem(
                    icon: Icons.accessibility_new_rounded,
                    title: 'Pose Lab',
                    caption: '${home.stats.poses} ACTIVE',
                    onTap: openStudio,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            RecentLooksSection(
              looks: home.recentLooks,
              totalCount: home.stats.savedLooks,
              isFavorite: home.isFavorite,
              onFavoriteToggle: home.toggleFavorite,
              onReapply: (_) => openStudio(),
              onViewAll: () => nav.goTo(AppTab.looks),
              horizontalPadding: _gutter,
            ),
            const SizedBox(height: 40),
            padded(
              CapsulesSection(
                capsules: home.capsules,
                onOpen: (_) => nav.goTo(AppTab.wardrobe),
              ),
            ),
            const SizedBox(height: 24),
            padded(const SystemStatusCard()),
          ],
        ),
      ),
    );
  }
}
