import 'package:equatable/equatable.dart';
import '../../../brand/domain/entities/rfq_request.dart';
import '../../domain/entities/rfq_quote.dart';

sealed class RfqInboxState extends Equatable {
  const RfqInboxState();

  @override
  List<Object?> get props => [];
}

class RfqInboxInitial extends RfqInboxState {}

class RfqInboxLoading extends RfqInboxState {}

class RfqInboxLoaded extends RfqInboxState {
  final List<RfqRequest> rfqs;
  final List<RfqQuote> myQuotes;

  const RfqInboxLoaded({required this.rfqs, required this.myQuotes});

  @override
  List<Object?> get props => [rfqs, myQuotes];
}

class RfqInboxError extends RfqInboxState {
  final String message;

  const RfqInboxError(this.message);

  @override
  List<Object?> get props => [message];
}
