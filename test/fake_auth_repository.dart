import 'package:modoo/features/auth/models/app_user.dart';
import 'package:modoo/features/auth/services/auth_repository.dart';

/// In-memory [AuthRepository] for widget tests (no SQLite needed).
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? signedIn}) : _current = signedIn {
    if (signedIn != null) _users[signedIn.email] = (signedIn, 'password123');
  }

  final Map<String, (AppUser, String)> _users = {};
  AppUser? _current;

  @override
  Future<AppUser?> currentUser() async => _current;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final entry = _users[email.trim().toLowerCase()];
    if (entry == null || entry.$2 != password) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }
    return _current = entry.$1;
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final key = email.trim().toLowerCase();
    if (_users.containsKey(key)) {
      throw const AuthException(AuthErrorCode.emailInUse);
    }
    final user = AppUser(
      id: _users.length + 1,
      fullName: fullName.trim(),
      email: key,
      createdAt: DateTime.now(),
    );
    _users[key] = (user, password);
    return _current = user;
  }

  @override
  Future<AppUser> updateDisplayName({
    required int userId,
    required String fullName,
  }) async {
    final entry = _users.entries.firstWhere(
      (entry) => entry.value.$1.id == userId,
    );
    final updated = AppUser(
      id: userId,
      fullName: fullName.trim(),
      email: entry.value.$1.email,
      createdAt: entry.value.$1.createdAt,
    );
    _users[entry.key] = (updated, entry.value.$2);
    return _current = updated;
  }

  @override
  Future<void> signOut() async => _current = null;
}
