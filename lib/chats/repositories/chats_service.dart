// chat_service.dart (updated)
import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter_beep_plus/flutter_beep_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatService {
  final _flutterTts = FlutterTts();
  final _speechToText = SpeechToText();
  final _flutterBeepPlus = FlutterBeepPlus();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isListening = false;

  Future<void> initialize() async {
    try {
      final langs = await _speechToText.locales();
      log('Supported languages: ${langs.map((l) => l.localeId).toList()}');

      await _flutterTts.setLanguage('ru-RU');
      await _flutterTts.setSpeechRate(0.5);
      if (Platform.isIOS) {
        await _flutterTts.setSharedInstance(true);
      }
      // _flutterTts.completionHandler = () {
      //   _flutterBeepPlus.playSysSound(AndroidSoundID.TONE_CDMA_ONE_MIN_BEEP);
      // };

      await _flutterTts.awaitSpeakCompletion(true);

      await _speechToText.initialize(
        finalTimeout: Duration(seconds: 5),
        debugLogging: true,
        onStatus: (status) => talker.info('Speech status: $status'),
        onError:
            (error) => talker.error('Speech engine error:', error.errorMsg),
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
      await _flutterTts.speak(text, focus: true);
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
        pauseFor: Duration(minutes: 1),
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
        localeId: 'ru_RU',
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

  Future<void> shutdown() async {
    await stopSpeaking();
    await stopListening();
    _isInitialized = false;
  }
}
