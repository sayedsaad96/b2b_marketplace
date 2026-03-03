import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/rfq_quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_datasource.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource dataSource;
  QuoteRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, RfqQuote>> submitQuote({
    required String rfqId,
    required double price,
    required int leadTime,
    String? notes,
  }) async {
    try {
      final result = await dataSource.submitQuote({
        'rfq_id': rfqId,
        'price': price,
        'lead_time': leadTime,
        'notes': notes,
      });
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RfqQuote>>> getQuotesForFactory() async {
    try {
      final result = await dataSource.getQuotesForFactory();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RfqQuote>>> getAcceptedQuotes() async {
    try {
      final result = await dataSource.getAcceptedQuotes();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RfqQuote?>> getQuoteForRfq(String rfqId) async {
    try {
      final result = await dataSource.getQuoteForRfq(rfqId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
