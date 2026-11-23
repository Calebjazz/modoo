import '../../studio/models/studio_garment.dart';

/// An outfit: one avatar plus one garment per clothing slot.
///
/// Saved outfits come from SQLite and have an [id]. Curated looks ship with
/// the app, have no [id] and cannot be renamed or deleted.
class Outfit {
  const Outfit({
    this.id,
    required this.name,
    required this.avatarId,
    required this.garmentIds,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
  });

  final int? id;
  final String name;

  /// Studio avatar identifier, e.g. `AURA` or `KAI`.
  final String avatarId;
  final Map<StudioGarmentSlot, String> garmentIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Optional local editorial image (curated looks only).
  final String? imagePath;

  bool get isCurated => id == null;

  /// Garments that still exist in the studio catalogue, in slot order.
  Map<StudioGarmentSlot, StudioGarment> get garments => {
    for (final slot in StudioGarmentSlot.values)
      slot: ?StudioPreviewCatalog.byId(garmentIds[slot]),
  };

  String get description => garments.isEmpty
      ? 'No garments mounted'
      : garments.values.map((garment) => garment.name).join(', ');

  Outfit copyWith({
    String? name,
    String? avatarId,
    Map<StudioGarmentSlot, String>? garmentIds,
    DateTime? updatedAt,
  }) => Outfit(
    id: id,
    name: name ?? this.name,
    avatarId: avatarId ?? this.avatarId,
    garmentIds: garmentIds ?? this.garmentIds,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    imagePath: imagePath,
  );
}
