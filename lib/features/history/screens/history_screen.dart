import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';
import 'package:tsl_mobile_app/core/database/isar_service.dart';
import 'package:tsl_mobile_app/core/services/history_retention_service.dart';
import 'package:tsl_mobile_app/features/history/models/history_record.dart';
import 'package:tsl_mobile_app/features/history/screens/item_history_screen.dart';
import 'package:tsl_mobile_app/features/history/services/history_storage.dart';

// Full-screen wrapper that keeps [HistoryScreen] reusable inside a drawer
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

// History list UI showing all saved records from local storage
class HistoryScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const HistoryScreen({super.key, this.onClose});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryStorage _historyStorage = HistoryStorage(IsarService.instance);
  final Future<HistoryRetentionService> _retentionServiceFuture =
      HistoryRetentionService.create();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');

  List<HistoryRecord> _records = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
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

  // Loads records from Isar and refreshes the list state
  Future<void> _loadRecords() async {
    final retentionService = await _retentionServiceFuture;
    await retentionService.purgeExpiredIfEnabled();
    final records = await _historyStorage.getAllRecords();
    if (!mounted) return;
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  // Toggles the favorite flag for the selected record
  Future<void> _toggleFavorite(HistoryRecord record) async {
    await _historyStorage.toggleFavorite(record.id);
    await _loadRecords();
  }

  // Deletes one record from local storage
  Future<void> _deleteRecord(HistoryRecord record) async {
    await _historyStorage.deleteRecord(record.id);
    await _loadRecords();
  }

  // Asks for confirmation and clears the entire history collection
  Future<void> _clearAllRecords() async {
    await showDialog<void>(
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
            onPressed: () async {
              Navigator.pop(context);
              await _historyStorage.clearAll();
              await _loadRecords();
            },
            child: const Text('مسح الكل'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(HistoryRecord record) {
    return InkWell(
      key: ValueKey(record.id),
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
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              onPressed: () => _toggleFavorite(record),
              icon: _favoriteIcon(isFavorite: record.isFavorite),
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
                      record.recognizedText,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateFormat.format(record.createdAt),
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
              icon: const Icon(Icons.delete_outline, color: Color(0xFFE63950)),
              onPressed: () => _deleteRecord(record),
            ),
          ],
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _records.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد ترجمات مخزنة',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _records.length,
                      itemBuilder: (context, index) =>
                          _buildRecordItem(_records[index]),
                    ),
            ),
            // Clear all button
            if (_records.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () => _clearAllRecords(),
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
