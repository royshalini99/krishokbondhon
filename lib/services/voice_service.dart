import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Wraps speech-to-text (farmer asking a question by voice) and
/// text-to-speech (reading AI/expert answers aloud) — key for
/// low-literacy accessibility as described in the project brief.
class VoiceService {
  VoiceService._internal();
  static final VoiceService instance = VoiceService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _speechAvailable = false;

  Future<bool> initSpeech() async {
    _speechAvailable = await _speech.initialize();
    return _speechAvailable;
  }

  Future<void> startListening({
    required void Function(String text) onResult,
    String localeId = 'en_IN',
  }) async {
    if (!_speechAvailable) await initSpeech();
    if (!_speechAvailable) return;
    await _speech.listen(
      localeId: localeId,
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  Future<void> stopListening() => _speech.stop();

  bool get isListening => _speech.isListening;

  Future<void> speak(String text, {String languageCode = 'en-IN'}) async {
    await _tts.setLanguage(languageCode);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() => _tts.stop();
}
