import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/factory_entity.dart';
import '../../domain/repositories/factory_repository.dart';
import '../datasources/factory_remote_datasource.dart';

class FactoryRepositoryImpl implements FactoryRepository {
  final FactoryRemoteDataSource _remoteDataSource;

  const FactoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Factory>>> getFactories({
    int page = 0,
    int pageSize = 20,
    String? location,
    int? maxMoq,
    double? minRating,
    String? specialization,
    String? searchQuery,
  }) async {
    try {
      final factories = await _remoteDataSource.getFactories(
        page: page,
        pageSize: pageSize,
        location: location,
        maxMoq: maxMoq,
        minRating: minRating,
        specialization: specialization,
        searchQuery: searchQuery,
      );
      return Right(factories);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Factory>> getFactoryById(String id) async {
    try {
      final factoryEntity = await _remoteDataSource.getFactoryById(id);
      return Right(factoryEntity);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Factory>>> getTopFactories({
    int limit = 10,
  }) async {
    try {
      final factories = await _remoteDataSource.getTopFactories(limit: limit);
      return Right(factories);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
