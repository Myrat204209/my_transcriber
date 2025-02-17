import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_transcriber/questions/questions.dart';

part 'questions_event.dart';
part 'questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  QuestionsBloc({required this.questionsRepository})
      : super(const QuestionsState.initial()) {
    on<QuestionsRequested>(_onRequested);
    // on<QuestionsRefreshRequested>(_onRefresh);
    on<QuestionAdded>(_onAdded);
    on<QuestionUpdated>(_onUpdated);
    on<QuestionDeleted>(_onDeleted);
    on<QuestionsReordered>(_onReordered);
    on<QuestionsRefreshRequested>(_onRefresh);
  }

  final QuestionsRepository questionsRepository;

  FutureOr<void> _onRequested(
    QuestionsRequested event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(state.copyWith(status: QuestionsStatus.loading));
    try {
      final questions = await questionsRepository.fetchQuestions();
      emit(state.copyWith(
        status: QuestionsStatus.success,
        questions: questions,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: QuestionsStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onRefresh(
    QuestionsRefreshRequested event,
    Emitter<QuestionsState> emit,
  ) {
    emit(state.copyWith(status: QuestionsStatus.refreshing));
    add(const QuestionsRequested());
  }

  Future<void> _onAdded(
    QuestionAdded event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      await questionsRepository.addQuestion(event.question);
      add(const QuestionsRefreshRequested());
    } catch (error, stackTrace) {
      emit(state.copyWith(status: QuestionsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdated(
      QuestionUpdated event, Emitter<QuestionsState> emit) async {
    try {
      await questionsRepository.editQuestion(
          event.questionIndex, event.newQuestion);
      add(const QuestionsRefreshRequested());
    } catch (error, stackTrace) {
      emit(state.copyWith(status: QuestionsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onDeleted(
      QuestionDeleted event, Emitter<QuestionsState> emit) async {
    try {
      await questionsRepository.deleteQuestion(event.questionIndex);
      add(const QuestionsRefreshRequested());
    } catch (error, stackTrace) {
      emit(state.copyWith(status: QuestionsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onReordered(
    QuestionsReordered event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      log('Reordering questions ${state.questions} to ${event.newOrder}');
      await questionsRepository.reorderQuestions(event.newOrder);
      // Directly emit new state with the new order:
      // emit(state.copyWith(
      //   questions: event.newOrder,
      //   status: QuestionsStatus.success,
      // ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: QuestionsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
