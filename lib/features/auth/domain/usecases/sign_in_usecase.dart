import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Use case: Sign in an existing user.
class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<Either<Failure, UserProfile>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
