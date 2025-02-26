// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object?> get props => [];
}

class ChatsInitialized extends ChatsEvent{
  const ChatsInitialized();
}
class ChatsStarted extends ChatsEvent {
  final List<String> questionList;
  const ChatsStarted({required this.questionList});
}

class ChatsQuestioned extends ChatsEvent {
  const ChatsQuestioned();
}

class ChatsPaused extends ChatsEvent {
  const ChatsPaused();
}

class ChatsResumed extends ChatsEvent {
  const ChatsResumed();
}

class ChatsListened extends ChatsEvent {
  const ChatsListened();

}

class ChatsEnded extends ChatsEvent {
  const ChatsEnded();
}

class ChatsFinished extends ChatsEvent {
  const ChatsFinished();
}
