import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:tsl_mobile_app/core/services/text_to_speech_service.dart';
import 'package:tsl_mobile_app/features/history/models/history_record.dart';
import 'package:tsl_mobile_app/features/settings/services/settings_service.dart';

// Detail view for one saved history record
class OldRecordScreen extends StatefulWidget {
  final HistoryRecord record;

  const OldRecordScreen({super.key, required this.record});

  @override
  State<OldRecordScreen> createState() => _OldRecordScreenState();
}

class _OldRecordScreenState extends State<OldRecordScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextToSpeechService _ttsService = TextToSpeechService.instance;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');
  bool _isPlaying = false;
  double _currentPosition = 0;
  final double _duration = 100; // Simulate 100 seconds duration
  double _playbackSpeed = 1.0;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    _animationController.dispose();
    super.dispose();
  }

  // Toggles text-to-speech playback for this record
  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _ttsService.stop();
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _animationController.reverse();
      });
      return;
    }

    try {
      final settingsService = await SettingsService.create();
      final settings = settingsService.getSettings();

      await _ttsService.configure(
        language: settings.language,
        speechRate: settings.speechRate,
        pitch: settings.voicePitch,
      );

      if (!mounted) return;
      setState(() {
        _isPlaying = true;
        _animationController.forward();
      });

      await _ttsService.speak(widget.record.recognizedText);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('TTS error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _animationController.reverse();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: const Color(0xFF2DC9A0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.record.recognizedText,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dateFormat.format(widget.record.createdAt),
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Audio transcript section (moved above the audio player)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نص الصوت',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.record.recognizedText,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (widget.record.audioPath != null &&
                      widget.record.audioPath!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Audio: ${widget.record.audioPath}',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Audio player section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Waveform visualization with flutter animation
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF2DC9A0),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(
                        painter: _WaveformPainter(
                          animation: _animationController,
                          isPlaying: _isPlaying,
                        ),
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Icon(
                                _isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                size: 60,
                                color: const Color(
                                  0xFF2DC9A0,
                                ).withValues(alpha: _animationController.value),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Play/Pause button
                    GestureDetector(
                      onTap: () {
                        _togglePlayPause();
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2DC9A0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Slider with current position
                    Column(
                      children: [
                        Slider(
                          value: _currentPosition,
                          max: _duration,
                          activeColor: const Color(0xFF2DC9A0),
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (value) {
                            setState(() {
                              _currentPosition = value;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTime(_currentPosition.toInt())),
                              Text(_formatTime(_duration.toInt())),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Playback speed and volume controls
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'السرعة',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 12),
                            ),
                            DropdownButton<double>(
                              value: _playbackSpeed,
                              items: const [
                                DropdownMenuItem(
                                  value: 0.5,
                                  child: Text('0.5x'),
                                ),
                                DropdownMenuItem(
                                  value: 1.0,
                                  child: Text('1.0x'),
                                ),
                                DropdownMenuItem(
                                  value: 1.5,
                                  child: Text('1.5x'),
                                ),
                                DropdownMenuItem(
                                  value: 2.0,
                                  child: Text('2.0x'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _playbackSpeed = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'مستوى الصوت',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              width: 120,
                              child: Slider(
                                value: _volume,
                                min: 0,
                                max: 1,
                                activeColor: const Color(0xFF2DC9A0),
                                onChanged: (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

// Custom waveform painter for audio visualization
class _WaveformPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isPlaying;

  _WaveformPainter({required this.animation, required this.isPlaying})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2DC9A0).withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final numBars = 20;
    final maxHeight = size.height * 0.35;

    for (int i = 0; i < numBars; i++) {
      final x = (size.width / numBars) * i + size.width / numBars * 0.5;

      // Generate pseudo-random heights based on position
      final baseHeight = (i % 5 + 1) * maxHeight / 5;

      // Animate height based on playback state
      final animatedHeight = isPlaying
          ? baseHeight *
                (0.5 +
                    0.5 *
                        (1 + ((i / numBars + animation.value * 2) % 2) - 1)
                            .abs())
          : baseHeight * 0.3;

      canvas.drawLine(
        Offset(x, centerY - animatedHeight / 2),
        Offset(x, centerY + animatedHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) => true;
}
