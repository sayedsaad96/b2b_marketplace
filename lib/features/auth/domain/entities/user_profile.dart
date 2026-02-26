import 'package:equatable/equatable.dart';

/// Pure domain entity representing a user profile.
class UserProfile extends Equatable {
  /// Unique user identifier (UUID from Supabase auth).
  final String id;

  /// User's display name.
  final String fullName;

  /// User role: 'brand', 'factory', or 'admin'.
  final String role;

  /// Account creation timestamp.
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, fullName, role, createdAt];
}
