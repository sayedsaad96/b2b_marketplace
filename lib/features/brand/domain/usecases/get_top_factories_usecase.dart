import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/factory_entity.dart';
import '../repositories/factory_repository.dart';

class GetTopFactoriesUseCase {
  final FactoryRepository _repository;

  const GetTopFactoriesUseCase(this._repository);

  Future<Either<Failure, List<Factory>>> call({int limit = 10}) {
    return _repository.getTopFactories(limit: limit);
  }
}
