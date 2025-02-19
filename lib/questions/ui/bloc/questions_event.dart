part of 'questions_bloc.dart';

@immutable
sealed class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object> get props => [];
}

final class QuestionsInitialized extends QuestionsEvent {}

final class QuestionsRequested extends QuestionsEvent {}

final class QuestionAdded extends QuestionsEvent {
  final String question;

  const QuestionAdded(this.question);
}

final class QuestionUpdated extends QuestionsEvent {
  final int questionIndex;
  final String newQuestion;

  const QuestionUpdated(this.questionIndex, this.newQuestion);
}

final class QuestionDeleted extends QuestionsEvent {
  final int questionIndex;

  const QuestionDeleted(this.questionIndex);
}

final class QuestionsReordered extends QuestionsEvent {
  final int oldIndex, newIndex;

  const QuestionsReordered({required this.oldIndex, required this.newIndex});
}
