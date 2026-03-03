import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for admin-only queries.
class AdminRemoteDataSource {
  final SupabaseClient _client;

  AdminRemoteDataSource(this._client);

  /// Get all users with pagination, search, and role filter.
  Future<List<Map<String, dynamic>>> getAllUsers({
    int page = 0,
    int pageSize = 20,
    String? search,
    String? roleFilter,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    var query = _client.from('profiles').select();

    if (roleFilter != null && roleFilter.isNotEmpty) {
      query = query.eq('role', roleFilter);
    }
    if (search != null && search.isNotEmpty) {
      query = query.ilike('full_name', '%$search%');
    }

    final data = await query
        .order('created_at', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get total user count (for pagination).
  Future<int> getUserCount({String? roleFilter}) async {
    var query = _client.from('profiles').select();
    if (roleFilter != null && roleFilter.isNotEmpty) {
      query = query.eq('role', roleFilter);
    }
    final data = await query;
    return (data as List).length;
  }

  /// Get all RFQs with pagination.
  Future<List<Map<String, dynamic>>> getAllRfqs({
    int page = 0,
    int pageSize = 20,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final data = await _client
        .from('rfq_requests')
        .select('*, profiles!rfq_requests_brand_id_fkey(full_name)')
        .order('created_at', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get all quotes with pagination.
  Future<List<Map<String, dynamic>>> getAllQuotes({
    int page = 0,
    int pageSize = 20,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final data = await _client
        .from('rfq_quotes')
        .select(
          '*, rfq_requests(title), profiles!rfq_quotes_factory_id_fkey(full_name)',
        )
        .order('created_at', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get revenue stats: total accepted quotes + estimated revenue.
  Future<Map<String, dynamic>> getRevenueStats() async {
    final data = await _client
        .from('rfq_quotes')
        .select('price, status')
        .eq('status', 'accepted');

    final quotes = List<Map<String, dynamic>>.from(data);
    final totalAccepted = quotes.length;
    final totalRevenue = quotes.fold<double>(
      0,
      (sum, q) => sum + (double.tryParse(q['price'].toString()) ?? 0),
    );

    return {'total_accepted': totalAccepted, 'total_revenue': totalRevenue};
  }

  /// Verify or reject a factory.
  Future<void> verifyFactory({
    required String factoryId,
    required bool approved,
    String? reason,
  }) async {
    // Update factory verification status
    await _client
        .from('factories')
        .update({'is_verified': approved})
        .eq('id', factoryId);

    // Log admin action
    await _client.from('admin_actions').insert({
      'admin_id': _client.auth.currentUser!.id,
      'action_type': approved ? 'verify_factory' : 'reject_factory',
      'target_user_id': factoryId,
      'target_entity_type': 'factory',
      'target_entity_id': factoryId,
      'reason': reason,
    });
  }

  /// Get unverified factories.
  Future<List<Map<String, dynamic>>> getUnverifiedFactories() async {
    final data = await _client
        .from('factories')
        .select('*, profiles!factories_user_id_fkey(full_name, email)')
        .eq('is_verified', false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Suspend a user.
  Future<void> suspendUser(String userId, String reason) async {
    await _client
        .from('profiles')
        .update({'suspended_at': DateTime.now().toIso8601String()})
        .eq('id', userId);

    await _client.from('admin_actions').insert({
      'admin_id': _client.auth.currentUser!.id,
      'action_type': 'suspend_user',
      'target_user_id': userId,
      'reason': reason,
    });
  }
}
