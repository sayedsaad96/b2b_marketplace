import 'package:equatable/equatable.dart';

sealed class AdminDashboardState extends Equatable {
  const AdminDashboardState();
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminDashboardState {}

class AdminLoading extends AdminDashboardState {}

/// Users tab state
class AdminUsersLoaded extends AdminDashboardState {
  final List<Map<String, dynamic>> users;
  final int totalCount;
  final int currentPage;
  final String? roleFilter;
  final String? searchQuery;

  const AdminUsersLoaded({
    required this.users,
    required this.totalCount,
    this.currentPage = 0,
    this.roleFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
    users,
    totalCount,
    currentPage,
    roleFilter,
    searchQuery,
  ];
}

/// RFQs tab state
class AdminRfqsLoaded extends AdminDashboardState {
  final List<Map<String, dynamic>> rfqs;
  final int currentPage;

  const AdminRfqsLoaded({required this.rfqs, this.currentPage = 0});

  @override
  List<Object?> get props => [rfqs, currentPage];
}

/// Revenue tab state
class AdminRevenueLoaded extends AdminDashboardState {
  final int totalAccepted;
  final double totalRevenue;

  const AdminRevenueLoaded({
    required this.totalAccepted,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [totalAccepted, totalRevenue];
}

/// Verification tab state
class AdminVerificationLoaded extends AdminDashboardState {
  final List<Map<String, dynamic>> unverifiedFactories;

  const AdminVerificationLoaded({required this.unverifiedFactories});

  @override
  List<Object?> get props => [unverifiedFactories];
}

class AdminError extends AdminDashboardState {
  final String message;
  const AdminError(this.message);
  @override
  List<Object?> get props => [message];
}
