import 'package:pocketbase/pocketbase.dart';

/// Values of the `kind` select field in the `bundles` collection.
enum BundleKind {
  book('book'),
  kalite('kalite'),
  sample('sample');

  const BundleKind(this.value);

  /// The raw value stored in PocketBase.
  final String value;

  /// Resolves a raw PocketBase value into a [BundleKind],
  /// returning `null` for empty/unknown values.
  static BundleKind? fromValue(String value) {
    for (final kind in BundleKind.values) {
      if (kind.value == value) return kind;
    }
    return null;
  }
}

/// Bundle data model for use across the application.
class Bundle {
  static const String collection = 'bundles';

  /// The record ID.
  final String id;

  /// The bundle name.
  final String name;

  /// The kind of bundle.
  final BundleKind? kind;

  /// The ID of the [Company] this bundle belongs to.
  final String companyId;

  const Bundle({
    required this.id,
    required this.name,
    this.kind,
    required this.companyId,
  });

  /// Maps a PocketBase [RecordModel] into a strongly-typed [Bundle].
  factory Bundle.fromRecord(RecordModel record) {
    return Bundle(
      id: record.id,
      name: record.getStringValue('name'),
      kind: BundleKind.fromValue(record.getStringValue('kind')),
      companyId: record.getStringValue('company'),
    );
  }

  /// Converts this [Bundle] back into a JSON map for sending data to
  /// PocketBase.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      if (kind != null) 'kind': kind!.value,
      'company': companyId,
    };
  }
}
