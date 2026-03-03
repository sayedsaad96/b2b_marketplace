import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/rfq_request_model.dart';

abstract class RfqRemoteDataSource {
  Future<RfqRequestModel> submitRfq({
    required String title,
    required String description,
    required int quantity,
    String? factoryId,
    List<String> photoUrls = const [],
  });

  Future<List<RfqRequestModel>> getMyRfqs();

  Future<List<String>> uploadPhotos(List<XFile> images);
}

class RfqRemoteDataSourceImpl implements RfqRemoteDataSource {
  final SupabaseClient _client;
  final Uuid _uuid = const Uuid();

  const RfqRemoteDataSourceImpl(this._client);

  @override
  Future<RfqRequestModel> submitRfq({
    required String title,
    required String description,
    required int quantity,
    String? factoryId,
    List<String> photoUrls = const [],
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not authenticated');
    }

    final now = DateTime.now().toUtc();
    final rfqId = _uuid.v4();

    final data = {
      'id': rfqId,
      'brand_id': user.id,
      'factory_id': ?factoryId,
      'title': title,
      'description': description,
      'quantity': quantity,
      'photo_urls': photoUrls,
      'created_at': now.toIso8601String(),
    };

    await _client.from('rfq_requests').insert(data);

    return RfqRequestModel(
      id: rfqId,
      brandId: user.id,
      factoryId: factoryId,
      title: title,
      description: description,
      quantity: quantity,
      photoUrls: photoUrls,
      createdAt: now,
    );
  }

  @override
  Future<List<RfqRequestModel>> getMyRfqs() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not authenticated');
    }

    final response = await _client
        .from('rfq_requests')
        .select()
        .eq('brand_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).map((e) => RfqRequestModel.fromJson(e)).toList();
  }

  @override
  Future<List<String>> uploadPhotos(List<XFile> images) async {
    if (images.isEmpty) return [];

    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not authenticated');
    }

    final List<String> uploadedUrls = [];

    for (final image in images) {
      final fileExtension = image.path.split('.').last;
      final fileName =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4()}.$fileExtension';

      final file = File(image.path);

      await _client.storage.from('rfq-photos').upload(fileName, file);

      final publicUrl = _client.storage
          .from('rfq-photos')
          .getPublicUrl(fileName);
      uploadedUrls.add(publicUrl);
    }

    return uploadedUrls;
  }
}
