import 'package:pocketbase/pocketbase.dart';

/// Company data model for use across the application.
class Company {
  static const String collection = 'companies';

  /// The record ID.
  final String id;

  /// The company name.
  final String name;

  const Company({
    required this.id,
    required this.name,
  });

  /// Maps a PocketBase [RecordModel] into a strongly-typed [Company].
  factory Company.fromRecord(RecordModel record) {
    return Company(
      id: record.id,
      name: record.getStringValue('name'),
    );
  }

  /// Converts this [Company] back into a JSON map for sending data to
  /// PocketBase.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
    };
  }
}
