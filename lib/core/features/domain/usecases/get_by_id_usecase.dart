import 'package:plc/core/features/domain/repositories/generic_repository.dart';

class GetByIdUseCase<T> {
  final GenericRepository<T> repository;

  GetByIdUseCase(this.repository);

  Future<T> call(String id) async {
    return await repository.getById(id);
  }
}
