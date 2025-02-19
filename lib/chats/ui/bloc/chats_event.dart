// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object?> get props => [];
}

class ChatsStarted extends ChatsEvent {
  final List<String> questionList;
  const ChatsStarted({required this.questionList});
}

class ChatQuestioned extends ChatsEvent {
  const ChatQuestioned();
}

class ChatBeeped extends ChatsEvent {
  const ChatBeeped();
}

class ChatListened extends ChatsEvent {
  // final String recognizedText;
  // const ChatListened(this.recognizedText); 
  const ChatListened();

  // @override
  // List<Object?> get props => [recognizedText];
}

class ChatFinished extends ChatsEvent {
  const ChatFinished();
}
