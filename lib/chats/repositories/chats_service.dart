// import 'package:docx_template/docx_template.dart';
import 'dart:developer';

import 'package:flutter_beep_plus/flutter_beep_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatService {
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterBeepPlus _flutterBeepPlus = FlutterBeepPlus();

  // final List<String> _conversationLog = [];

  Future<void> initialize({String locale = 'ru'}) async {
    // await _flutterTts.setLanguage('ru-RU');
    await _flutterTts.setLanguage('ru-RU').onError( (error, stackTrace) => throw('TTS error: $error'));
    log('Initialized TTS with locale: $locale');

    await _speechToText.initialize(
      debugLogging: true,

      onStatus: (status) => logger.t('Speech status: $status'),
      onError: (error) => throw('Speech error: $error'),
    );
    log('Initialized Speech to text with locale: $locale');
  }

  Future<void> speakText(String text) async {
    // _conversationLog.add("Bot: $text");
    log('Speaker started speaking: $text');
    await _flutterTts.speak(text);
  }

  Future<String> listenSpeech({
    Duration listenDuration = const Duration(seconds: 5),
  }) async {
    String recognizedText = "";

    await _speechToText.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
      listenOptions: SpeechListenOptions(
        autoPunctuation: true,
        listenMode: ListenMode.deviceDefault,
      ),
      pauseFor: const Duration(seconds: 1),
      listenFor: listenDuration,
      localeId: 'ru_RU',
    );
    // _conversationLog.add("User: $recognizedText");
    return recognizedText;
  }

  Future<void> beep() async {
    await _flutterBeepPlus.playSysSound(AndroidSoundID.TONE_CDMA_ONE_MIN_BEEP);
  }
  // Future<String> conversationCycle(String textToSpeak) async {
  //   await speakText(textToSpeak);
  //   String userReply = await listenUserSpeech();
  //   return userReply;
  // }

  /// Exports the accumulated conversation log into a DOCX file at [filePath].
  /// This example uses a DOCX template file named "template.docx" from assets.
  // Future<void> exportConversationToDocx(String filePath) async {
  //   // Combine the conversation log.
  //   final String conversationText = _conversationLog.join("\n");

  //   // Load the DOCX template file.
  //   final File templateFile = File('assets/template.docx');
  //   if (!templateFile.existsSync()) {
  //     throw Exception('Template file not found!');
  //   }
  //   final bytes = templateFile.readAsBytesSync();
  //   // final docx = await DocxTemplate.fromBytes(bytes);

  //   // Prepare content: "conversation" is the key used in the template.
  //   // Content content = Content();
  //   // content.add(TextContent("conversation", conversationText));

  //   // Generate the DOCX file.
  //   // final d = await docx.generate(content);
  //   if (d != null) {
  //     File(filePath).writeAsBytesSync(d);
  //     print('Conversation exported to $filePath');
  //   } else {
  //     print('Failed to generate DOCX file.');
  //   }
  // }

  /// Shuts down the service by stopping TTS and speech recognition.
  Future<void> shutdown() async {
    await _flutterTts.stop();
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
