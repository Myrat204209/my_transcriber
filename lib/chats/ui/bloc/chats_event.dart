part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object?> get props => [];
}

class ChatsStarted extends ChatsEvent {
  const ChatsStarted();
}

class ChatQuestioned extends ChatsEvent {
  final String line;
  const ChatQuestioned(this.line);

  @override
  List<Object?> get props => [line];
}

class ChatBeeped extends ChatsEvent {}

class ChatListened extends ChatsEvent {
  final String recognizedText;
  const ChatListened(this.recognizedText);

  @override
  List<Object?> get props => [recognizedText];
}

class ChatFinished extends ChatsEvent {
  const ChatFinished();
}
