import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../../studio/models/studio_garment.dart';
import '../models/outfit.dart';
import 'outfit_repository.dart';

/// Stores outfits in `saved_outfits` with one `outfit_items` row per slot.
class SqliteOutfitRepository implements OutfitRepository {
  SqliteOutfitRepository(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<List<Outfit>> listForUser(int userId) async {
    final outfitRows = await _db.query(
      'saved_outfits',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC, id DESC',
    );
    if (outfitRows.isEmpty) return const [];

    final ids = outfitRows.map((row) => row['id']! as int).toList();
    final itemRows = await _db.query(
      'outfit_items',
      where: 'outfit_id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    final itemsByOutfit = <int, Map<StudioGarmentSlot, String>>{};
    for (final row in itemRows) {
      final slot = StudioGarmentSlot.values.asNameMap()[row['clothing_slot']];
      if (slot == null) continue;
      (itemsByOutfit[row['outfit_id']! as int] ??= {})[slot] =
          row['clothing_item_id']! as String;
    }

    return [
      for (final row in outfitRows)
        Outfit(
          id: row['id']! as int,
          name: row['name']! as String,
          avatarId: row['avatar_id']! as String,
          garmentIds: itemsByOutfit[row['id']] ?? const {},
          createdAt: DateTime.parse(row['created_at']! as String),
          updatedAt: DateTime.parse(row['updated_at']! as String),
        ),
    ];
  }

  @override
  Future<Outfit> create({
    required int userId,
    required String name,
    required String avatarId,
    required Map<StudioGarmentSlot, String> garmentIds,
  }) async {
    final now = DateTime.now();
    final id = await _db.transaction((txn) async {
      final id = await txn.insert('saved_outfits', {
        'user_id': userId,
        'name': name,
        'avatar_id': avatarId,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });
      await _writeItems(txn, id, garmentIds);
      return id;
    });
    return Outfit(
      id: id,
      name: name,
      avatarId: avatarId,
      garmentIds: Map.unmodifiable(garmentIds),
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<Outfit> update(Outfit outfit) async {
    final id = outfit.id;
    if (id == null) throw ArgumentError('Curated looks cannot be updated.');
    final updated = outfit.copyWith(updatedAt: DateTime.now());
    await _db.transaction((txn) async {
      await txn.update(
        'saved_outfits',
        {
          'name': updated.name,
          'avatar_id': updated.avatarId,
          'updated_at': updated.updatedAt!.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      await txn.delete('outfit_items', where: 'outfit_id = ?', whereArgs: [id]);
      await _writeItems(txn, id, updated.garmentIds);
    });
    return updated;
  }

  @override
  Future<void> delete(int outfitId) =>
      _db.delete('saved_outfits', where: 'id = ?', whereArgs: [outfitId]);

  static Future<void> _writeItems(
    Transaction txn,
    int outfitId,
    Map<StudioGarmentSlot, String> garmentIds,
  ) async {
    for (final entry in garmentIds.entries) {
      await txn.insert('outfit_items', {
        'outfit_id': outfitId,
        'clothing_item_id': entry.value,
        'clothing_slot': entry.key.name,
      });
    }
  }
}
