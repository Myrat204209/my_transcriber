// import 'package:docx_template/docx_template.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatService {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  final List<String> _conversationLog = [];

  bool _isSpeechAvailable = false;

  Future<void> initialize({required String locale}) async {
    await _flutterTts.setLanguage(locale);
    _isSpeechAvailable = await _speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
  }

  Future<void> speakText(String text) async {
    _conversationLog.add("Bot: $text");
    await _flutterTts.speak(text);
  }

  Future<String> listenUserSpeech(
      {Duration listenDuration = const Duration(seconds: 5)}) async {
    String recognizedText = "";
    if (_isSpeechAvailable) {
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        listenFor: listenDuration,
      );
      await Future.delayed(listenDuration + const Duration(seconds: 1));
      await _speechToText.stop();
      _conversationLog.add("User: $recognizedText");
    }
    return recognizedText;
  }

  Future<String> conversationCycle(String textToSpeak) async {
    await speakText(textToSpeak);
    String userReply = await listenUserSpeech();
    return userReply;
  }

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
