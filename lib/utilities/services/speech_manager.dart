import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Provides an instance of [SpeechManager] using Riverpod.
///
/// This provider allows easy access to the speech-to-text service throughout the application.
final speechProvider = Provider<SpeechManager>((ref) {
  return SpeechManager();
});

///A service class for managing speech-to-text (STT) functionality.
///
/// This class uses the `speech_to_text` package to provide STT capabilities.
class SpeechManager {
  /// The [SpeechToText] instance used for speech-to-text.
  final SpeechToText _stt = SpeechToText();

  /// Indicates whether the speech-to-text engine is currently not listening.
  bool get isNotListening => !_stt.isListening;

  /// Initializes the speech-to-text engine.
  ///
  /// Throws an exception if there is an error during initialization.
  Future<void> initialize() async {
    try {
      await _stt.initialize();
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Starts listening for speech input.
  ///
  /// Parameters:
  ///   - [onResult]: A callback function that is called with the recognized text as a string.
  ///
  /// Throws an exception if there is an error starting the listening process.
  Future<void> startListening(Function(String) onResult) async {
    try {
      final options = SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        autoPunctuation: true,
      );
      await _stt.listen(
        onResult: (result) => onResult(result.recognizedWords),
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 5),
        listenOptions: options,
      );
    } catch (e) {
      throw Exception('Failed to start listening: $e');
    }
  }

  /// Stops the speech-to-text engine from listening.
  ///
  /// Throws an exception if there is an error stopping the listening process.
  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (e) {
      throw Exception('Failed to stop stt: $e');
    }
  }
}
