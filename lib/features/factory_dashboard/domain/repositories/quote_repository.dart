import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/rfq_quote.dart';

abstract class QuoteRepository {
  Future<Either<Failure, RfqQuote>> submitQuote({
    required String rfqId,
    required double price,
    required int leadTime,
    String? notes,
  });
  Future<Either<Failure, List<RfqQuote>>> getQuotesForFactory();
  Future<Either<Failure, List<RfqQuote>>> getAcceptedQuotes();
  Future<Either<Failure, RfqQuote?>> getQuoteForRfq(String rfqId);
}
