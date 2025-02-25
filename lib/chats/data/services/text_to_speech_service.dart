part of 'chats_service.dart';

final _flutterTts = FlutterTts();

class TextToSpeechService {
  bool _isInitialized = false;
  bool _isSpeaking = false;

  Future<void> initialize() async {
    try {
      talker.critical('FlutterTTS initialize ');
      await _flutterTts.setLanguage('ru-RU');
      await _flutterTts.setSpeechRate(0.5);
      
      if (Platform.isIOS) {
        await _flutterTts.setSharedInstance(true);
      }
      await _flutterTts.awaitSpeakCompletion(true);

      _isInitialized = true;
    } catch (e, stackTrace) {
      _isInitialized = false;
      throw Error.throwWithStackTrace('Initialization failed: $e', stackTrace);
    }
  }

  Future<void> speakText(String text) async {
    if (!_isInitialized) {
      throw StateError('Text-To-Speech Service not initialized');
    }
    if (_isSpeaking) await stopSpeaking();

    try {
      _isSpeaking = true;
      await _flutterTts.speak(text, focus: true);
      await _flutterTts.awaitSpeakCompletion(true);
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> makePause() async {
    await _flutterTts.pause();
  }

  Future<void> resumeSpeaker(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
    }
  }
}
