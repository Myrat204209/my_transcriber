import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_transcriber/questions/questions.dart';

part 'questions_event.dart';
part 'questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  QuestionsBloc({required this.questionsRepository})
    : super(const QuestionsState.initial()) {
    on<QuestionsInitialized>(_onInit);
    on<QuestionsRequested>(_onRequested);
    on<QuestionAdded>(_onAdded);
    on<QuestionUpdated>(_onUpdated);
    on<QuestionDeleted>(_onDeleted);
    on<QuestionsReordered>(_onReordered);
  }

  final QuestionsRepository questionsRepository;

  void _onInit(QuestionsInitialized event, Emitter<QuestionsState> emit) {
    emit(state.copyWith(status: QuestionsStatus.initial));
    add(const QuestionsRequested());
  }

  Future<void> _onRequested(
    QuestionsRequested event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(state.copyWith(status: QuestionsStatus.loading));
    try {
      final questions = await questionsRepository.fetchQuestions();
      emit(
        state.copyWith(status: QuestionsStatus.success, questions: questions),
      );
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onAdded(
    QuestionAdded event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      await questionsRepository.addQuestion(event.question);
      logger.f(event.question);
      emit(state.copyWith(status: QuestionsStatus.updating));
      emit(
        state.copyWith(
          questions: [...state.questions, event.question],
          status: QuestionsStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onUpdated(
    QuestionUpdated event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      await questionsRepository.editQuestion(
        event.questionIndex,
        event.newQuestion,
      );
      final updatedQuestions = [...state.questions];
      updatedQuestions[event.questionIndex] = event.newQuestion;
      emit(state.copyWith(status: QuestionsStatus.updating));
      emit(
        state.copyWith(
          questions: updatedQuestions,
          status: QuestionsStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onDeleted(
    QuestionDeleted event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      await questionsRepository.deleteQuestion(event.questionIndex);
      final updatedQuestions = [...state.questions]
        ..removeAt(event.questionIndex);
        emit(state.copyWith(status: QuestionsStatus.updating));
      emit(
        state.copyWith(
          questions: updatedQuestions,
          status: QuestionsStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onReordered(
    QuestionsReordered event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      await questionsRepository.reorderQuestions(
        oldIndex: event.oldIndex,
        newIndex: event.newIndex,
      );
      // emit(state.copyWith(questions: event.newOrder, status: QuestionsStatus.success));
      //TODO:  add unComment QuestionRequested method
      // add(QuestionsRequested());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  void _handleError(
    Emitter<QuestionsState> emit,
    Object error,
    StackTrace stackTrace,
  ) {
    emit(state.copyWith(status: QuestionsStatus.failure));
    logger.f('Fatal Error', error: error, stackTrace: stackTrace);
    addError(error, stackTrace);
  }
}
