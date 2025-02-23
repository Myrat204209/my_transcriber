import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/permissions/permissions.dart';
import 'package:my_transcriber/chats/chats.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;

  ChatsBloc({required this.chatRepository}) : super(ChatsState.initial()) {
    on<ChatsStarted>(_onStarted);
    on<ChatsQuestioned>(_onQuestioned);
    on<ChatsPaused>(_onPause);
    on<ChatsListened>(_onListened);
    on<ChatsFinished>(_onFinished);
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
        add(ChatsFinished());
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

  FutureOr<void> _onPause(ChatsPaused event, Emitter<ChatsState> emit) async {
    try {
      // await chatRepository.pauseChat();
      // emit(state.copyWith(status: ChatsStatus.pausing));
    } catch (e, st) {
      _handleError(emit, e, st);
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
      await PermissionClient().askStorage();
      List<String> combinedList = [];
      for (int i = 0; i < state.questions.length; i++) {
        combinedList.addAll([state.questions[i], state.recognizedText[i]]);
      }
      await chatRepository.exportConversation(
        textConversation: combinedList.toString(),
      );
      await chatRepository.shutdown();
      emit(state.copyWith(status: ChatsStatus.finished));
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
}
