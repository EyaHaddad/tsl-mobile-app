import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/core/services/text_to_speech_service.dart';
import 'package:tsl_mobile_app/features/settings/services/settings_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    this.recognizedText = ': تُجسّد إشاراتك معانيها',
  });

  final String recognizedText;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextToSpeechService _ttsService = TextToSpeechService.instance;
  bool _isSpeaking = false;

  Future<void> _speakResult() async {
    try {
      final settingsService = await SettingsService.create();
      final settings = settingsService.getSettings();

      await _ttsService.configure(
        language: settings.language,
        speechRate: settings.speechRate,
        pitch: settings.voicePitch,
      );

      if (!mounted) return;
      setState(() => _isSpeaking = true);
      await _ttsService.speak(widget.recognizedText);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('TTS error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (green)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: const Color(0xFF2DC9A0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title + emoji
                  const Row(
                    children: [
                      Text(
                        'إشاراتك تُحيي كلماتك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text('✨', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  // Back arrow (to Home)
                  GestureDetector(
                    onTap: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Result text box
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      widget.recognizedText,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // تحويل إلى صوت
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isSpeaking ? null : _speakResult,
                      icon: const Icon(
                        Icons.volume_up_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isSpeaking ? 'جاري التشغيل...' : 'تحويل إلى صوت',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2DC9A0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // تسجيل مجدداً
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'تسجيل مجدداً',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2238),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
