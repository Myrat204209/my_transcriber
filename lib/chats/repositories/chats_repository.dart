import 'dart:developer';

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

class InitializeFailure extends ChatFailure {
  const InitializeFailure(super.error);
}
class SpeakFailure extends ChatFailure {
  const SpeakFailure(super.error);
}

class ListenFailure extends ChatFailure {
  const ListenFailure(super.error);
}

class BeepFailure extends ChatFailure {
  const BeepFailure(super.error);
}

class ExportConversationFailure extends ChatFailure {
  const ExportConversationFailure(super.error);
}

class ShutdownFailure extends ChatFailure {
  const ShutdownFailure(super.error);
}

class ChatRepository {
  ChatRepository({required ChatService chatService})
    : _chatService = chatService;

  final ChatService _chatService;

  /// Internal conversation log to accumulate exchanged texts.
  final List<String> _conversationLog = [];

  /// Initializes the chat service with the given locale.
  Future<void> initialize() async {
    try {
      await _chatService.initialize();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(InitializeFailure(error), stackTrace);
    }
  }

  /// Speaks the provided text in the given locale.
  /// Logs the spoken text into the conversation log.
  Future<void> askQuestion(String text) async {
    try {
      // _conversationLog.add("Bot: $text");
      await _chatService.speakText(text);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SpeakFailure(error), stackTrace);
    }
  }

  Future<void> makeInterruption() async {
    try {
      await _chatService.beep();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(BeepFailure(error), stackTrace);
    }
  }

  Future<String> listenAnswer() async {
    try {
      final String recognizedText = await _chatService.listenSpeech();
      // _conversationLog.add("User: $recognizedText");
      log('--------------Recognized text');
      return recognizedText;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ListenFailure(error), stackTrace);
    }
  }


  /// Combines the conversation log into a single text and exports it as a DOCX file at [filePath].
  // Future<void> exportConversation(String filePath) async {
  //   try {
  //     // final String conversationText = _conversationLog.join("\n");
  //     // await _chatService.exportConversation(conversationText, filePath);
  //   } catch (error, stackTrace) {
  //     Error.throwWithStackTrace(ExportConversationFailure(error), stackTrace);
  //   }
  // }

  /// Turns off all native tools like the microphone and TTS engine.
  Future<void> shutdown() async {
    try {
      await _chatService.shutdown();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShutdownFailure(error), stackTrace);
    }
  }
}

