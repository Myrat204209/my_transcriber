part of 'questions_bloc.dart';

@immutable
sealed class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object> get props => [];
}

final class QuestionsRequested extends QuestionsEvent {
  const QuestionsRequested();
}

final class QuestionsRefreshRequested extends QuestionsEvent {
  const QuestionsRefreshRequested();
}

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
  final List<String> newOrder;

  const QuestionsReordered(this.newOrder);
}
