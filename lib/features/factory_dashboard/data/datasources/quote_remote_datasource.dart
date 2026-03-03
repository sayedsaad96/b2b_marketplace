import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rfq_quote_model.dart';

abstract class QuoteRemoteDataSource {
  Future<RfqQuoteModel> submitQuote(Map<String, dynamic> data);
  Future<List<RfqQuoteModel>> getQuotesForFactory();
  Future<List<RfqQuoteModel>> getAcceptedQuotes();
  Future<RfqQuoteModel?> getQuoteForRfq(String rfqId);
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final SupabaseClient _client;
  QuoteRemoteDataSourceImpl(this._client);

  @override
  Future<RfqQuoteModel> submitQuote(Map<String, dynamic> data) async {
    data['factory_id'] = _client.auth.currentUser!.id;
    final response = await _client
        .from('rfq_quotes')
        .insert(data)
        .select()
        .single();
    return RfqQuoteModel.fromJson(response);
  }

  @override
  Future<List<RfqQuoteModel>> getQuotesForFactory() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('rfq_quotes')
        .select()
        .eq('factory_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => RfqQuoteModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RfqQuoteModel>> getAcceptedQuotes() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('rfq_quotes')
        .select()
        .eq('factory_id', userId)
        .eq('status', 'accepted')
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => RfqQuoteModel.fromJson(json))
        .toList();
  }

  @override
  Future<RfqQuoteModel?> getQuoteForRfq(String rfqId) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('rfq_quotes')
        .select()
        .eq('factory_id', userId)
        .eq('rfq_id', rfqId)
        .maybeSingle();
    if (response == null) return null;
    return RfqQuoteModel.fromJson(response);
  }
}
