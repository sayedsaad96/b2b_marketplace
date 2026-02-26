import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_profile_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

/// Cubit managing authentication state.
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentProfileUseCase _getCurrentProfileUseCase;

  AuthCubit({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentProfileUseCase getCurrentProfileUseCase,
  }) : _signUpUseCase = signUpUseCase,
       _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase,
       _getCurrentProfileUseCase = getCurrentProfileUseCase,
       super(const AuthInitial());

  /// Sign up a new user with the given details and role.
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    emit(const AuthLoading());
    final result = await _signUpUseCase(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profile) => emit(AuthAuthenticated(profile)),
    );
  }

  /// Sign in an existing user.
  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _signInUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profile) => emit(AuthAuthenticated(profile)),
    );
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  /// Check if there is an existing authenticated session.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final result = await _getCurrentProfileUseCase();
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (profile) => emit(AuthAuthenticated(profile)),
    );
  }
}
