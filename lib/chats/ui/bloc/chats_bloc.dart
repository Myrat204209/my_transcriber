import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
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
    // if (state.status != ChatsStatus.finished) {
    //   return;
    // }
    emit(ChatsState.initial());
  }

  Future<void> _onStarted(ChatsStarted event, Emitter<ChatsState> emit) async {
    try {
      await chatRepository.initialize();
      emit(
        state.copyWith(
          status: ChatsStatus.started,
          pendingQuestions: event.questionList,
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
    if (state.status == ChatsStatus.pausing ||
        state.status == ChatsStatus.resuming) {
      return;
    }
    try {
      if (state.pendingQuestions.isEmpty) {
        add(ChatsEnded());
        return;
      }
      final nextQuestion = state.pendingQuestions.first;
      emit(
        state.copyWith(
          currentQuestion: nextQuestion,
          chatContent: [...state.chatContent, nextQuestion],
          pendingQuestions: state.pendingQuestions.sublist(1),
          status: ChatsStatus.questioning,
        ),
      );
      await _executeWithSafety(
        action: () => chatRepository.askQuestion(nextQuestion),
        cleanup: () => chatRepository.shutdown(),
      );
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    } finally {
      if (state.status == ChatsStatus.questioning) {
        add(ChatsListened());
      }
    }
  }

  FutureOr<void> _onPaused(ChatsPaused event, Emitter<ChatsState> emit) async {
    if (state.status == ChatsStatus.listening) return;
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
      await chatRepository.resumeChat(text: state.currentQuestion);
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    } finally {
      // emit(
      //   state.copyWith(
      //     currentQuestion: state.pendingQuestions.first,
      //     pendingQuestions: state.pendingQuestions.sublist(1),
      //   ),
      // );
      add(ChatsListened());
    }
  }

  Future<void> _onListened(
    ChatsListened event,
    Emitter<ChatsState> emit,
  ) async {
    if (state.status == ChatsStatus.pausing) return;
    try {
      emit(state.copyWith(status: ChatsStatus.listening));
      final userAnswer = await chatRepository.listenAnswer();
      emit(state.copyWith(chatContent: [...state.chatContent, userAnswer??'']));
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
      await chatRepository.exportConversation(chat: state.chatContent);
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
    addError(error, stackTrace);
  }

  void _onEnded(ChatsEnded event, Emitter<ChatsState> emit) {
    try {
      emit(state.copyWith(status: ChatsStatus.ending));
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }
}
