import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/chats/chats.dart';

part 'chats_event.dart';
part 'chats_state.dart';

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
      // You might perform any initialization needed via the repository here.
      emit(state.copyWith(status: ChatsStatus.started));
    } catch (e) {
      emit(state.copyWith(
          status: ChatsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onChatQuestioned(
    ChatQuestioned event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      // Update state with the new question.
      emit(state.copyWith(
        status: ChatsStatus.questioned,
        currentQuestion: event.line,
      ));
      // Trigger a conversation cycle:
      final userReply = await chatRepository.conversationCycle(event.line);
      // Update state with the recognized reply.
      emit(state.copyWith(
        status: ChatsStatus.listening,
        recognizedText: userReply,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChatsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onChatBeeped(
    ChatBeeped event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      // Use a default beep text.
      await chatRepository.speakText("Beep");
      emit(state.copyWith(status: ChatsStatus.beeped));
    } catch (e) {
      emit(state.copyWith(
          status: ChatsStatus.error, errorMessage: e.toString()));
    }
  }

  // Since ChatListened carries recognizedText, we just update state accordingly.
  void _onChatListened(
    ChatListened event,
    Emitter<ChatsState> emit,
  ) {
    try {
      emit(state.copyWith(
        status: ChatsStatus.listening,
        recognizedText: event.recognizedText,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChatsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onChatFinished(
    ChatFinished event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      // Export the conversation log to a DOCX file. The file path can be parameterized.
      await chatRepository.exportConversation("conversation.docx");
      // Shut down native tools (microphone, TTS engine, etc.).
      await chatRepository.shutdown();
      emit(state.copyWith(status: ChatsStatus.finished));
    } catch (e) {
      emit(state.copyWith(
          status: ChatsStatus.error, errorMessage: e.toString()));
    }
  }
}
