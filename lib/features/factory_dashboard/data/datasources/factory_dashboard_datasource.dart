import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../brand/data/models/rfq_request_model.dart';

abstract class FactoryDashboardDataSource {
  Future<Map<String, int>> getDashboardStats();
  Future<List<RfqRequestModel>> getRecentRfqs(int limit);
  Future<List<RfqRequestModel>> getAllRfqsForFactory();
}

class FactoryDashboardDataSourceImpl implements FactoryDashboardDataSource {
  final SupabaseClient _client;
  FactoryDashboardDataSourceImpl(this._client);

  @override
  Future<Map<String, int>> getDashboardStats() async {
    final userId = _client.auth.currentUser!.id;

    // Count new (un-quoted) RFQs targeted at this factory
    final allRfqs = await _client
        .from('rfq_requests')
        .select('id')
        .eq('factory_id', userId);
    final totalRfqs = (allRfqs as List).length;

    // Count accepted quotes
    final acceptedQuotes = await _client
        .from('rfq_quotes')
        .select('id')
        .eq('factory_id', userId)
        .eq('status', 'accepted');
    final acceptedCount = (acceptedQuotes as List).length;

    // Count submitted quotes (to compute "new" = total - quoted)
    final submittedQuotes = await _client
        .from('rfq_quotes')
        .select('rfq_id')
        .eq('factory_id', userId);
    final quotedRfqIds = (submittedQuotes as List)
        .map((q) => q['rfq_id'])
        .toSet();
    final newRfqs = totalRfqs - quotedRfqIds.length;

    return {
      'newRfqs': newRfqs < 0 ? 0 : newRfqs,
      'profileViews': 0, // Placeholder for future analytics
      'acceptedQuotes': acceptedCount,
    };
  }

  @override
  Future<List<RfqRequestModel>> getRecentRfqs(int limit) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('rfq_requests')
        .select()
        .eq('factory_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return (response as List)
        .map((json) => RfqRequestModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RfqRequestModel>> getAllRfqsForFactory() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('rfq_requests')
        .select()
        .eq('factory_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => RfqRequestModel.fromJson(json))
        .toList();
  }
}
