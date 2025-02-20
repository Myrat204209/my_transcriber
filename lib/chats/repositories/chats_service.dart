// chat_service.dart (updated)
import 'dart:async';
import 'dart:developer';

import 'package:flutter_beep_plus/flutter_beep_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatService {
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterBeepPlus _flutterBeepPlus = FlutterBeepPlus();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isListening = false;

  Future<void> initialize() async {
    try {
      final langs = await _flutterTts.getLanguages;
      log('Supported languages: $langs');

      await _flutterTts.setLanguage('ru-RU');
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      
      await _flutterTts.awaitSpeakCompletion(true);

      await _speechToText.initialize(
        debugLogging: true,
        onStatus: (status) => logger.t('Speech status: $status'),
        onError: (error) => logger.e('Speech engine error: $error'),
      );

      _isInitialized = true;
    } catch (e, stackTrace) {
      _isInitialized = false;
      throw Error.throwWithStackTrace('Initialization failed: $e', stackTrace);
    }
  }

  Future<void> speakText(String text) async {
    if (!_isInitialized) throw StateError('Service not initialized');
    if (_isSpeaking) await stopSpeaking();

    try {
      _isSpeaking = true;
      await _flutterTts.speak(text * 4);
      await _flutterTts.awaitSpeakCompletion(true);
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
    }
  }

  Future<String> listenSpeech({
    Duration listenDuration = const Duration(minutes: 2),
  }) async {
    if (!_isInitialized) throw StateError('Service not initialized');
    if (_isListening) await stopListening();

    final completer = Completer<String>();
    try {
      _isListening = true;
      _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
        listenOptions: SpeechListenOptions(
          autoPunctuation: true,
          listenMode: ListenMode.confirmation,
        ),
        listenFor: listenDuration,
        localeId: 'ru-RU',
        // onError: (error) => completer.completeError(error),
      );

      return await completer.future.timeout(listenDuration);
    } finally {
      await stopListening();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }

  Future<void> beep() async {
    try {
      await _flutterBeepPlus.playSysSound(
        AndroidSoundID.TONE_CDMA_ONE_MIN_BEEP,
      );
    } catch (e) {
      logger.e('Beep failed: $e');
      rethrow;
    }
  }

  Future<void> shutdown() async {
    await stopSpeaking();
    await stopListening();
    _isInitialized = false;
  }
}
