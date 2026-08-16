/// Generic data-access contract for a [T] entity.
///
/// Pages/blocs depend on this interface, never on a concrete backend, so the
/// underlying data source (PocketBase, mock, anything else) can be swapped
/// by changing only how it's registered in the DI container.
abstract interface class Repository<T> {
  Future<List<T>> getAll();

  Future<T> getById(String id);

  Future<T> create(T item);

  Future<T> update(String id, T item);

  Future<void> delete(String id);
}
