part of 'chats_bloc.dart';

enum ChatsStatus {
  initial,
  started,
  questioning,
  pausing,
  beeping,
  listening,
  finished,
  failure,
}

final class ChatsState extends Equatable {
  final ChatsStatus status;
  final List<String> currentQuestion;
  final List<String> recognizedText;

  const ChatsState.initial() : this(status: ChatsStatus.initial);

  const ChatsState({
    required this.status,
    this.currentQuestion = const [],
    this.recognizedText = const [],
  });

  ChatsState copyWith({
    ChatsStatus? status,
    List<String>? currentQuestion,
    List<String>? recognizedText,
    bool? speechEnabled,
  }) {
    return ChatsState(
      status: status ?? this.status,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      recognizedText: recognizedText ?? this.recognizedText,
    );
  }

  @override
  List<Object?> get props => [status, currentQuestion, recognizedText];
}
