import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

/// Abstract repository contract for authentication operations.
abstract class AuthRepository {
  /// Creates a new account and profile.
  Future<Either<Failure, UserProfile>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });

  /// Authenticates with email and password.
  Future<Either<Failure, UserProfile>> signIn({
    required String email,
    required String password,
  });

  /// Signs the current user out.
  Future<Either<Failure, void>> signOut();

  /// Fetches the profile of the currently authenticated user.
  Future<Either<Failure, UserProfile>> getCurrentUserProfile();
}
