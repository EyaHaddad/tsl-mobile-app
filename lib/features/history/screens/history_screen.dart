import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

// Sample record data model
class Record {
  final String title;
  final String date;
  final String audioText;

  Record({required this.title, required this.date, required this.audioText});
}

// Full-screen wrapper (keeps HistoryScreen reusable inside a drawer)
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: HistoryScreen(onClose: () => Navigator.of(context).maybePop()),
    );
  }
}

// Sidebar content - History List (reusable inside Drawer)
class HistoryScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const HistoryScreen({super.key, this.onClose});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Record> records;

  @override
  void initState() {
    super.initState();
    // Sample data
    records = [
      Record(
        title: 'سلام',
        date: 'اليوم',
        audioText:
            'هذا هو النص المكتشف من الإشارة الأولى. يمكن تحويله إلى صوت.',
      ),
      Record(
        title: 'شكراً',
        date: 'أمس',
        audioText: 'النص الثاني المتعلق بإشارة الشكر.',
      ),
      Record(
        title: 'نعم',
        date: '3 أيام',
        audioText: 'إشارة توضيحية للقبول والموافقة.',
      ),
      Record(
        title: 'لا',
        date: 'أسبوع',
        audioText: 'نص يعبر عن الرفض أو عدم الموافقة.',
      ),
    ];
  }

  void _deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
  }

  void _clearAllRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد'),
        content: const Text('هل تريد مسح جميع السجلات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                records.clear();
              });
            },
            child: const Text('مسح الكل'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onClose = widget.onClose ?? () => Navigator.of(context).maybePop();

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green header section (at top) with close button inside
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
              color: const Color(0xFF2DC9A0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onClose,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'السجل',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'آخر ترجماتك',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
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
            // Records list
            Expanded(
              child: records.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد ترجمات مخزنة',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeSlidePageRoute(
                                page: OldRecordScreen(record: record),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        record.title,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        record.date,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFFE63950),
                                  ),
                                  onPressed: () => _deleteRecord(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Clear all button
            if (records.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: _clearAllRecords,
                  child: const Text(
                    'مسح السجل',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Old Record Screen - Detailed view with audio player
class OldRecordScreen extends StatefulWidget {
  final Record record;

  const OldRecordScreen({super.key, required this.record});

  @override
  State<OldRecordScreen> createState() => _OldRecordScreenState();
}

class _OldRecordScreenState extends State<OldRecordScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPlaying = false;
  double _currentPosition = 0;
  double _duration = 100; // Simulate 100 seconds duration
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
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'details',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Green header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF2DC9A0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.record.title,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  const Text(
                    'تفاصيل الترجمة',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
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
                                ).withOpacity(_animationController.value),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Play/Pause button
                    GestureDetector(
                      onTap: _togglePlayPause,
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
            // Audio transcript section
            Container(
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
                    widget.record.audioText,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
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
      ..color = const Color(0xFF2DC9A0).withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barWidth = 3.0;
    final spacing = 2.0;
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
