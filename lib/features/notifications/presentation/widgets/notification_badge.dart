import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_cubit.dart';
import '../bloc/notification_state.dart';

/// AppBar notification icon with unread badge.
class NotificationBadge extends StatelessWidget {
  final VoidCallback? onTap;

  const NotificationBadge({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final count = state is NotificationLoaded ? state.unreadCount : 0;

        return IconButton(
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count', style: const TextStyle(fontSize: 10)),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: onTap,
        );
      },
    );
  }
}
