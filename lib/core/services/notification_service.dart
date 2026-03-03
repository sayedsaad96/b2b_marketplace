import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for FCM token management and notification setup.
/// Firebase initialization is handled in main.dart.
class NotificationService {
  final SupabaseClient _supabase;

  NotificationService(this._supabase);

  /// Save the FCM token to the user's profile.
  Future<void> saveToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('profiles')
        .update({'fcm_token': token})
        .eq('id', userId);
  }

  /// Clear the FCM token on logout.
  Future<void> clearToken() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('profiles')
        .update({'fcm_token': null})
        .eq('id', userId);
  }
}
