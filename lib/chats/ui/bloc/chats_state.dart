part of 'chats_bloc.dart';

enum ChatsStatus {
  initial(true),
  started(false),
  questioning(false),
  pausing(true),
  resuming(false),
  listening(false),
  ending(false),
  finished(true),
  failure(true);

  final bool state;
  const ChatsStatus(this.state);
}

@immutable
final class ChatsState extends Equatable {
  final ChatsStatus status;
  final List<String> pendingQuestions;
  final String currentQuestion;
  final List<String> chatContent;

  const ChatsState.initial()
    : this(
        status: ChatsStatus.initial,
        pendingQuestions: const [],
        chatContent: const [],
        currentQuestion: '',
      );

  const ChatsState({
    required this.status,
    this.chatContent = const [],
    this.pendingQuestions = const [],
    this.currentQuestion = '',
  });

  ChatsState copyWith({
    ChatsStatus? status,
    List<String>? pendingQuestions,
    String? currentQuestion,
    List<String>? chatContent,
  }) {
    return ChatsState(
      status: status ?? this.status,
      pendingQuestions: pendingQuestions ?? this.pendingQuestions,
      chatContent: chatContent ?? this.chatContent,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }

  @override
  List<Object?> get props => [
    status,
    chatContent,
    pendingQuestions,
    currentQuestion,
  ];
}
