import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String rfqId;
  final String senderId;
  final String messageText;
  final String? imageUrl;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.rfqId,
    required this.senderId,
    required this.messageText,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    rfqId,
    senderId,
    messageText,
    imageUrl,
    createdAt,
  ];
}
