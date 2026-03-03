import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/factory_entity.dart';
import '../repositories/factory_profile_repository.dart';

class UpdateFactoryProfileUseCase {
  final FactoryProfileRepository repository;
  UpdateFactoryProfileUseCase(this.repository);

  Future<Either<Failure, Factory>> call({
    required String name,
    required String location,
    required List<String> specialization,
    required int moq,
    required int avgLeadTime,
  }) {
    return repository.updateProfile(
      name: name,
      location: location,
      specialization: specialization,
      moq: moq,
      avgLeadTime: avgLeadTime,
    );
  }
}
