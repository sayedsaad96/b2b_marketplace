import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_profile_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initialize all dependencies.
/// Call this in main() before runApp().
Future<void> initDependencies() async {
  // ── External ──
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ── Data sources ──
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // ── Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // ── Use cases ──
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => GetCurrentProfileUseCase(sl<AuthRepository>()),
  );

  // ── Cubits ──
  sl.registerFactory(
    () => AuthCubit(
      signUpUseCase: sl<SignUpUseCase>(),
      signInUseCase: sl<SignInUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      getCurrentProfileUseCase: sl<GetCurrentProfileUseCase>(),
    ),
  );

  // ── Router ──
  sl.registerLazySingleton<GoRouter>(() => AppRouter.router);
}
