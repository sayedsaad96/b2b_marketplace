import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_quote_usecase.dart';
import 'submit_quote_state.dart';

class SubmitQuoteCubit extends Cubit<SubmitQuoteState> {
  final SubmitQuoteUseCase submitQuoteUseCase;

  SubmitQuoteCubit({required this.submitQuoteUseCase})
    : super(SubmitQuoteInitial());

  Future<void> submitQuote({
    required String rfqId,
    required double price,
    required int leadTime,
    String? notes,
  }) async {
    emit(SubmitQuoteSubmitting());

    final result = await submitQuoteUseCase(
      rfqId: rfqId,
      price: price,
      leadTime: leadTime,
      notes: notes,
    );

    result.fold(
      (failure) => emit(SubmitQuoteError(failure.message)),
      (quote) => emit(SubmitQuoteSuccess(quote)),
    );
  }
}
