import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/rfq_quote.dart';
import '../repositories/quote_repository.dart';

class GetAcceptedQuotesUseCase {
  final QuoteRepository repository;
  GetAcceptedQuotesUseCase(this.repository);

  Future<Either<Failure, List<RfqQuote>>> call() {
    return repository.getAcceptedQuotes();
  }
}
