import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/factory_entity.dart';

abstract class FactoryRepository {
  Future<Either<Failure, List<Factory>>> getFactories({
    int page = 0,
    int pageSize = 20,
    String? location,
    int? maxMoq,
    double? minRating,
    String? specialization,
    String? searchQuery,
  });

  Future<Either<Failure, Factory>> getFactoryById(String id);

  Future<Either<Failure, List<Factory>>> getTopFactories({int limit = 10});
}
