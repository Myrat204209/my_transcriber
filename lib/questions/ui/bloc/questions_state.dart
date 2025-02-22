part of 'questions_bloc.dart';

enum QuestionsStatus { initial, loading, success, failure, updating }

final class QuestionsState {
  const QuestionsState({required this.status, this.questions = const []});

  const QuestionsState.initial() : this(status: QuestionsStatus.initial);

  final QuestionsStatus status;
  final List<String> questions;

  QuestionsState copyWith({QuestionsStatus? status, List<String>? questions}) {
    return QuestionsState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
    );
  }

  @override
  String toString() {
    return '''QuestionState(status: $status, questions: ${questions.toString()})''';
  }
}
