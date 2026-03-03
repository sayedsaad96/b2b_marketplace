import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isSending; // Used to show loading indicator on send button

  const ChatLoaded({required this.messages, this.isSending = false});

  @override
  List<Object?> get props => [messages, isSending];

  ChatLoaded copyWith({List<Message>? messages, bool? isSending}) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
