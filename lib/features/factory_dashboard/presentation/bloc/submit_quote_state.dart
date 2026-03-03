import 'package:equatable/equatable.dart';
import '../../domain/entities/rfq_quote.dart';

sealed class SubmitQuoteState extends Equatable {
  const SubmitQuoteState();

  @override
  List<Object?> get props => [];
}

class SubmitQuoteInitial extends SubmitQuoteState {}

class SubmitQuoteSubmitting extends SubmitQuoteState {}

class SubmitQuoteSuccess extends SubmitQuoteState {
  final RfqQuote quote;

  const SubmitQuoteSuccess(this.quote);

  @override
  List<Object?> get props => [quote];
}

class SubmitQuoteError extends SubmitQuoteState {
  final String message;

  const SubmitQuoteError(this.message);

  @override
  List<Object?> get props => [message];
}
