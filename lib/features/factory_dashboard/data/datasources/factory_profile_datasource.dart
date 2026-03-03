import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../brand/data/models/factory_model.dart';

abstract class FactoryProfileDataSource {
  Future<FactoryModel> getMyProfile();
  Future<FactoryModel> updateProfile(Map<String, dynamic> data);
  Future<List<String>> uploadPhotos(List<XFile> images, String factoryId);
  Future<void> deletePhoto(String photoUrl);
}

class FactoryProfileDataSourceImpl implements FactoryProfileDataSource {
  final SupabaseClient _client;
  FactoryProfileDataSourceImpl(this._client);

  @override
  Future<FactoryModel> getMyProfile() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('factories')
        .select()
        .eq('owner_id', userId)
        .single();
    return FactoryModel.fromJson(response);
  }

  @override
  Future<FactoryModel> updateProfile(Map<String, dynamic> data) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('factories')
        .update(data)
        .eq('owner_id', userId)
        .select()
        .single();
    return FactoryModel.fromJson(response);
  }

  @override
  Future<List<String>> uploadPhotos(
    List<XFile> images,
    String factoryId,
  ) async {
    final urls = <String>[];
    for (final image in images) {
      final uuid = const Uuid().v4();
      final fileExtension = image.path.split('.').last;
      final path = '$factoryId/$uuid.$fileExtension';
      final bytes = await image.readAsBytes();

      await _client.storage
          .from('factory-photos')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final url = _client.storage.from('factory-photos').getPublicUrl(path);
      urls.add(url);
    }
    return urls;
  }

  @override
  Future<void> deletePhoto(String photoUrl) async {
    final uri = Uri.parse(photoUrl);
    final pathSegments = uri.pathSegments;
    // Extract storage path after 'factory-photos/'
    final bucketIndex = pathSegments.indexOf('factory-photos');
    if (bucketIndex >= 0 && bucketIndex < pathSegments.length - 1) {
      final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');
      await _client.storage.from('factory-photos').remove([storagePath]);
    }
  }
}
