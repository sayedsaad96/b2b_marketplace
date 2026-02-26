import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile_model.dart';

/// Abstract contract for authentication remote operations.
abstract class AuthRemoteDataSource {
  /// Signs up a new user and creates their profile row.
  Future<UserProfileModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });

  /// Signs in with email and password, then fetches profile.
  Future<UserProfileModel> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<void> signOut();

  /// Fetches the profile of the currently authenticated user.
  Future<UserProfileModel> getCurrentUserProfile();

  /// Returns the current Supabase auth session, or null.
  Session? get currentSession;
}

/// Supabase implementation of [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  const AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserProfileModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Sign-up failed. Please try again.');
    }

    final now = DateTime.now().toUtc();
    final profileData = {
      'id': user.id,
      'full_name': fullName,
      'role': role,
      'created_at': now.toIso8601String(),
    };

    await _client.from('profiles').insert(profileData);

    return UserProfileModel(
      id: user.id,
      fullName: fullName,
      role: role,
      createdAt: now,
    );
  }

  @override
  Future<UserProfileModel> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);

    return getCurrentUserProfile();
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserProfileModel> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found.');
    }

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserProfileModel.fromJson(response);
  }

  @override
  Session? get currentSession => _client.auth.currentSession;
}
