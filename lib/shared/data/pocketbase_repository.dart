import 'package:pocketbase/pocketbase.dart';

import 'repository.dart';

/// [Repository] implementation backed by a single PocketBase collection.
class PocketBaseRepository<T> implements Repository<T> {
  PocketBaseRepository(
    this._pb, {
    required this.collection,
    required this.fromRecord,
    required this.toJson,
  });

  final PocketBase _pb;

  /// The PocketBase collection name this repository reads/writes.
  final String collection;

  final T Function(RecordModel record) fromRecord;
  final Map<String, dynamic> Function(T item) toJson;

  @override
  Future<List<T>> getAll() async {
    final records = await _pb.collection(collection).getFullList();
    return records.map(fromRecord).toList();
  }

  @override
  Future<T> getById(String id) async {
    final record = await _pb.collection(collection).getOne(id);
    return fromRecord(record);
  }

  @override
  Future<T> create(T item) async {
    final record = await _pb.collection(collection).create(body: toJson(item));
    return fromRecord(record);
  }

  @override
  Future<T> update(String id, T item) async {
    final record = await _pb
        .collection(collection)
        .update(id, body: toJson(item));
    return fromRecord(record);
  }

  @override
  Future<void> delete(String id) {
    return _pb.collection(collection).delete(id);
  }
}
