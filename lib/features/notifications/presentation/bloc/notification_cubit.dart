import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import 'notification_state.dart';

/// Manages notification state: loading, unread count, mark as read.
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRemoteDataSource _dataSource;
  final SupabaseClient _supabase;

  NotificationCubit({
    required NotificationRemoteDataSource dataSource,
    required SupabaseClient supabase,
  }) : _dataSource = dataSource,
       _supabase = supabase,
       super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(const NotificationError('Not authenticated'));
        return;
      }

      final notifications = await _dataSource.getNotifications(userId: userId);
      final unreadCount = await _dataSource.getUnreadCount(userId);

      emit(
        NotificationLoaded(
          unreadCount: unreadCount,
          notifications: notifications,
        ),
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _dataSource.markAsRead(notificationId);
      await loadNotifications();
    } catch (_) {
      // Silently fail — UI will refresh on next load
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;
      await _dataSource.markAllAsRead(userId);
      await loadNotifications();
    } catch (_) {}
  }
}
