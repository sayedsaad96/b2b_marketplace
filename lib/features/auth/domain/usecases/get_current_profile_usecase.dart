import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Use case: Get the currently authenticated user's profile.
class GetCurrentProfileUseCase {
  final AuthRepository _repository;

  const GetCurrentProfileUseCase(this._repository);

  Future<Either<Failure, UserProfile>> call() {
    return _repository.getCurrentUserProfile();
  }
}
