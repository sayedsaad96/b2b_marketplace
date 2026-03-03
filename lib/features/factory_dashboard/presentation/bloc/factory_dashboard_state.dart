import 'package:equatable/equatable.dart';
import '../../../brand/domain/entities/rfq_request.dart';

sealed class FactoryDashboardState extends Equatable {
  const FactoryDashboardState();

  @override
  List<Object?> get props => [];
}

class FactoryDashboardInitial extends FactoryDashboardState {}

class FactoryDashboardLoading extends FactoryDashboardState {}

class FactoryDashboardLoaded extends FactoryDashboardState {
  final Map<String, int> stats;
  final List<RfqRequest> recentRfqs;

  const FactoryDashboardLoaded({required this.stats, required this.recentRfqs});

  @override
  List<Object?> get props => [stats, recentRfqs];
}

class FactoryDashboardError extends FactoryDashboardState {
  final String message;

  const FactoryDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
