import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/factory_entity.dart';
import '../repositories/factory_repository.dart';

class GetFactoryByIdUseCase {
  final FactoryRepository _repository;

  const GetFactoryByIdUseCase(this._repository);

  Future<Either<Failure, Factory>> call(String id) {
    return _repository.getFactoryById(id);
  }
}
