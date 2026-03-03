import 'package:equatable/equatable.dart';

/// Notification entity (maps to `notifications` table).
class AppNotification extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final String? resourceType;
  final String? resourceId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.resourceType,
    this.resourceId,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    title,
    body,
    resourceType,
    resourceId,
    isRead,
    createdAt,
  ];
}
