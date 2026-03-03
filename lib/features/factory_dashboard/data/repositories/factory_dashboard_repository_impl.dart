import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/rfq_request.dart';
import '../../domain/repositories/factory_dashboard_repository.dart';
import '../datasources/factory_dashboard_datasource.dart';

class FactoryDashboardRepositoryImpl implements FactoryDashboardRepository {
  final FactoryDashboardDataSource dataSource;
  FactoryDashboardRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Map<String, int>>> getDashboardStats() async {
    try {
      final stats = await dataSource.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RfqRequest>>> getRecentRfqs({
    int limit = 10,
  }) async {
    try {
      final rfqs = await dataSource.getRecentRfqs(limit);
      return Right(rfqs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RfqRequest>>> getAllRfqsForFactory() async {
    try {
      final rfqs = await dataSource.getAllRfqsForFactory();
      return Right(rfqs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
