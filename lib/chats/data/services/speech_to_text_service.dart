part of 'chats_service.dart';

class SpeechToTextService {
  final _speechToText = SpeechToText();

  Future<void> initialize() async {
    await _speechToText.initialize(
      finalTimeout: Duration(seconds: 5),
      debugLogging: true,
      onStatus: (status) => talker.info('Speech status: $status'),
      onError: (error) => talker.error('Speech engine error:', error.errorMsg),
    );
  }

  Future<String> listenSpeech({
    Duration listenDuration = const Duration(minutes: 2),
  }) async {
    // if (_speechToText.isAvailable) throw StateError('Speech Service not initialized');
    // if (_speechToText.isListening) await stopListening();

    final completer = Completer<String>();
    try {
      _speechToText.listen(
        listenFor: listenDuration,
        pauseFor: Duration(seconds: 45),
        onResult: (result) {
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
        listenOptions: SpeechListenOptions(
          autoPunctuation: true,
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
          enableHapticFeedback: true,
          onDevice: true,
        ),
        localeId: 'ru_RU',
        // onError: (error) => completer.completeError(error),
      );

      return await completer.future.timeout(listenDuration);
    } finally {
      await stopListening();
    }
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
