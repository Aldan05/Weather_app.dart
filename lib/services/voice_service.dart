import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final stt.SpeechToText speech = stt.SpeechToText();
  final FlutterTts tts = FlutterTts();

  /// Start listening to voice input
  Future<bool> startListening(Function(String) onResult) async {
    bool available = await speech.initialize();
    if (available) {
      speech.listen(onResult: (result) => onResult(result.recognizedWords));
      return true;
    }
    return false;
  }

  /// Stop listening
  Future stopListening() async {
    await speech.stop();
  }

  /// Speak output (Weather details)
  Future speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.speak(text);
  }
}
