import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/rfq_request.dart';
import '../repositories/rfq_repository.dart';

class GetMyRfqsUseCase {
  final RfqRepository _repository;

  const GetMyRfqsUseCase(this._repository);

  Future<Either<Failure, List<RfqRequest>>> call() {
    return _repository.getMyRfqs();
  }
}
