import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:path_provider/path_provider.dart';

/// A base failure for the chat repository failures.
abstract class ChatFailure with EquatableMixin implements Exception {
  const ChatFailure(this.error);

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

class PauseFailure extends ChatFailure {
  const PauseFailure(super.error);
}

class ResumeFailure extends ChatFailure {
  const ResumeFailure(super.error);
}

class ExportConversationFailure extends ChatFailure {
  const ExportConversationFailure(super.error);
}

class ShutdownFailure extends ChatFailure {
  const ShutdownFailure(super.error);
}

// chat_repository.dart (updated)
class ChatRepository {
  ChatRepository({required ChatService chatService})
    : _chatService = chatService;

  final ChatService _chatService;
  // bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      //   if (_isInitialized) return;
      await _chatService.initialize();
      // _isInitialized = true;
    } catch (error, stackTrace) {
      // _isInitialized = false;
      Error.throwWithStackTrace(InitializeFailure(error), stackTrace);
    }
  }

  Future<void> askQuestion(String text) async {
    try {
      // if (!_isInitialized) throw StateError('Repository not initialized');
      await _chatService.speak(text);
    } catch (error, stackTrace) {
      await _chatService.stopSpeaker();
      Error.throwWithStackTrace(SpeakFailure(error), stackTrace);
    }
  }

  Future<String> listenAnswer() async {
    try {
      // if (!_isInitialized) throw StateError('Repository not initialized');
      return await _chatService.listen();
    } catch (error, stackTrace) {
      await _chatService.stopListener();
      Error.throwWithStackTrace(ListenFailure(error), stackTrace);
    }
  }

  FutureOr<void> pauseChat() async {
    try {
      await _chatService.makePause();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PauseFailure(error), stackTrace);
    }
  }

  FutureOr<void> resumeChat() async {
    try {
      await _chatService.resumeSpeaker();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResumeFailure(error), stackTrace);
    }
  }

  Future<void> exportConversation({required String textConversation}) async {
    try {
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw UnsupportedError("Unsupported platform");
      }
      final file = File('${directory.path}/Conversation.txt');
      await file.writeAsString(textConversation);
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> shutdown() async {
    try {
      await _chatService.shutdown();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShutdownFailure(error), stackTrace);
    }
  }
}
