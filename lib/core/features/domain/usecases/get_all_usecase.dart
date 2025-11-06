import 'package:plc/core/features/domain/repositories/generic_repository.dart';

class GetAllUseCase<T> {
  final GenericRepository<T> repository;

  GetAllUseCase(this.repository);

  Future<List<T>> call() async {
    return await repository.getAll();
  }
}
