import 'dart:async';
import 'dart:io' show Platform;

// import 'package:flutter_beep_plus/flutter_beep_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'text_to_speech_service.dart';
part 'speech_to_text_service.dart';
part 'export_service.dart';

class ChatService {
  final _flutterTts = TextToSpeechService();
  final _speechToText = SpeechToTextService();
  // final _flutterBeepPlus = FlutterBeepPlus();

  Future<void> initialize() async {
    try {
      _flutterTts.initialize();
      _speechToText.initialize();
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace('Initialization failed: $e', stackTrace);
    }
  }
  
  Future<void> makePause() async{
    await _flutterTts.makePause();
  }
  
  Future<void> resumeSpeaker() async{
    await _flutterTts.resumeSpeaker();
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
}
