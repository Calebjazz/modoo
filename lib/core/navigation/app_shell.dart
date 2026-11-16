import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/outfits/screens/looks_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/studio/screens/studio_screen.dart';
import '../../features/wardrobe/screens/wardrobe_screen.dart';
import 'modoo_bottom_nav.dart';
import 'navigation_controller.dart';

/// Root scaffold: keeps each tab alive in an [IndexedStack].
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  // Order must match [AppTab].
  static const List<Widget> _screens = [
    HomeScreen(),
    WardrobeScreen(),
    StudioScreen(),
    LooksScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: IndexedStack(index: nav.current.index, children: _screens),
        bottomNavigationBar: ModooBottomNav(
          current: nav.current,
          onSelected: nav.goTo,
        ),
      ),
    );
  }
}
