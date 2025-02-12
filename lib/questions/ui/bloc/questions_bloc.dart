import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
part 'questions_event.dart';
part 'questions_state.dart';

class QuestionsBloc extends HydratedBloc<QuestionsEvent, QuestionsState> {
  QuestionsBloc() : super(const QuestionsState.initial()) {
    on<QuestionsRequested>(_onRequested);
    on<QuestionsRefreshRequested>(_onRefresh);
    on<QuestionsAdded>(_onAdded);
    on<QuestionUpdated>(_onUpdated);
    on<QuestionDeleted>(_onDeleted);
  }

  Future<List<String>> _fetchQuestions() async {
    // Simulate an asynchronous fetch.
    await Future.delayed(const Duration(milliseconds: 500));
    return ['Question 1', 'Question 2'];
  }

  FutureOr<void> _onRequested(
      QuestionsRequested event, Emitter<QuestionsState> emit) async {
    if (state.status == QuestionsStatus.loading ||
        (state.status != QuestionsStatus.refreshing &&
            state.questions.isNotEmpty)) {
      return;
    }
    emit(state.copyWith(status: QuestionsStatus.loading));
    try {
      final questions = await _fetchQuestions();
      emit(state.copyWith(
          status: QuestionsStatus.success, questions: questions));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: QuestionsStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onRefresh(
      QuestionsRefreshRequested event, Emitter<QuestionsState> emit) {
    emit(state.copyWith(status: QuestionsStatus.refreshing));
    add(const QuestionsRequested());
  }

  void _onAdded(QuestionsAdded event, Emitter<QuestionsState> emit) {
    emit(state.copyWith(
        questions: List.from(state.questions)..addAll(event.questions)));
  }

  void _onUpdated(QuestionUpdated event, Emitter<QuestionsState> emit) {
    final updatedQuestions = List<String>.from(state.questions);
    if (event.questionIndex < updatedQuestions.length) {
      updatedQuestions[event.questionIndex] =
          '${updatedQuestions[event.questionIndex]} (updated)';
      emit(state.copyWith(questions: updatedQuestions));
    }
  }

  void _onDeleted(QuestionDeleted event, Emitter<QuestionsState> emit) {
    final updatedQuestions = List<String>.from(state.questions);
    if (event.questionIndex < updatedQuestions.length) {
      updatedQuestions.removeAt(event.questionIndex);
      emit(state.copyWith(questions: updatedQuestions));
    }
  }

  @override
  QuestionsState? fromJson(Map<String, dynamic> json) {
    try {
      return QuestionsState.fromJson(json);
    } catch (_) {
      return const QuestionsState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(QuestionsState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
