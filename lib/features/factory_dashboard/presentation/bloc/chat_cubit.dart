import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/repositories/message_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MessageRepository repository;

  StreamSubscription<List<Message>>? _messagesSubscription;

  ChatCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.repository,
  }) : super(ChatInitial());

  Future<void> loadMessages(String rfqId) async {
    emit(ChatLoading());

    // 1. Fetch initial message history
    final result = await getMessagesUseCase(rfqId);

    result.fold((failure) => emit(ChatError(failure.message)), (messages) {
      emit(ChatLoaded(messages: messages));
      // 2. Subscribe to real-time updates
      _subscribeToMessages(rfqId);
    });
  }

  void _subscribeToMessages(String rfqId) {
    _messagesSubscription?.cancel();
    _messagesSubscription = repository
        .streamMessages(rfqId)
        .listen(
          (streamedMessages) {
            // If we are currently loaded, replace the list with the fresh stream
            if (state is ChatLoaded) {
              emit((state as ChatLoaded).copyWith(messages: streamedMessages));
            } else {
              emit(ChatLoaded(messages: streamedMessages));
            }
          },
          onError: (error) {
            // We might not want to emit an error state here if they already have messages,
            // but for simplicity we will handle it.
            // print('Realtime chat error: $error');
          },
        );
  }

  Future<void> sendMessage({
    required String rfqId,
    required String text,
    XFile? image,
  }) async {
    if (state is! ChatLoaded) return;
    final currentState = state as ChatLoaded;

    emit(currentState.copyWith(isSending: true));

    String? imageUrl;
    if (image != null) {
      final uploadResult = await repository.uploadChatImage(image, rfqId);
      uploadResult.fold((failure) {
        emit(ChatError('Failed to upload image: ${failure.message}'));
        emit(currentState); // Revert to previous loaded state
      }, (url) => imageUrl = url);
      if (imageUrl == null) return; // Upload failed, already emitted error
    }

    final result = await sendMessageUseCase(
      rfqId: rfqId,
      messageText: text,
      imageUrl: imageUrl,
    );

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
        emit(currentState.copyWith(isSending: false));
      },
      (message) {
        // We don't strictly need to append the message manually because the Realtime
        // stream will catch the INSERT and emit a new state automatically, but we
        // can set isSending back to false.
        emit(currentState.copyWith(isSending: false));
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
