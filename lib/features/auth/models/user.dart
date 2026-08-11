import 'package:pocketbase/pocketbase.dart';

/// Values of the `role` select field in the `users` collection.
enum UserRole {
  admin('admin'),
  seller('seller');

  const UserRole(this.value);

  /// The raw value stored in PocketBase.
  final String value;

  /// Resolves a raw PocketBase value into a [UserRole],
  /// returning `null` for empty/unknown values.
  static UserRole? fromValue(String value) {
    for (final role in UserRole.values) {
      if (role.value == value) return role;
    }
    return null;
  }
}

/// Strongly-typed representation of a record in the PocketBase `users`
/// collection.
class User {
  /// The PocketBase collection this model belongs to.
  static const String collection = 'users';

  const User({
    required this.id,
    required this.email,
    required this.emailVisibility,
    required this.verified,
    required this.name,
    required this.avatar,
    this.role,
    this.created,
    this.updated,
  });

  /// Maps a PocketBase [RecordModel] into a strongly-typed [User].
  factory User.fromRecord(RecordModel record) {
    return User(
      id: record.id,
      email: record.getStringValue('email'),
      emailVisibility: record.getBoolValue('emailVisibility'),
      verified: record.getBoolValue('verified'),
      name: record.getStringValue('name'),
      avatar: record.getStringValue('avatar'),
      role: UserRole.fromValue(record.getStringValue('role')),
      created: DateTime.tryParse(record.getStringValue('created')),
      updated: DateTime.tryParse(record.getStringValue('updated')),
    );
  }

  final String id;
  final String email;
  final bool emailVisibility;
  final bool verified;
  final String name;

  /// Filename of the avatar file stored in PocketBase (empty when unset).
  final String avatar;
  final UserRole? role;
  final DateTime? created;
  final DateTime? updated;

  /// Converts this [User] back into a JSON map for sending data to
  /// PocketBase, e.g.:
  ///
  /// ```dart
  /// await pb.collection(User.collection).update(user.id, body: user.toJson());
  /// ```
  ///
  /// Only editable fields are included — `id`, `created`, `updated` and
  /// `verified` are managed by the server, and `avatar` must be uploaded
  /// as a multipart file.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'emailVisibility': emailVisibility,
      'name': name,
      if (role != null) 'role': role!.value,
    };
  }
}
