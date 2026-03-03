import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

class GetMessagesUseCase {
  final MessageRepository repository;
  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<Message>>> call(String rfqId) {
    return repository.getMessages(rfqId);
  }
}
