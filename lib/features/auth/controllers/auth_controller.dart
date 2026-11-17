import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_repository.dart';

enum AuthStatus { loading, signedOut, signedIn }

/// App-wide authentication state. Screens call [signIn] / [register] and
/// catch [AuthException] to show a message.
class AuthController extends ChangeNotifier {
  AuthController(this._repository) {
    _restoreSession();
  }

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.loading;
  AppUser? _user;

  AuthStatus get status => _status;
  AppUser? get user => _user;

  Future<void> _restoreSession() async {
    try {
      _setUser(await _repository.currentUser());
    } catch (e, st) {
      debugPrint('Session restore failed: $e\n$st');
      _setUser(null);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    _setUser(await _repository.signIn(email: email, password: password));
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setUser(await _repository.register(
      fullName: fullName,
      email: email,
      password: password,
    ));
  }

  Future<void> updateDisplayName(String fullName) async {
    final user = _user;
    if (user == null) throw StateError('No signed-in user to update.');
    final normalizedName = fullName.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(fullName, 'fullName', 'Must not be empty.');
    }

    _setUser(
      await _repository.updateDisplayName(
        userId: user.id,
        fullName: normalizedName,
      ),
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _setUser(null);
  }

  void _setUser(AppUser? user) {
    _user = user;
    _status = user == null ? AuthStatus.signedOut : AuthStatus.signedIn;
    notifyListeners();
  }
}
