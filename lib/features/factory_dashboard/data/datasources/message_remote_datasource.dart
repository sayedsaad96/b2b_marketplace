import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<MessageModel> sendMessage(Map<String, dynamic> data);
  Future<List<MessageModel>> getMessages(String rfqId);
  Stream<List<MessageModel>> streamMessages(String rfqId);
  Future<String> uploadChatImage(XFile image, String rfqId);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final SupabaseClient _client;
  MessageRemoteDataSourceImpl(this._client);

  @override
  Future<MessageModel> sendMessage(Map<String, dynamic> data) async {
    data['sender_id'] = _client.auth.currentUser!.id;
    final response = await _client
        .from('messages')
        .insert(data)
        .select()
        .single();
    return MessageModel.fromJson(response);
  }

  @override
  Future<List<MessageModel>> getMessages(String rfqId) async {
    final response = await _client
        .from('messages')
        .select()
        .eq('rfq_id', rfqId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((json) => MessageModel.fromJson(json))
        .toList();
  }

  @override
  Stream<List<MessageModel>> streamMessages(String rfqId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('rfq_id', rfqId)
        .order('created_at', ascending: true)
        .map(
          (data) => data.map((json) => MessageModel.fromJson(json)).toList(),
        );
  }

  @override
  Future<String> uploadChatImage(XFile image, String rfqId) async {
    final uuid = const Uuid().v4();
    final fileExtension = image.path.split('.').last;
    final path = '$rfqId/$uuid.$fileExtension';
    final bytes = await image.readAsBytes();

    await _client.storage
        .from('chat-images')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('chat-images').getPublicUrl(path);
  }
}
