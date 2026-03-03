import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/factory_entity.dart';
import '../repositories/factory_repository.dart';

class GetFactoriesUseCase {
  final FactoryRepository _repository;

  const GetFactoriesUseCase(this._repository);

  Future<Either<Failure, List<Factory>>> call({
    int page = 0,
    int pageSize = 20,
    String? location,
    int? maxMoq,
    double? minRating,
    String? specialization,
    String? searchQuery,
  }) {
    return _repository.getFactories(
      page: page,
      pageSize: pageSize,
      location: location,
      maxMoq: maxMoq,
      minRating: minRating,
      specialization: specialization,
      searchQuery: searchQuery,
    );
  }
}
