import 'package:equatable/equatable.dart';

/// Base failure class for domain-level error handling.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure returned by Supabase or network operations.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure returned by authentication operations.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure returned by local cache operations.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
