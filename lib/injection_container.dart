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

import 'features/brand/data/datasources/factory_remote_datasource.dart';
import 'features/brand/data/datasources/rfq_remote_datasource.dart';
import 'features/brand/data/repositories/factory_repository_impl.dart';
import 'features/brand/data/repositories/rfq_repository_impl.dart';
import 'features/brand/domain/repositories/factory_repository.dart';
import 'features/brand/domain/repositories/rfq_repository.dart';
import 'features/brand/domain/usecases/get_factories_usecase.dart';
import 'features/brand/domain/usecases/get_factory_by_id_usecase.dart';
import 'features/brand/domain/usecases/get_top_factories_usecase.dart';
import 'features/brand/domain/usecases/submit_rfq_usecase.dart';
import 'features/brand/domain/usecases/get_my_rfqs_usecase.dart';
import 'features/brand/presentation/bloc/factory_search_cubit.dart';
import 'features/brand/presentation/bloc/rfq_cubit.dart';

// Phase 4 - Factory Dashboard Imports
import 'features/factory_dashboard/data/datasources/quote_remote_datasource.dart';
import 'features/factory_dashboard/data/datasources/message_remote_datasource.dart';
import 'features/factory_dashboard/data/datasources/factory_profile_datasource.dart';
import 'features/factory_dashboard/data/datasources/factory_dashboard_datasource.dart';

import 'features/factory_dashboard/data/repositories/quote_repository_impl.dart';
import 'features/factory_dashboard/data/repositories/message_repository_impl.dart';
import 'features/factory_dashboard/data/repositories/factory_profile_repository_impl.dart';
import 'features/factory_dashboard/data/repositories/factory_dashboard_repository_impl.dart';

import 'features/factory_dashboard/domain/repositories/quote_repository.dart';
import 'features/factory_dashboard/domain/repositories/message_repository.dart';
import 'features/factory_dashboard/domain/repositories/factory_profile_repository.dart';
import 'features/factory_dashboard/domain/repositories/factory_dashboard_repository.dart';

import 'features/factory_dashboard/domain/usecases/submit_quote_usecase.dart';
import 'features/factory_dashboard/domain/usecases/get_accepted_quotes_usecase.dart';
import 'features/factory_dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'features/factory_dashboard/domain/usecases/get_recent_rfqs_usecase.dart';
import 'features/factory_dashboard/domain/usecases/get_factory_rfqs_usecase.dart';
import 'features/factory_dashboard/domain/usecases/send_message_usecase.dart';
import 'features/factory_dashboard/domain/usecases/get_messages_usecase.dart';
import 'features/factory_dashboard/domain/usecases/update_factory_profile_usecase.dart';
import 'features/factory_dashboard/domain/usecases/get_my_profile_usecase.dart';

import 'features/factory_dashboard/presentation/bloc/factory_dashboard_cubit.dart';
import 'features/factory_dashboard/presentation/bloc/rfq_inbox_cubit.dart';
import 'features/factory_dashboard/presentation/bloc/submit_quote_cubit.dart';
import 'features/factory_dashboard/presentation/bloc/chat_cubit.dart';
import 'features/factory_dashboard/presentation/bloc/factory_profile_cubit.dart';

// Phase 5 - PDF Export Imports
import 'core/services/pdf_service.dart';
import 'features/pdf_export/presentation/bloc/pdf_export_cubit.dart';

// Phase 5 - Notification Imports
import 'core/services/notification_service.dart';
import 'features/notifications/data/datasources/notification_remote_datasource.dart';
import 'features/notifications/presentation/bloc/notification_cubit.dart';

// Phase 5 - Admin Dashboard Imports
import 'features/admin/data/datasources/admin_remote_datasource.dart';
import 'features/admin/presentation/bloc/admin_dashboard_cubit.dart';

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
  sl.registerLazySingleton<FactoryRemoteDataSource>(
    () => FactoryRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<RfqRemoteDataSource>(
    () => RfqRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<FactoryProfileDataSource>(
    () => FactoryProfileDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<FactoryDashboardDataSource>(
    () => FactoryDashboardDataSourceImpl(sl<SupabaseClient>()),
  );

  // ── Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<FactoryRepository>(
    () => FactoryRepositoryImpl(sl<FactoryRemoteDataSource>()),
  );
  sl.registerLazySingleton<RfqRepository>(
    () => RfqRepositoryImpl(sl<RfqRemoteDataSource>()),
  );
  sl.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(sl<QuoteRemoteDataSource>()),
  );
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(sl<MessageRemoteDataSource>()),
  );
  sl.registerLazySingleton<FactoryProfileRepository>(
    () => FactoryProfileRepositoryImpl(sl<FactoryProfileDataSource>()),
  );
  sl.registerLazySingleton<FactoryDashboardRepository>(
    () => FactoryDashboardRepositoryImpl(sl<FactoryDashboardDataSource>()),
  );

  // ── Use cases ──
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => GetCurrentProfileUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton(() => GetFactoriesUseCase(sl<FactoryRepository>()));
  sl.registerLazySingleton(
    () => GetFactoryByIdUseCase(sl<FactoryRepository>()),
  );
  sl.registerLazySingleton(
    () => GetTopFactoriesUseCase(sl<FactoryRepository>()),
  );

  sl.registerLazySingleton(() => SubmitRfqUseCase(sl<RfqRepository>()));
  sl.registerLazySingleton(() => GetMyRfqsUseCase(sl<RfqRepository>()));

  sl.registerLazySingleton(() => SubmitQuoteUseCase(sl<QuoteRepository>()));
  sl.registerLazySingleton(
    () => GetAcceptedQuotesUseCase(sl<QuoteRepository>()),
  );
  sl.registerLazySingleton(
    () => GetDashboardStatsUseCase(sl<FactoryDashboardRepository>()),
  );
  sl.registerLazySingleton(
    () => GetRecentRfqsUseCase(sl<FactoryDashboardRepository>()),
  );
  sl.registerLazySingleton(
    () => GetFactoryRfqsUseCase(sl<FactoryDashboardRepository>()),
  );
  sl.registerLazySingleton(() => SendMessageUseCase(sl<MessageRepository>()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl<MessageRepository>()));
  sl.registerLazySingleton(
    () => UpdateFactoryProfileUseCase(sl<FactoryProfileRepository>()),
  );
  sl.registerLazySingleton(
    () => GetMyProfileUseCase(sl<FactoryProfileRepository>()),
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

  sl.registerFactory(
    () => FactorySearchCubit(
      getFactories: sl<GetFactoriesUseCase>(),
      getFactoryById: sl<GetFactoryByIdUseCase>(),
      getTopFactories: sl<GetTopFactoriesUseCase>(),
    ),
  );

  sl.registerFactory(
    () => RfqCubit(
      submitRfq: sl<SubmitRfqUseCase>(),
      getMyRfqs: sl<GetMyRfqsUseCase>(),
      repository: sl<RfqRepository>(),
    ),
  );

  sl.registerFactory(
    () => FactoryDashboardCubit(
      getDashboardStats: sl<GetDashboardStatsUseCase>(),
      getRecentRfqs: sl<GetRecentRfqsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => RfqInboxCubit(
      getFactoryRfqs: sl<GetFactoryRfqsUseCase>(),
      quoteRepository: sl<QuoteRepository>(),
    ),
  );
  sl.registerFactory(
    () => SubmitQuoteCubit(submitQuoteUseCase: sl<SubmitQuoteUseCase>()),
  );
  sl.registerFactory(
    () => ChatCubit(
      getMessagesUseCase: sl<GetMessagesUseCase>(),
      sendMessageUseCase: sl<SendMessageUseCase>(),
      repository: sl<MessageRepository>(),
    ),
  );
  sl.registerFactory(
    () => FactoryProfileCubit(
      getMyProfileUseCase: sl<GetMyProfileUseCase>(),
      updateFactoryProfileUseCase: sl<UpdateFactoryProfileUseCase>(),
      repository: sl<FactoryProfileRepository>(),
    ),
  );

  // ── Phase 5: PDF Service ──
  sl.registerLazySingleton(() => PdfService());
  sl.registerFactory(() => PdfExportCubit(pdfService: sl<PdfService>()));

  // ── Phase 5: Notification Service ──
  sl.registerLazySingleton(() => NotificationService(sl<SupabaseClient>()));
  sl.registerLazySingleton(
    () => NotificationRemoteDataSource(sl<SupabaseClient>()),
  );
  sl.registerFactory(
    () => NotificationCubit(
      dataSource: sl<NotificationRemoteDataSource>(),
      supabase: sl<SupabaseClient>(),
    ),
  );

  // ── Phase 5: Admin Dashboard ──
  sl.registerLazySingleton(() => AdminRemoteDataSource(sl<SupabaseClient>()));
  sl.registerFactory(
    () => AdminDashboardCubit(dataSource: sl<AdminRemoteDataSource>()),
  );

  // ── Router ──
  sl.registerLazySingleton<GoRouter>(() => AppRouter.router);
}
