import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/rfq_request.dart';
import '../repositories/factory_dashboard_repository.dart';

class GetRecentRfqsUseCase {
  final FactoryDashboardRepository repository;
  GetRecentRfqsUseCase(this.repository);

  Future<Either<Failure, List<RfqRequest>>> call({int limit = 10}) {
    return repository.getRecentRfqs(limit: limit);
  }
}
