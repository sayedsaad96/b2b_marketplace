import '../../domain/entities/user_profile.dart';

/// Data model for [UserProfile] with JSON serialization.
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.role,
    required super.createdAt,
  });

  /// Creates a [UserProfileModel] from a Supabase `profiles` row.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts this model to a JSON map for Supabase insert.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
