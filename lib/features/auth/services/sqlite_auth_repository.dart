import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../models/app_user.dart';
import 'auth_repository.dart';
import 'password_hasher.dart';
import 'sqlite_profile_repository.dart';

class SqliteAuthRepository implements AuthRepository {
  SqliteAuthRepository(this._database, {PasswordHasher? hasher})
    : _hasher = hasher ?? const PasswordHasher(),
      _profiles = SqliteProfileRepository(_database);

  static const _sessionKey = 'current_user_id';

  final AppDatabase _database;
  final PasswordHasher _hasher;
  final SqliteProfileRepository _profiles;

  Database get _db => _database.db;

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  @override
  Future<AppUser?> currentUser() async {
    final session = await _db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [_sessionKey],
    );
    if (session.isEmpty) return null;
    final id = int.tryParse(session.first['value']! as String);
    if (id == null) return null;
    final rows = await _db.query('users', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : AppUser.fromRow(rows.first);
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final rows = await _db.query(
      'users',
      where: 'email = ?',
      whereArgs: [_normalizeEmail(email)],
    );
    if (rows.isEmpty) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }
    final ok =
        await _hasher.verify(password, rows.first['password_hash']! as String);
    if (!ok) throw const AuthException(AuthErrorCode.invalidCredentials);

    final user = AppUser.fromRow(rows.first);
    await _saveSession(user.id);
    return user;
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalized = _normalizeEmail(email);
    final existing = await _db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [normalized],
    );
    if (existing.isNotEmpty) {
      throw const AuthException(AuthErrorCode.emailInUse);
    }

    final hash = await _hasher.hash(password);
    final createdAt = DateTime.now().toUtc();
    final int id;
    try {
      id = await _db.insert('users', {
        'full_name': fullName.trim(),
        'email': normalized,
        'password_hash': hash,
        'created_at': createdAt.toIso8601String(),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const AuthException(AuthErrorCode.emailInUse);
      }
      rethrow;
    }

    await _saveSession(id);
    return AppUser(
      id: id,
      fullName: fullName.trim(),
      email: normalized,
      createdAt: createdAt,
    );
  }

  @override
  Future<AppUser> updateDisplayName({
    required int userId,
    required String fullName,
  }) => _profiles.updateDisplayName(userId: userId, fullName: fullName);

  @override
  Future<void> signOut() async {
    await _db.delete(
      'app_settings',
      where: 'key = ?',
      whereArgs: [_sessionKey],
    );
  }

  Future<void> _saveSession(int userId) => _db.insert(
        'app_settings',
        {'key': _sessionKey, 'value': '$userId'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
