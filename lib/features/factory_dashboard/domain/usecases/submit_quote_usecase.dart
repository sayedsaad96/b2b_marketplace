import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/rfq_quote.dart';
import '../repositories/quote_repository.dart';

class SubmitQuoteUseCase {
  final QuoteRepository repository;
  SubmitQuoteUseCase(this.repository);

  Future<Either<Failure, RfqQuote>> call({
    required String rfqId,
    required double price,
    required int leadTime,
    String? notes,
  }) {
    return repository.submitQuote(
      rfqId: rfqId,
      price: price,
      leadTime: leadTime,
      notes: notes,
    );
  }
}
