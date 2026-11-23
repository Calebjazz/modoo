import 'package:modoo/features/outfits/models/outfit.dart';
import 'package:modoo/features/outfits/services/outfit_repository.dart';
import 'package:modoo/features/studio/models/studio_garment.dart';

/// In-memory [OutfitRepository] for widget tests (no SQLite needed).
class FakeOutfitRepository implements OutfitRepository {
  final Map<int, (int userId, Outfit outfit)> _rows = {};
  int _nextId = 1;

  @override
  Future<List<Outfit>> listForUser(int userId) async => [
    for (final row in _rows.values.toList().reversed)
      if (row.$1 == userId) row.$2,
  ];

  @override
  Future<Outfit> create({
    required int userId,
    required String name,
    required String avatarId,
    required Map<StudioGarmentSlot, String> garmentIds,
  }) async {
    final now = DateTime(2026, 11, 23);
    final outfit = Outfit(
      id: _nextId++,
      name: name,
      avatarId: avatarId,
      garmentIds: Map.of(garmentIds),
      createdAt: now,
      updatedAt: now,
    );
    _rows[outfit.id!] = (userId, outfit);
    return outfit;
  }

  @override
  Future<Outfit> update(Outfit outfit) async {
    final row = _rows[outfit.id]!;
    _rows[outfit.id!] = (row.$1, outfit);
    return outfit;
  }

  @override
  Future<void> delete(int outfitId) async => _rows.remove(outfitId);

  List<Outfit> get all => [for (final row in _rows.values) row.$2];
}
