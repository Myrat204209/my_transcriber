import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/chats/chats.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;

  ChatsBloc({required this.chatRepository}) : super(ChatsState.initial()) {
    on<ChatsInitialized>(_onInit);
    on<ChatsStarted>(_onStarted);
    on<ChatsQuestioned>(_onQuestioned);
    on<ChatsPaused>(_onPaused);
    on<ChatsResumed>(_onResumed);
    on<ChatsListened>(_onListened);
    on<ChatsEnded>(_onEnded);
    on<ChatsFinished>(_onFinished);
  }
  

  void _onInit(ChatsInitialized event, Emitter<ChatsState> emit) {
    if (state.status != ChatsStatus.finished) {
      return;
    }
    emit(ChatsState.initial());
  }

  Future<void> _onStarted(ChatsStarted event, Emitter<ChatsState> emit) async {
    try {
      await chatRepository.initialize();
      emit(
        state.copyWith(
          status: ChatsStatus.started,
          questions: event.questionList,
          currentQuestionIndex: 0,
        ),
      );
      add(ChatsQuestioned());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onQuestioned(
    ChatsQuestioned event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatsStatus.questioning));
      if (state.questions.length <= state.currentQuestionIndex) {
        add(ChatsEnded());
        return;
      }

      await _executeWithSafety(
        action:
            () => chatRepository.askQuestion(
              state.questions[state.currentQuestionIndex],
            ),
        cleanup: () => chatRepository.shutdown(),
      );

      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
      add(ChatsListened());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  FutureOr<void> _onPaused(ChatsPaused event, Emitter<ChatsState> emit) async {
    try {
      emit(state.copyWith(status: ChatsStatus.pausing));
      await chatRepository.pauseChat();
    } catch (e, st) {
      _handleError(emit, e, st);
    }
  }
  FutureOr<void> _onResumed(
    ChatsResumed event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatsStatus.resuming));
      await chatRepository.resumeChat(
        text: state.questions[state.currentQuestionIndex],
      );
      add(ChatsQuestioned());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onListened(
    ChatsListened event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatsStatus.listening));
      final userAnswer = await chatRepository.listenAnswer();
      emit(
        state.copyWith(recognizedText: [...state.recognizedText, userAnswer]),
      );
      // await chatRepository.makeInterruption();
      add(ChatsQuestioned());
    } catch (error, stackTrace) {
      await chatRepository.shutdown();
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onFinished(
    ChatsFinished event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await chatRepository.exportConversation(
        answeredPhrases: state.recognizedText,
        askedQuestions: state.questions,
      );
      await chatRepository.shutdown();
      emit(state.copyWith(status: ChatsStatus.finished));
      add(ChatsInitialized());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _executeWithSafety({
    required Future<void> Function() action,
    required Future<void> Function() cleanup,
  }) async {
    try {
      await action();
    } catch (e) {
      await cleanup();
      rethrow;
    }
  }

  void _handleError(
    Emitter<ChatsState> emit,
    Object error,
    StackTrace stackTrace,
  ) {
    emit(state.copyWith(status: ChatsStatus.failure));
    talker.error('Error occurred', error, stackTrace);
    addError(error, stackTrace);
  }

  

  void _onEnded(ChatsEnded event, Emitter<ChatsState> emit) {
    try {
      emit(state.copyWith(status: ChatsStatus.ending));

      // add(ChatsFinished());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }
}
