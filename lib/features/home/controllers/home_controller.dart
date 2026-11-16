import 'package:flutter/foundation.dart';

import '../data/home_sample_data.dart';
import '../models/home_models.dart';

/// State for the Home screen.
///
/// Currently reads from [HomeSampleData]; swap for repositories once the
/// SQLite layer exists. Favourites are kept in memory for this session only.
class HomeController extends ChangeNotifier {
  final Set<String> _favoriteLookIds = {};

  ActiveAvatarSummary get activeAvatar => HomeSampleData.activeAvatar;
  String get activeLookName => HomeSampleData.activeLookName;
  String get activeLookImage => HomeSampleData.activeLookImage;
  int get piecesMounted => HomeSampleData.piecesMounted;
  int get piecesTotal => HomeSampleData.piecesTotal;
  HomeStats get stats => HomeSampleData.stats;
  List<LookPreview> get recentLooks => HomeSampleData.recentLooks;
  List<CapsulePreview> get capsules => HomeSampleData.capsules;

  bool isFavorite(String lookId) => _favoriteLookIds.contains(lookId);

  void toggleFavorite(String lookId) {
    if (!_favoriteLookIds.remove(lookId)) _favoriteLookIds.add(lookId);
    notifyListeners();
  }
}
