import 'package:equatable/equatable.dart';
import 'package:my_transcriber/chats/chats.dart';

/// A base failure for the chat repository failures.
abstract class ChatFailure with EquatableMixin implements Exception {
  const ChatFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

class SpeakFailure extends ChatFailure {
  const SpeakFailure(super.error);
}

class ListenFailure extends ChatFailure {
  const ListenFailure(super.error);
}

class ConversationCycleFailure extends ChatFailure {
  const ConversationCycleFailure(super.error);
}

class ExportConversationFailure extends ChatFailure {
  const ExportConversationFailure(super.error);
}

class ShutdownFailure extends ChatFailure {
  const ShutdownFailure(super.error);
}

class ChatRepository {
  ChatRepository({
    required ChatService chatService,
  }) : _chatService = chatService;

  final ChatService _chatService;

  /// Internal conversation log to accumulate exchanged texts.
  final List<String> _conversationLog = [];

  /// Speaks the provided text in the given locale.
  /// Logs the spoken text into the conversation log.
  Future<void> speakText(String text) async {
    try {
      _conversationLog.add("Bot: $text");
      await _chatService.speakText(text);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SpeakFailure(error), stackTrace);
    }
  }

  /// Initializes speech recognition and listens to user speech for the given duration.
  /// Returns the recognized text and logs it.
  Future<String> listenUserSpeech(
      {Duration listenDuration = const Duration(seconds: 5)}) async {
    try {
      final String recognizedText = await _chatService.listenUserSpeech(listenDuration: listenDuration);
      _conversationLog.add("User: $recognizedText");
      return recognizedText;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ListenFailure(error), stackTrace);
    }
  }

  /// Performs one conversation cycle: speaks [textToSpeak] and then listens to the user's reply.
  Future<String> conversationCycle(String textToSpeak) async {
    try {
      await speakText(textToSpeak);
      final String userReply = await listenUserSpeech();
      return userReply;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ConversationCycleFailure(error), stackTrace);
    }
  }

  /// Combines the conversation log into a single text and exports it as a DOCX file at [filePath].
  Future<void> exportConversation(String filePath) async {
    try {
      final String conversationText = _conversationLog.join("\n");
      // await _chatService.exportConversation(conversationText, filePath);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ExportConversationFailure(error), stackTrace);
    }
  }

  /// Turns off all native tools like the microphone and TTS engine.
  Future<void> shutdown() async {
    try {
      await _chatService.shutdown();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShutdownFailure(error), stackTrace);
    }
  }
}
