// questions_bloc.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // _hiveSubscription = questionsRepository.watchQuestions().listen((questions) {
    //   if (!listEquals(questions, state.questions)) {
    //     add(QuestionsRequested());
    //   }
    // });
  }

  final QuestionsRepository questionsRepository;
  // late final StreamSubscription<List<String>> _hiveSubscription;

  void _onInit(QuestionsInitialized event, Emitter<QuestionsState> emit) {
    if (state.status != QuestionsStatus.initial) return;
    add(QuestionsRequested());
  }

  Future<void> _onRequested(
    QuestionsRequested event,
    Emitter<QuestionsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: QuestionsStatus.loading));
      final questions = await questionsRepository.fetchQuestions();
      emit(
        state.copyWith(
          status: QuestionsStatus.success,
          questions: List<String>.from(questions),
        ),
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
      emit(state.copyWith(status: QuestionsStatus.updating));
      await questionsRepository.addQuestion(event.question);
      emit(
        state.copyWith(
          questions: List<String>.from(state.questions)..add(event.question),
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
      emit(state.copyWith(status: QuestionsStatus.updating));
      await questionsRepository.editQuestion(
        event.questionIndex,
        event.newQuestion,
      );
      final updatedQuestions = List<String>.from(state.questions)
        ..[event.questionIndex] = event.newQuestion;
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
      emit(state.copyWith(status: QuestionsStatus.updating));
      await questionsRepository.deleteQuestion(event.questionIndex);
      final updatedQuestions = [...state.questions]
        ..removeAt(event.questionIndex);
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
      final updatedQuestions = [...state.questions];
      final item = updatedQuestions.removeAt(event.oldIndex);
      updatedQuestions.insert(event.newIndex, item);

      emit(
        state.copyWith(
          status: QuestionsStatus.updating,
          questions: updatedQuestions,
        ),
      );

      await questionsRepository.reorderQuestions(
        oldIndex: event.oldIndex,
        newIndex: event.newIndex,
      );
      emit(state.copyWith(status: QuestionsStatus.success));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          questions: state.questions,
          status: QuestionsStatus.failure,
        ),
      );
      addError(error, stackTrace);
    }
  }

  void _handleError(
    Emitter<QuestionsState> emit,
    Object error,
    StackTrace stackTrace,
  ) {
    emit(state.copyWith(status: QuestionsStatus.failure));
    talker.critical ('Fatal Error',  error, stackTrace);
    addError(error, stackTrace);
  }
}
