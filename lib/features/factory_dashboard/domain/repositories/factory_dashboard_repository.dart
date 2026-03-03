import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/rfq_request.dart';

abstract class FactoryDashboardRepository {
  Future<Either<Failure, Map<String, int>>> getDashboardStats();
  Future<Either<Failure, List<RfqRequest>>> getRecentRfqs({int limit = 10});
  Future<Either<Failure, List<RfqRequest>>> getAllRfqsForFactory();
}
