import '../models/app_user.dart';

enum AuthErrorCode { emailInUse, invalidCredentials }

class AuthException implements Exception {
  const AuthException(this.code);

  final AuthErrorCode code;

  String get message => switch (code) {
        AuthErrorCode.emailInUse =>
          'An account with this email already exists on this device.',
        AuthErrorCode.invalidCredentials => 'Incorrect email or password.',
      };

  @override
  String toString() => 'AuthException($code)';
}

/// Account storage. The app ships with [SqliteAuthRepository]: accounts are
/// local to the device — there is no backend (CLAUDE.md §9.7).
abstract interface class AuthRepository {
  /// The signed-in user from the last session, if any.
  Future<AppUser?> currentUser();

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> signOut();
}
