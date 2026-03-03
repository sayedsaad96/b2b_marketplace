import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : null,
            bottomLeft: !isMe ? const Radius.circular(0) : null,
          ),
          border: isMe ? null : Border.all(color: AppColors.divider),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (message.messageText.isNotEmpty)
              Text(
                message.messageText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isMe ? Colors.white : AppColors.textPrimary,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat.jm().format(message.createdAt.toLocal()),
              style: AppTextStyles.caption.copyWith(
                color: isMe ? Colors.white70 : AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
