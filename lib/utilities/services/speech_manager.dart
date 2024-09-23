import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

final speechProvider = Provider<SpeechManager>((ref) {
  return SpeechManager();
});

class SpeechManager {
  final SpeechToText _stt = SpeechToText();

  bool get isNotListening => !_stt.isListening;

  Future<void> initialize() async {
    try {
      await _stt.initialize();
    } catch (e) {
      debugPrint('$e');
    }
  }

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
      debugPrint('Failed to start listening: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (e) {
      debugPrint('Failed to stop stt: $e');
    }
  }
}
