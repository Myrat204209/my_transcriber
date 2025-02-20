import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:my_transcriber/chats/chats.dart';

part 'chats_event.dart';
part 'chats_state.dart';

final Logger logger = GetIt.I<Logger>();

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;

  ChatsBloc({required this.chatRepository}) : super(ChatsState.initial()) {
    on<ChatsStarted>(_onChatsStarted);
    on<ChatQuestioned>(_onChatQuestioned);
    on<ChatBeeped>(_onChatBeeped);
    on<ChatListened>(_onChatListened);
    on<ChatFinished>(_onChatFinished);
  }

  Future<void> _onChatsStarted(
    ChatsStarted event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await chatRepository.initialize();
      emit(
        state.copyWith(
          status: ChatsStatus.started,
          currentQuestion: event.questionList,
        ),
      );
      add(ChatQuestioned());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  Future<void> _onChatQuestioned(
    ChatQuestioned event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatsStatus.questioning));
      if (state.currentQuestion.isEmpty) {
        add(ChatFinished());
        return;
      }

      await _executeWithSafety(
        action: () => chatRepository.askQuestion(state.currentQuestion.first),
        cleanup: () => chatRepository.shutdown(),
      );

      emit(state.copyWith(currentQuestion: state.currentQuestion.sublist(1)));
      Future.delayed(const Duration(seconds: 5));
      add(ChatBeeped());
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

  void _onChatListened(ChatListened event, Emitter<ChatsState> emit) async {
    try {
      emit(state.copyWith(status: ChatsStatus.listening));
      final userAnswer = await chatRepository.listenAnswer();
      emit(
        state.copyWith(recognizedText: [...state.recognizedText, userAnswer]),
      );
      // await chatRepository.makeInterruption();
      add(ChatQuestioned());
    } catch (error, stackTrace) {
      await chatRepository.shutdown();
      _handleError(emit, error, stackTrace);
    }
    // }

    // Future<void> _onChatQuestioned(
    //   ChatQuestioned event,
    //   Emitter<ChatsState> emit,
    // ) async {
    //   try {
    //     emit(state.copyWith(status: ChatsStatus.questioning));
    //     if (state.currentQuestion.isEmpty) {
    //       add(ChatFinished());
    //       return;
    //     }
    //     await chatRepository.askQuestion(state.currentQuestion.first);
    //     emit(state.copyWith(currentQuestion: state.currentQuestion.sublist(1)));
    //     add(ChatBeeped());
    //   } catch (error, stackTrace) {
    //     _handleError(emit, error, stackTrace);
    //   }
  }

  Future<void> _onChatBeeped(ChatBeeped event, Emitter<ChatsState> emit) async {
    try {
      await chatRepository.makeInterruption();

      emit(state.copyWith(status: ChatsStatus.beeping));
      add(ChatListened());
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  // void _onChatListened(ChatListened event, Emitter<ChatsState> emit) async {
  //   try {
  //     emit(state.copyWith(status: ChatsStatus.listening));
  //     final userAnswer = await chatRepository.listenAnswer();
  //     emit(
  //       state.copyWith(recognizedText: [...state.recognizedText, userAnswer]),
  //     );
  //     await chatRepository.makeInterruption();
  //     add(ChatQuestioned());
  //   } catch (error, stackTrace) {
  //     _handleError(emit, error, stackTrace);
  //   }
  // }

  Future<void> _onChatFinished(
    ChatFinished event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      // await chatRepository.exportConversation("conversation.docx");
      await chatRepository.shutdown();
      emit(state.copyWith(status: ChatsStatus.finished));
    } catch (error, stackTrace) {
      _handleError(emit, error, stackTrace);
    }
  }

  void _handleError(
    Emitter<ChatsState> emit,
    Object error,
    StackTrace stackTrace,
  ) {
    emit(state.copyWith(status: ChatsStatus.failure));
    logger.e('Error occurred', error: error, stackTrace: stackTrace);
    addError(error, stackTrace);
  }
}
