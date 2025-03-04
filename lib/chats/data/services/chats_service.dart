import 'dart:async';

import 'package:my_transcriber/chats/chats.dart'
    show ExportService, SpeechToTextService, TextToSpeechService;

class ChatService {
  final _flutterTts = TextToSpeechService();
  final _speechToText = SpeechToTextService();
  final _exporter = ExportService();
  // final _flutterBeepPlus = FlutterBeepPlus();

  Future<void> initialize() async {
    try {
      await _flutterTts.initialize();
      await _speechToText.initialize();
      await _exporter.init();
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace('Initialization failed: $e', stackTrace);
    }
  }

  Future<void> makePause() async {
    await _flutterTts.makePause();
  }

  Future<void> resumeSpeaker(String text) async {
    await _flutterTts.resumeSpeaker(text);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speakText(text);
  }

  Future<String?> listen() async {
    return await _speechToText.listenSpeech();
  }

  Future<void> stopSpeaker() => _flutterTts.stopSpeaking();

  Future<void> stopListener() => _speechToText.stopListening();

  Future<void> shutdown() async {
    await _flutterTts.stopSpeaking();
    await _speechToText.stopListening();
  }

  Future<void> exportChat({required List<String> chat}) async {
    await _exporter.exportToStorage(chatContent: chat);
  }
}
