import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource dataSource;
  MessageRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String rfqId,
    required String messageText,
    String? imageUrl,
  }) async {
    try {
      final result = await dataSource.sendMessage({
        'rfq_id': rfqId,
        'message_text': messageText,
        'image_url': imageUrl,
      });
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String rfqId) async {
    try {
      final result = await dataSource.getMessages(rfqId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Message>> streamMessages(String rfqId) {
    return dataSource.streamMessages(rfqId);
  }

  @override
  Future<Either<Failure, String>> uploadChatImage(
    XFile image,
    String rfqId,
  ) async {
    try {
      final url = await dataSource.uploadChatImage(image, rfqId);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
