abstract class GenericRepository<T> {
  Future<List<T>> getAll();
  Future<T> getById(String id);
}
