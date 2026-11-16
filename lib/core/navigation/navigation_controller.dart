import 'package:flutter/foundation.dart';

/// Top-level destinations shown in the bottom navigation bar.
enum AppTab { home, wardrobe, studio, looks, profile }

/// Holds the currently selected bottom-navigation tab.
class NavigationController extends ChangeNotifier {
  AppTab _current = AppTab.home;

  AppTab get current => _current;

  void goTo(AppTab tab) {
    if (tab == _current) return;
    _current = tab;
    notifyListeners();
  }
}
