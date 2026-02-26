import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Supabase implementation of [AuthRepository].
///
/// Wraps all datasource calls in try/catch and returns
/// [Either<Failure, T>] for clean error propagation.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      final profile = await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final profile = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getCurrentUserProfile() async {
    try {
      final profile = await _remoteDataSource.getCurrentUserProfile();
      return Right(profile);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
