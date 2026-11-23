import '../../studio/models/studio_garment.dart';
import '../models/outfit.dart';

/// Persistence contract for a user's saved outfits.
abstract interface class OutfitRepository {
  /// Saved outfits for [userId], most recently updated first.
  Future<List<Outfit>> listForUser(int userId);

  Future<Outfit> create({
    required int userId,
    required String name,
    required String avatarId,
    required Map<StudioGarmentSlot, String> garmentIds,
  });

  /// Replaces name, avatar and garments of an existing outfit.
  Future<Outfit> update(Outfit outfit);

  Future<void> delete(int outfitId);
}
