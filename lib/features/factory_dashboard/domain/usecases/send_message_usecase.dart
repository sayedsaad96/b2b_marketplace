import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;
  SendMessageUseCase(this.repository);

  Future<Either<Failure, Message>> call({
    required String rfqId,
    required String messageText,
    String? imageUrl,
  }) {
    return repository.sendMessage(
      rfqId: rfqId,
      messageText: messageText,
      imageUrl: imageUrl,
    );
  }
}
