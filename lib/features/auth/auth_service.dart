import 'dart:async';

import 'package:flutter/foundation.dart';

import 'data/auth_repository.dart';
import 'models/user.dart';

enum AuthStatus {
  /// Auth state hasn't been resolved yet (before the first [AuthService.initialize]
  /// call completes).
  unknown,
  authenticated,
  unauthenticated,
}

/// App-wide auth state, sourced from [AuthRepository].
///
/// Registered as a singleton in the DI container, so every caller resolving
/// it (e.g. `getIt<AuthService>()`) shares the same instance and sees the
/// same up-to-date [status]/[user]. Call [initialize] once at app start.
class AuthService extends ChangeNotifier {
  AuthService(this._authRepository) {
    _subscription = _authRepository.authStateChanges.listen(_setUser);
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _subscription;

  AuthStatus _status = AuthStatus.unknown;
  User? _user;

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// The signed-in user, or `null` if [status] isn't [AuthStatus.authenticated].
  User? get user => _user;

  UserRole? get role => _user?.role;

  /// Resolves the initial auth state. Call once at app start, before
  /// depending on [status]/[user].
  Future<void> initialize() => refresh();

  /// Re-validates the current auth token against the backend, updating
  /// [status]/[user] (or signing out if the token is no longer valid).
  Future<void> refresh() async {
    if (_authRepository.currentUser == null) {
      _setUser(null);
      return;
    }
    try {
      _setUser(await _authRepository.refresh());
    } catch (_) {
      await logout();
    }
  }

  Future<void> logout() => _authRepository.logout();

  void _setUser(User? user) {
    _user = user;
    _status = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
