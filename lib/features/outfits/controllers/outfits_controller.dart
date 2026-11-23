import 'package:flutter/foundation.dart';

import '../../studio/models/studio_garment.dart';
import '../models/outfit.dart';
import '../services/outfit_repository.dart';

/// Saved outfits of the signed-in user.
///
/// [bindUser] is called by the provider whenever the signed-in user changes.
class OutfitsController extends ChangeNotifier {
  OutfitsController(this._repository);

  final OutfitRepository _repository;

  int? _userId;
  List<Outfit> _outfits = const [];
  bool _loading = false;
  Object? _error;

  List<Outfit> get outfits => _outfits;
  int get savedCount => _outfits.length;
  bool get isLoading => _loading;
  Object? get error => _error;

  Future<void> bindUser(int? userId) async {
    if (userId == _userId) return;
    _userId = userId;
    _outfits = const [];
    _error = null;
    if (userId == null) {
      notifyListeners();
      return;
    }
    _loading = true;
    notifyListeners();
    try {
      final outfits = await _repository.listForUser(userId);
      if (_userId == userId) _outfits = outfits;
    } catch (error, stack) {
      debugPrint('Loading outfits failed: $error\n$stack');
      if (_userId == userId) _error = error;
    } finally {
      if (_userId == userId) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<Outfit> create({
    required String name,
    required String avatarId,
    required Map<StudioGarmentSlot, String> garmentIds,
  }) async {
    final userId = _userId;
    if (userId == null) throw StateError('Sign in to save outfits.');
    final outfit = await _repository.create(
      userId: userId,
      name: name,
      avatarId: avatarId,
      garmentIds: garmentIds,
    );
    _outfits = [outfit, ..._outfits];
    notifyListeners();
    return outfit;
  }

  Future<Outfit> update(Outfit outfit) async {
    final updated = await _repository.update(outfit);
    _outfits = [updated, ..._outfits.where((item) => item.id != updated.id)];
    notifyListeners();
    return updated;
  }

  Future<Outfit> rename(Outfit outfit, String name) =>
      update(outfit.copyWith(name: name));

  Future<void> delete(Outfit outfit) async {
    final id = outfit.id;
    if (id == null) throw ArgumentError('Curated looks cannot be deleted.');
    await _repository.delete(id);
    _outfits = _outfits.where((item) => item.id != id).toList();
    notifyListeners();
  }
}
