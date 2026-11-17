import '../../../core/database/app_database.dart';
import '../models/app_user.dart';

class SqliteProfileRepository {
  const SqliteProfileRepository(this._database);

  final AppDatabase _database;

  Future<AppUser> updateDisplayName({
    required int userId,
    required String fullName,
  }) async {
    final normalizedName = fullName.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(fullName, 'fullName', 'Must not be empty.');
    }
    final updated = await _database.db.update(
      'users',
      {'full_name': normalizedName},
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (updated != 1) {
      throw StateError('Could not find account $userId to update.');
    }
    final rows = await _database.db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return AppUser.fromRow(rows.single);
  }
}
