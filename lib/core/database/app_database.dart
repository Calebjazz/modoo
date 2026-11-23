import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Single local SQLite database for MODOO (CLAUDE.md §3).
///
/// Add new tables through [_onUpgrade] by bumping [_version].
class AppDatabase {
  AppDatabase._(this.db);

  static const _fileName = 'modoo.db';
  static const _version = 2;

  final Database db;

  static Future<AppDatabase> open() async {
    final dir = await getDatabasesPath();
    final db = await openDatabase(
      p.join(dir, _fileName),
      version: _version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) => _onUpgrade(db, 0, version),
      onUpgrade: _onUpgrade,
    );
    return AppDatabase._(db);
  }

  static Future<void> _onUpgrade(Database db, int from, int to) async {
    if (from < 1) {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          full_name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE COLLATE NOCASE,
          password_hash TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE app_settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
    }
    if (from < 2) {
      await db.execute('''
        CREATE TABLE saved_outfits (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          name TEXT NOT NULL,
          avatar_id TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      await db.execute(
        'CREATE INDEX idx_saved_outfits_user ON saved_outfits(user_id)',
      );
      await db.execute('''
        CREATE TABLE outfit_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          outfit_id INTEGER NOT NULL
            REFERENCES saved_outfits(id) ON DELETE CASCADE,
          clothing_item_id TEXT NOT NULL,
          clothing_slot TEXT NOT NULL,
          UNIQUE (outfit_id, clothing_slot)
        )
      ''');
    }
  }
}
