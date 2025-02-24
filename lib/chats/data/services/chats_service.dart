import 'dart:async';
import 'dart:io'
    show Directory, File, FileSystemEntity, FileSystemException, Platform;

// import 'package:flutter_beep_plus/flutter_beep_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:my_transcriber/permissions/permissions.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, getExternalStorageDirectory;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'text_to_speech_service.dart';
part 'speech_to_text_service.dart';
part 'export_service.dart';

class ChatService  {
  final _flutterTts = TextToSpeechService();
  final _speechToText = SpeechToTextService();
  final _exporter = ExportService();
  // final _flutterBeepPlus = FlutterBeepPlus();

  Future<void> initialize() async {
    try {
      await _flutterTts.initialize();
      await _speechToText.initialize();
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

  Future<String> listen() async {
    return await _speechToText.listenSpeech();
  }

  Future<void> stopSpeaker() => _flutterTts.stopSpeaking();

  Future<void> stopListener() => _speechToText.stopListening();

  Future<void> shutdown() async {
    await _flutterTts.stopSpeaking();
    await _speechToText.stopListening();
  }

  Future<void> exportChat({
    required List<String> questions,
    required List<String> answers,
  }) async {
    await _exporter.exportToStorage(questions: questions, answers: answers);
  }
}
