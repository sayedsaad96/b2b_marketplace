import 'package:equatable/equatable.dart';
import '../../domain/entities/app_notification.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final int unreadCount;
  final List<AppNotification> notifications;

  const NotificationLoaded({
    required this.unreadCount,
    required this.notifications,
  });

  @override
  List<Object?> get props => [unreadCount, notifications];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
