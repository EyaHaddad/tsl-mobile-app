import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

// Sample record data model
class Record {
  final String title;
  final String date;
  final String audioText;

  final int createdIndex;
  bool isFavorite;

  Record({
    required this.title,
    required this.date,
    required this.audioText,
    required this.createdIndex,
    this.isFavorite = false,
  });
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

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  static const Duration _listAnimDuration = Duration(milliseconds: 220);

  int _compareRecords(Record a, Record b) {
    if (a.isFavorite != b.isFavorite) {
      return a.isFavorite ? -1 : 1;
    }
    return a.createdIndex.compareTo(b.createdIndex);
  }

  int _insertionIndexFor(Record record, List<Record> list) {
    for (int i = 0; i < list.length; i++) {
      if (_compareRecords(record, list[i]) < 0) {
        return i;
      }
    }
    return list.length;
  }

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
        createdIndex: 0,
      ),
      Record(
        title: 'شكراً',
        date: 'أمس',
        audioText: 'النص الثاني المتعلق بإشارة الشكر.',
        createdIndex: 1,
      ),
      Record(
        title: 'نعم',
        date: '3 أيام',
        audioText: 'إشارة توضيحية للقبول والموافقة.',
        createdIndex: 2,
      ),
      Record(
        title: 'لا',
        date: 'أسبوع',
        audioText: 'نص يعبر عن الرفض أو عدم الموافقة.',
        createdIndex: 3,
      ),
    ];

    records.sort(_compareRecords);
  }

  Widget _favoriteIcon({required bool isFavorite}) {
    if (!isFavorite) {
      return const Icon(
        Icons.star_border,
        key: ValueKey('not-favorite'),
        color: Colors.black,
      );
    }

    return Stack(
      key: const ValueKey('favorite'),
      alignment: Alignment.center,
      children: const [
        Icon(Icons.star_border, color: Colors.black),
        Icon(Icons.star, color: Colors.amber),
      ],
    );
  }

  void _toggleFavorite(Record record) {
    final fromIndex = records.indexOf(record);
    if (fromIndex < 0) return;

    final listState = _listKey.currentState;
    if (listState == null) {
      setState(() {
        record.isFavorite = !record.isFavorite;
        records.sort(_compareRecords);
      });
      return;
    }

    setState(() {
      record.isFavorite = !record.isFavorite;
      records.removeAt(fromIndex);
    });

    listState.removeItem(
      fromIndex,
      (context, animation) => _buildAnimatedRecordItem(record, animation),
      duration: _listAnimDuration,
    );

    final toIndex = _insertionIndexFor(record, records);

    setState(() {
      records.insert(toIndex, record);
    });

    listState.insertItem(toIndex, duration: _listAnimDuration);
  }

  void _deleteRecord(Record record) {
    final index = records.indexOf(record);
    if (index < 0) return;

    final listState = _listKey.currentState;
    if (listState == null) {
      setState(() {
        records.removeAt(index);
      });
      return;
    }

    setState(() {
      records.removeAt(index);
    });

    listState.removeItem(
      index,
      (context, animation) => _buildAnimatedRecordItem(record, animation),
      duration: _listAnimDuration,
    );
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
              final listState = _listKey.currentState;
              if (listState == null) {
                setState(() {
                  records.clear();
                });
                return;
              }

              for (int i = records.length - 1; i >= 0; i--) {
                final removed = records.removeAt(i);
                listState.removeItem(
                  i,
                  (context, animation) =>
                      _buildAnimatedRecordItem(removed, animation),
                  duration: _listAnimDuration,
                );
              }

              setState(() {});
            },
            child: const Text('مسح الكل'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedRecordItem(Record record, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: curved,
        child: InkWell(
          key: ValueKey(record.createdIndex),
          onTap: () {
            Navigator.of(
              context,
            ).push(FadeSlidePageRoute(page: OldRecordScreen(record: record)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  onPressed: () => _toggleFavorite(record),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) {
                      return FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(scale: anim, child: child),
                      );
                    },
                    child: _favoriteIcon(isFavorite: record.isFavorite),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.date,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFE63950),
                  ),
                  onPressed: () => _deleteRecord(record),
                ),
              ],
            ),
          ),
        ),
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
                  : AnimatedList(
                      key: _listKey,
                      initialItemCount: records.length,
                      itemBuilder: (context, index, animation) {
                        final record = records[index];
                        return _buildAnimatedRecordItem(record, animation);
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
                            widget.record.title,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'تفاصيل الترجمة',
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
                    widget.record.audioText,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 13),
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