import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import 'admin_dashboard_state.dart';

/// Cubit managing all Admin Dashboard sections.
class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminRemoteDataSource _dataSource;

  AdminDashboardCubit({required AdminRemoteDataSource dataSource})
    : _dataSource = dataSource,
      super(AdminInitial());

  // ── Users ──

  Future<void> loadUsers({
    int page = 0,
    String? search,
    String? roleFilter,
  }) async {
    emit(AdminLoading());
    try {
      final users = await _dataSource.getAllUsers(
        page: page,
        search: search,
        roleFilter: roleFilter,
      );
      final count = await _dataSource.getUserCount(roleFilter: roleFilter);
      emit(
        AdminUsersLoaded(
          users: users,
          totalCount: count,
          currentPage: page,
          roleFilter: roleFilter,
          searchQuery: search,
        ),
      );
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // ── RFQs ──

  Future<void> loadRfqs({int page = 0}) async {
    emit(AdminLoading());
    try {
      final rfqs = await _dataSource.getAllRfqs(page: page);
      emit(AdminRfqsLoaded(rfqs: rfqs, currentPage: page));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // ── Revenue ──

  Future<void> loadRevenue() async {
    emit(AdminLoading());
    try {
      final stats = await _dataSource.getRevenueStats();
      emit(
        AdminRevenueLoaded(
          totalAccepted: stats['total_accepted'] as int,
          totalRevenue: stats['total_revenue'] as double,
        ),
      );
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // ── Verification ──

  Future<void> loadVerificationQueue() async {
    emit(AdminLoading());
    try {
      final factories = await _dataSource.getUnverifiedFactories();
      emit(AdminVerificationLoaded(unverifiedFactories: factories));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> verifyFactory(
    String factoryId, {
    bool approved = true,
    String? reason,
  }) async {
    try {
      await _dataSource.verifyFactory(
        factoryId: factoryId,
        approved: approved,
        reason: reason,
      );
      await loadVerificationQueue();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> suspendUser(String userId, String reason) async {
    try {
      await _dataSource.suspendUser(userId, reason);
      await loadUsers();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
