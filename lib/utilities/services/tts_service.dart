import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides an instance of [TTSService] using Riverpod.
///
/// This provider allows easy access to the text-to-speech service throughout the application.
final ttsProvider = Provider<TTSService>((ref) {
  return TTSService();
});

///A service class for handling text-to-speech (TTS) functionality.
///
/// This class uses the `flutter_tts` package to provide TTS capabilities.
class TTSService {
  /// The [FlutterTts] instance used for text-to-speech.
  final FlutterTts tts = FlutterTts();

  /// Initializes the text-to-speech engine with default settings.
  ///
  /// This method sets the speech rate, language, and pitch.
  ///
  /// Throws an exception if there is an error during initialization.
  Future<void> initializeTTS() async {
    try {
      await tts.setSpeechRate(0.5);
      await tts.setLanguage("en-US");
      await tts.setPitch(1.0);
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Speaks the given text content.
  ///
  /// If the content is empty, nothing will be spoken.
  ///
  /// Parameters:
  ///   - [content]: The text content to be spoken.
  void speak(String content) async {
    if (content.isNotEmpty) {
      await tts.speak(content);
    }
  }

  /// Stops the text-to-speech engine and releases resources.
  void dispose() async {
    await tts.stop();
  }
}
