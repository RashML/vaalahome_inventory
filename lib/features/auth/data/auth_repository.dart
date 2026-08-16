import '../models/user.dart';

/// Authentication contract for the app, independent of the backing service.
///
/// Pages depend on this interface, never on a concrete backend, so the
/// underlying auth provider (PocketBase, mock, anything else) can be
/// swapped by changing only how it's registered in the DI container.
abstract interface class AuthRepository {
  /// The currently authenticated user, or `null` if signed out.
  User? get currentUser;

  /// Emits the current user every time auth state changes.
  Stream<User?> get authStateChanges;

  Future<User> login({required String email, required String password});

  /// Re-validates the current auth token against the backend, returning the
  /// refreshed [User].
  ///
  /// Throws if there is no stored token or it's no longer valid.
  Future<User> refresh();

  Future<void> logout();
}
