import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_recent_rfqs_usecase.dart';
import 'factory_dashboard_state.dart';

class FactoryDashboardCubit extends Cubit<FactoryDashboardState> {
  final GetDashboardStatsUseCase getDashboardStats;
  final GetRecentRfqsUseCase getRecentRfqs;

  FactoryDashboardCubit({
    required this.getDashboardStats,
    required this.getRecentRfqs,
  }) : super(FactoryDashboardInitial());

  Future<void> loadDashboard() async {
    emit(FactoryDashboardLoading());

    // Run both queries in parallel
    final statsFuture = getDashboardStats();
    final rfqsFuture = getRecentRfqs(limit: 5);

    final results = await Future.wait([statsFuture, rfqsFuture]);
    final statsResult =
        results[0] as dynamic; // Either<Failure, Map<String, int>>
    final rfqsResult =
        results[1] as dynamic; // Either<Failure, List<RfqRequest>>

    statsResult.fold(
      (failure) => emit(FactoryDashboardError(failure.message)),
      (stats) {
        rfqsResult.fold(
          (failure) => emit(FactoryDashboardError(failure.message)),
          (rfqs) =>
              emit(FactoryDashboardLoaded(stats: stats, recentRfqs: rfqs)),
        );
      },
    );
  }
}
