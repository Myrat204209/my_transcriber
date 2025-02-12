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

final class QuestionsRefreshRequested extends QuestionsEvent {}

final class QuestionsAdded extends QuestionsEvent {
  final List<String> questions;

  const QuestionsAdded(this.questions);
}

final class QuestionUpdated extends QuestionsEvent {
  final int questionIndex;

  const QuestionUpdated(this.questionIndex);
}

final class QuestionDeleted extends QuestionsEvent {
  final int questionIndex;

  const QuestionDeleted(this.questionIndex);
}
