import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/factory_dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final FactoryDashboardRepository repository;
  GetDashboardStatsUseCase(this.repository);

  Future<Either<Failure, Map<String, int>>> call() {
    return repository.getDashboardStats();
  }
}
