import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Use case: Sign up a new user with role.
class SignUpUseCase {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  Future<Either<Failure, UserProfile>> call({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );
  }
}
