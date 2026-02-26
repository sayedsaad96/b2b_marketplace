import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

/// Auth states for the AuthCubit.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no auth check done yet.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state — auth operation in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated with a user profile.
class AuthAuthenticated extends AuthState {
  final UserProfile userProfile;

  const AuthAuthenticated(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

/// Authentication error with a message.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// User is not authenticated.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
