import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.rfqId,
    required super.senderId,
    required super.messageText,
    super.imageUrl,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      rfqId: json['rfq_id'] as String,
      senderId: json['sender_id'] as String,
      messageText: json['message_text'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rfq_id': rfqId,
      'sender_id': senderId,
      'message_text': messageText,
      'image_url': imageUrl,
    };
  }
}
