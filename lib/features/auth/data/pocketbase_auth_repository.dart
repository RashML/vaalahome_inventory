import 'package:pocketbase/pocketbase.dart';

import 'package:inventory_app/features/auth/models/user.dart';
import 'auth_repository.dart';

/// [AuthRepository] implementation backed by PocketBase's auth store.
class PocketBaseAuthRepository implements AuthRepository {
  PocketBaseAuthRepository(this._pb);

  final PocketBase _pb;

  @override
  User? get currentUser {
    final record = _pb.authStore.record;
    return record == null ? null : User.fromRecord(record);
  }

  @override
  Stream<User?> get authStateChanges => _pb.authStore.onChange.map(
    (event) => event.record == null ? null : User.fromRecord(event.record!),
  );

  @override
  Future<User> login({required String email, required String password}) async {
    final auth = await _pb
        .collection(User.collection)
        .authWithPassword(email, password);
    return User.fromRecord(auth.record);
  }

  @override
  Future<User> refresh() async {
    final auth = await _pb.collection(User.collection).authRefresh();
    return User.fromRecord(auth.record);
  }

  @override
  Future<void> logout() async {
    _pb.authStore.clear();
  }
}
