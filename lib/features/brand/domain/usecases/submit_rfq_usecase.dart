import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/rfq_request.dart';
import '../repositories/rfq_repository.dart';

class SubmitRfqUseCase {
  final RfqRepository _repository;

  const SubmitRfqUseCase(this._repository);

  Future<Either<Failure, RfqRequest>> call({
    required String title,
    required String description,
    required int quantity,
    String? factoryId,
    List<String> photoUrls = const [],
  }) {
    return _repository.submitRfq(
      title: title,
      description: description,
      quantity: quantity,
      factoryId: factoryId,
      photoUrls: photoUrls,
    );
  }
}
