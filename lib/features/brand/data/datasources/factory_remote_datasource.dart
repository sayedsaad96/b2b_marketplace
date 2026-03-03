import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/factory_model.dart';

abstract class FactoryRemoteDataSource {
  Future<List<FactoryModel>> getFactories({
    int page = 0,
    int pageSize = 20,
    String? location,
    int? maxMoq,
    double? minRating,
    String? specialization,
    String? searchQuery,
  });

  Future<FactoryModel> getFactoryById(String id);

  Future<List<FactoryModel>> getTopFactories({int limit = 10});
}

class FactoryRemoteDataSourceImpl implements FactoryRemoteDataSource {
  final SupabaseClient _client;

  const FactoryRemoteDataSourceImpl(this._client);

  @override
  Future<List<FactoryModel>> getFactories({
    int page = 0,
    int pageSize = 20,
    String? location,
    int? maxMoq,
    double? minRating,
    String? specialization,
    String? searchQuery,
  }) async {
    var query = _client.from('factories').select();

    if (location != null && location.isNotEmpty) {
      query = query.ilike('location', '%$location%');
    }
    if (maxMoq != null) {
      query = query.lte('moq', maxMoq);
    }
    if (minRating != null) {
      query = query.gte('rating', minRating);
    }
    if (specialization != null && specialization.isNotEmpty) {
      query = query.contains('specialization', [specialization]);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final fromOption = page * pageSize;
    final toOption = fromOption + pageSize - 1;

    final response = await query
        .order('rating', ascending: false)
        .range(fromOption, toOption);

    return (response as List).map((e) => FactoryModel.fromJson(e)).toList();
  }

  @override
  Future<FactoryModel> getFactoryById(String id) async {
    final response = await _client
        .from('factories')
        .select()
        .eq('id', id)
        .single();
    return FactoryModel.fromJson(response);
  }

  @override
  Future<List<FactoryModel>> getTopFactories({int limit = 10}) async {
    final response = await _client
        .from('factories')
        .select()
        .order('rating', ascending: false)
        .limit(limit);

    return (response as List).map((e) => FactoryModel.fromJson(e)).toList();
  }
}
