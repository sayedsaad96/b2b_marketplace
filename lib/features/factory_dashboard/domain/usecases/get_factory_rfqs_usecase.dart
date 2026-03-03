import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/rfq_request.dart';
import '../repositories/factory_dashboard_repository.dart';

class GetFactoryRfqsUseCase {
  final FactoryDashboardRepository repository;
  GetFactoryRfqsUseCase(this.repository);

  Future<Either<Failure, List<RfqRequest>>> call() {
    return repository.getAllRfqsForFactory();
  }
}
