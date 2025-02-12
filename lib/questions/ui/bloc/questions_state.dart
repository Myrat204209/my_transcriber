part of 'questions_bloc.dart';

enum QuestionsStatus { initial, loading, success, failure, refreshing }

final class QuestionsState extends Equatable {
  const QuestionsState({
    required this.status,
    this.questions = const [],
  });

  factory QuestionsState.fromJson(Map<String, dynamic> json) {
    return QuestionsState(
      status: QuestionsStatus.values[json['status'] as int],
      questions: (json['questions'] as List<dynamic>)
          .map((questionJson) => questionJson as String)
          .toList(),
    );
  }
  const QuestionsState.initial() : this(status: QuestionsStatus.initial);

  final QuestionsStatus status;
  final List<String> questions;

  @override
  List<Object?> get props => [status, questions];

  QuestionsState copyWith({
    QuestionsStatus? status,
    List<String>? questions,
  }) {
    return QuestionsState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.index,
      'questions': questions,
    };
  }
}
