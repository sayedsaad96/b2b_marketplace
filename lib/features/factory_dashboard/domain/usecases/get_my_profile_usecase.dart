import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../brand/domain/entities/factory_entity.dart';
import '../repositories/factory_profile_repository.dart';

class GetMyProfileUseCase {
  final FactoryProfileRepository repository;
  GetMyProfileUseCase(this.repository);

  Future<Either<Failure, Factory>> call() {
    return repository.getMyProfile();
  }
}
