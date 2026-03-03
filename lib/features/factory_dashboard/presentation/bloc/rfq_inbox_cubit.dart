import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_factory_rfqs_usecase.dart';
import '../../domain/repositories/quote_repository.dart';
import 'rfq_inbox_state.dart';

class RfqInboxCubit extends Cubit<RfqInboxState> {
  final GetFactoryRfqsUseCase getFactoryRfqs;
  final QuoteRepository
  quoteRepository; // injecting repo directly, but we could make a GetQuotesUseCase

  RfqInboxCubit({required this.getFactoryRfqs, required this.quoteRepository})
    : super(RfqInboxInitial());

  Future<void> loadInbox() async {
    emit(RfqInboxLoading());

    final rfqsResult = await getFactoryRfqs();
    final quotesResult = await quoteRepository.getQuotesForFactory();

    rfqsResult.fold((failure) => emit(RfqInboxError(failure.message)), (rfqs) {
      quotesResult.fold(
        (failure) => emit(RfqInboxError(failure.message)),
        (quotes) => emit(RfqInboxLoaded(rfqs: rfqs, myQuotes: quotes)),
      );
    });
  }

  Future<void> refreshInbox() async {
    // Keeps existing state visible while loading if possible
    await loadInbox();
  }
}
