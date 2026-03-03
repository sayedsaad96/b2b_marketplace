import 'package:equatable/equatable.dart';
import '../../domain/entities/rfq_request.dart';

sealed class RfqState extends Equatable {
  const RfqState();

  @override
  List<Object?> get props => [];
}

class RfqInitial extends RfqState {}

class RfqSubmitting extends RfqState {}

class RfqSubmittedSuccess extends RfqState {
  final RfqRequest rfq;
  const RfqSubmittedSuccess(this.rfq);

  @override
  List<Object?> get props => [rfq];
}

class RfqError extends RfqState {
  final String message;
  const RfqError(this.message);

  @override
  List<Object?> get props => [message];
}

class RfqListLoading extends RfqState {}

class RfqListLoaded extends RfqState {
  final List<RfqRequest> rfqs;
  const RfqListLoaded(this.rfqs);

  @override
  List<Object?> get props => [rfqs];
}

class RfqListError extends RfqState {
  final String message;
  const RfqListError(this.message);

  @override
  List<Object?> get props => [message];
}
