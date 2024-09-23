import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ttsProvider = Provider<TTSService>((ref) {
  return TTSService();
});

class TTSService {
  final FlutterTts tts = FlutterTts();

  Future<void> initializeTTS() async {
    try {
      await tts.setSpeechRate(0.5);
      await tts.setLanguage("en-US");
      await tts.setPitch(1.0);
    } catch (e) {
      print('$e');
    }
  }

  void speak(String content) async {
    if (content.isNotEmpty) {
      await tts.speak(content);
    }
  }

  void dispose() async {
    await tts.stop();
  }
}
