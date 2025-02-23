part of 'chats_bloc.dart';

enum ChatsStatus {
  initial,
  started,
  questioning,
  pausing,
  resuming,
  // beeping,
  listening,
  finished,
  failure,
}

final class ChatsState extends Equatable {
  final ChatsStatus status;
  final List<String> questions; // Store all questions
  final int currentQuestionIndex; // Track current question index
  final List<String> recognizedText;

  const ChatsState.initial()
    : this(
        status: ChatsStatus.initial,
        questions: const [],
        currentQuestionIndex: 0,
      );

  const ChatsState({
    required this.status,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.recognizedText = const [],
  });

  ChatsState copyWith({
    ChatsStatus? status,
    List<String>? questions,
    int? currentQuestionIndex,
    List<String>? recognizedText,
  }) {
    return ChatsState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      recognizedText: recognizedText ?? this.recognizedText,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentQuestionIndex,
    recognizedText,
  ];
}
