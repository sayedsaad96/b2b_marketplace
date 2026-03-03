import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, Message>> sendMessage({
    required String rfqId,
    required String messageText,
    String? imageUrl,
  });
  Future<Either<Failure, List<Message>>> getMessages(String rfqId);
  Stream<List<Message>> streamMessages(String rfqId);
  Future<Either<Failure, String>> uploadChatImage(XFile image, String rfqId);
}
